#include <chrono>
#include <fstream>
#include <iostream>
#include <sstream>
#include <thread>

#ifdef __APPLE__
#include <OpenCL/cl.h>
#else
#include <MCL/cl.h>
#endif

#include <string.h>

const long long ARRAY_SIZE = 1024 * 1024 * 15; // 60MB

//! define a timer
class Timer {
    using clock = ::std::chrono::high_resolution_clock;
    clock::time_point m_start;

public:
    Timer();

    void reset();

    [[nodiscard]] double get_secs() const;
    [[nodiscard]] double get_msecs() const;

    double get_secs_reset();
    double get_msecs_reset();
};

double Timer::get_secs() const {
    auto now = std::chrono::high_resolution_clock::now();
    return ::std::chrono::duration_cast<::std::chrono::nanoseconds>(now -
                                                                    m_start)
                   .count() *
           1e-9;
}
double Timer::get_msecs() const {
    auto now = std::chrono::high_resolution_clock::now();
    return ::std::chrono::duration_cast<::std::chrono::nanoseconds>(now -
                                                                    m_start)
                   .count() *
           1e-6;
}
double Timer::get_secs_reset() {
    auto ret = get_secs();
    reset();
    return ret;
}
double Timer::get_msecs_reset() {
    return get_secs_reset() * 1e3;
}
void Timer::reset() {
    m_start = clock::now();
}
Timer::Timer() {
    reset();
}
cl_context CreateContext() {
  cl_int errNum;
  cl_uint numPlatforms;
  cl_platform_id firstPlatformId;
  cl_context context = NULL;

  errNum = clGetPlatformIDs(1, &firstPlatformId, &numPlatforms);
  if (errNum != CL_SUCCESS || numPlatforms <= 0) {
    std::cerr << "Failed to find any OpenCL platforms." << std::endl;
    return NULL;
  }

  cl_context_properties contextProperties[] = {
      CL_CONTEXT_PLATFORM, (cl_context_properties)firstPlatformId, 0};
  context = clCreateContextFromType(contextProperties, CL_DEVICE_TYPE_GPU, NULL,
                                    NULL, &errNum);
  if (errNum != CL_SUCCESS) {
    std::cout << "Could not create GPU context, trying CPU..." << std::endl;
    context = clCreateContextFromType(contextProperties, CL_DEVICE_TYPE_CPU,
                                      NULL, NULL, &errNum);
    if (errNum != CL_SUCCESS) {
      std::cerr << "Failed to create an OpenCL GPU or CPU context."
                << std::endl;
      return NULL;
    }
  }

  return context;
}

cl_command_queue CreateCommandQueue(cl_context context, cl_device_id *device) {
  cl_int errNum;
  cl_device_id *devices;
  cl_command_queue commandQueue = NULL;
  size_t deviceBufferSize = -1;

  errNum =
      clGetContextInfo(context, CL_CONTEXT_DEVICES, 0, NULL, &deviceBufferSize);
  if (errNum != CL_SUCCESS) {
    std::cerr << "Failed call to clGetContextInfo(...,GL_CONTEXT_DEVICES,...)";
    return NULL;
  }

  if (deviceBufferSize <= 0) {
    std::cerr << "No devices available.";
    return NULL;
  }

  devices = new cl_device_id[deviceBufferSize / sizeof(cl_device_id)];
  errNum = clGetContextInfo(context, CL_CONTEXT_DEVICES, deviceBufferSize,
                            devices, NULL);
  if (errNum != CL_SUCCESS) {
    delete[] devices;
    std::cerr << "Failed to get device IDs";
    return NULL;
  }

  commandQueue = clCreateCommandQueue(context, devices[0], 0, NULL);
  if (commandQueue == NULL) {
    delete[] devices;
    std::cerr << "Failed to create commandQueue for device 0";
    return NULL;
  }

  *device = devices[0];
  delete[] devices;
  return commandQueue;
}

std::string buffer_kernel = R"(
__kernel void hello_one(__global float *a, __global float *fast_out_flag)
{
    int gid = get_global_id(0);
    float fast_out = fast_out_flag[0];
    if (fast_out > 0) {
        return;
    }

    a[gid] = a[gid] + gid % 1000;
}
)";

std::string image_kernel = R"(
__kernel void image_func(__read_only image2d_t src, __write_only image2d_t dst)
{
    const sampler_t sampler = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP | CLK_FILTER_NEAREST;
    int h = get_global_id(0);
    int w = get_global_id(1);

    int2 coord = (int2)(h, w);
    float4 tmp = (float4)(2000.0, 3000.0, 4000.0, 5000.0);
    float4 v = read_imagef(src, sampler, coord);
    v = v + tmp;
    write_imagef(dst, coord, v);
}
)";

cl_program CreateProgram(cl_context context, cl_device_id device,
                         std::string &kernel) {
  cl_int errNum;
  cl_program program;

  const char *srcStr = kernel.c_str();
  program =
      clCreateProgramWithSource(context, 1, (const char **)&srcStr, NULL, NULL);
  if (program == NULL) {
    std::cerr << "Failed to create CL program from source." << std::endl;
    return NULL;
  }

  errNum = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
  if (errNum != CL_SUCCESS) {
    char buildLog[16384];
    clGetProgramBuildInfo(program, device, CL_PROGRAM_BUILD_LOG,
                          sizeof(buildLog), buildLog, NULL);

    std::cerr << "Error in kernel: " << std::endl;
    std::cerr << buildLog;
    clReleaseProgram(program);
    return NULL;
  }

  return program;
}

void Cleanup(cl_context context, cl_command_queue commandQueue,
             cl_program program, cl_kernel kernel) {
  if (commandQueue != 0)
    clReleaseCommandQueue(commandQueue);

  if (kernel != 0)
    clReleaseKernel(kernel);

  if (program != 0)
    clReleaseProgram(program);

  if (context != 0)
    clReleaseContext(context);
}

int main(int argc, char **argv) {
  cl_context context = 0;
  cl_command_queue commandQueue = 0;
  cl_program program = 0;
  cl_program program_image = 0;
  cl_device_id device = 0;
  cl_kernel kernel = 0;
  cl_kernel kernel_image = 0;
  cl_int errNum;
  float *svm_ptr;
  float *svm_ptr_fast_out_flag;

  context = CreateContext();
  if (context == NULL) {
    std::cerr << "Failed to create OpenCL context." << std::endl;
    return 1;
  }

  commandQueue = CreateCommandQueue(context, &device);
  if (commandQueue == NULL) {
    Cleanup(context, commandQueue, program, kernel);
    return 1;
  }

  program = CreateProgram(context, device, buffer_kernel);
  if (program == NULL) {
    Cleanup(context, commandQueue, program, kernel);
    return 1;
  }

  kernel = clCreateKernel(program, "hello_one", NULL);
  if (kernel == NULL) {
    std::cerr << "Failed to create kernel" << std::endl;
    Cleanup(context, commandQueue, program, kernel);
    return 1;
  }

  printf("support test args:\n0: without FINE_GRAIN with map/umap\n1: with "
         "FINE_GRAIN without map/umap\n2: without FINE_GRAIN and without "
         "map/umap\n");
  int test_args = atoi(argv[1]);
  printf("test args: %d\n", test_args);
  // 2 means create without FINE_GRAIN, but now call map/unmap, we find
  // mali GPU do not need map/unmap even create without FINE_GRAIN
  if (test_args == 0 || test_args == 2) {
    printf("test normal svm without FINE_GRAIN\n");
    svm_ptr = (float *)clSVMAlloc(context, CL_MEM_READ_WRITE,
                                  ARRAY_SIZE * sizeof(float), 0);
    svm_ptr_fast_out_flag = (float *)clSVMAlloc(
        context, CL_MEM_READ_WRITE, 1 * sizeof(float), 0);
  } else if (test_args == 1) {
    printf("test svm with FINE_GRAIN\n");
    // svm_ptr = (float *)clSVMAlloc(
    //    context,
    //    CL_MEM_READ_WRITE | CL_MEM_SVM_FINE_GRAIN_BUFFER | CL_MEM_SVM_ATOMICS,
    //    ARRAY_SIZE * sizeof(float), 0);
    svm_ptr = (float *)clSVMAlloc(
        context, CL_MEM_READ_WRITE | CL_MEM_SVM_FINE_GRAIN_BUFFER,
        ARRAY_SIZE * sizeof(float), 0);
    svm_ptr_fast_out_flag = (float *)clSVMAlloc(
        context, CL_MEM_READ_WRITE | CL_MEM_SVM_FINE_GRAIN_BUFFER,
        1 * sizeof(float), 0);
  } else {
    printf("errr args\n");
    return -1;
  }

  printf("init svm value\n");
  if (test_args == 0) {
    printf("call svm map to host contrel\n");
    clEnqueueSVMMap(commandQueue, CL_TRUE, CL_MAP_WRITE_INVALIDATE_REGION,
                    svm_ptr, ARRAY_SIZE * sizeof(float), 0, NULL, NULL);
    clEnqueueSVMMap(commandQueue, CL_TRUE, CL_MAP_WRITE_INVALIDATE_REGION,
                    svm_ptr_fast_out_flag, 1 * sizeof(float), 0, NULL, NULL);
  }

  for (size_t t = 0; t < ARRAY_SIZE; t++) {
    svm_ptr[t] = 1000;
  }
  svm_ptr_fast_out_flag[0] = 0;
  printf("svm set args\n");
  errNum = clSetKernelArgSVMPointer(kernel, 0, (void *)svm_ptr);
  errNum = clSetKernelArgSVMPointer(kernel, 1, (void *)svm_ptr_fast_out_flag);
  if (errNum != CL_SUCCESS) {
    std::cerr << "Error setting kernel arguments." << std::endl;
    Cleanup(context, commandQueue, program, kernel);
    return 1;
  }

  size_t globalWorkSize[1] = {ARRAY_SIZE};
  size_t localWorkSize[1] = {4};
  Timer timer0;
  //! define std::thread to change svm_ptr_fast_out_flag value
  std::thread tt([&svm_ptr_fast_out_flag]() {
          //! get env value to sleep
    char *sleep_time = getenv("SLEEP_TIME");
    if (sleep_time != NULL) {
    Timer print_timer;
      printf("sleep time: %s\n", sleep_time);
      //! sleep sleep_time 
      std::this_thread::sleep_for(std::chrono::milliseconds(atoi(sleep_time)));
      printf("sleep time: %s, use time: %fms\n", sleep_time, print_timer.get_msecs_reset());
    }
    svm_ptr_fast_out_flag[0] = 1;
  });
  errNum = clEnqueueNDRangeKernel(commandQueue, kernel, 1, NULL, globalWorkSize,
                                  localWorkSize, 0, NULL, NULL);
  if (errNum != CL_SUCCESS) {
    std::cerr << "Error queuing kernel for execution." << std::endl;
    Cleanup(context, commandQueue, program, kernel);
    return 1;
  }

  if (test_args == 0) {
    printf("call svm map to host contrel\n");
    clEnqueueSVMMap(commandQueue, CL_TRUE, CL_MAP_WRITE_INVALIDATE_REGION,
                    svm_ptr, ARRAY_SIZE * sizeof(float), 0, NULL, NULL);
    clEnqueueSVMMap(commandQueue, CL_TRUE, CL_MAP_WRITE_INVALIDATE_REGION,
                    svm_ptr_fast_out_flag, 1 * sizeof(float), 0, NULL, NULL);
  }
  clFinish(commandQueue);
  printf("use 0time %fms\n", timer0.get_msecs_reset());

  printf("test result: %f\n", svm_ptr[ARRAY_SIZE - 3]);

  printf("now test image buffer svm\n");
  printf("call clCreateBuffer 0\n");
  cl_mem tmp_mem =
      clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR,
                     4 * 64 * 64 * sizeof(float) * 2, svm_ptr, &errNum);
  if (errNum != CL_SUCCESS) {
    std::cerr << "failed call clCreateBuffer failed from svm ptr" << std::endl;
    Cleanup(context, commandQueue, program, kernel);
    return 1;
  }

  printf("call clCreateBuffer 1\n");
  cl_buffer_region buffer_create_info;
  buffer_create_info.origin = 4 * 64 * 64 * sizeof(float);
  buffer_create_info.size = 4 * 64 * 64 * sizeof(float);
  cl_mem tmp_mem_dst = clCreateSubBuffer(
      tmp_mem, CL_MEM_READ_WRITE | CL_MEM_HOST_NO_ACCESS,
      CL_BUFFER_CREATE_TYPE_REGION, &buffer_create_info, &errNum);
  if (errNum != CL_SUCCESS) {
    std::cerr << "failed call clCreateBuffer failed from svm ptr" << std::endl;
    Cleanup(context, commandQueue, program, kernel);
    return 1;
  }

  cl_image_format image_format = cl_image_format{
      .image_channel_order = CL_RGBA,
      .image_channel_data_type = CL_FLOAT,
  };
  cl_image_desc image_desc;
  memset(&image_desc, 0, sizeof(image_desc));
  image_desc.image_type = CL_MEM_OBJECT_IMAGE2D;
  image_desc.image_height = 64;
  image_desc.image_width = 64;
  image_desc.image_row_pitch = 64 * sizeof(float) * 4;
  image_desc.buffer = tmp_mem;

  printf("create src image from buffer now\n");
  cl_mem img = clCreateImage(context, CL_MEM_READ_WRITE | CL_MEM_HOST_NO_ACCESS,
                             &image_format, &image_desc, nullptr, &errNum);

  if (errNum != CL_SUCCESS) {
    std::cerr
        << "failed call clCreateImage to create src failed from svm ptr/buffer"
        << std::endl;
    Cleanup(context, commandQueue, program, kernel);
    return 1;
  }

  cl_image_desc image_desc_dst;
  memset(&image_desc_dst, 0, sizeof(image_desc_dst));
  image_desc_dst.image_type = CL_MEM_OBJECT_IMAGE2D;
  image_desc_dst.image_height = 64;
  image_desc_dst.image_width = 64;
  image_desc_dst.image_row_pitch = 64 * sizeof(float) * 4;
  image_desc_dst.buffer = tmp_mem_dst;

  printf("create dst image from buffer now\n");
  cl_mem img_dst =
      clCreateImage(context, CL_MEM_READ_WRITE | CL_MEM_HOST_NO_ACCESS,
                    &image_format, &image_desc_dst, nullptr, &errNum);

  if (errNum != CL_SUCCESS) {
    std::cerr << "failed call clCreateImage to create dst failed from svm "
                 "ptr/buffer: errcode: "
              << errNum << std::endl;
    Cleanup(context, commandQueue, program, kernel);
    return 1;
  }

  printf("create image program\n");
  program_image = CreateProgram(context, device, image_kernel);
  if (program_image == NULL) {
    Cleanup(context, commandQueue, program_image, kernel_image);
    return 1;
  }

  // Create OpenCL kernel
  printf("create image kernel\n");
  kernel_image = clCreateKernel(program_image, "image_func", NULL);
  if (kernel_image == NULL) {
    std::cerr << "Failed to create kernel" << std::endl;
    Cleanup(context, commandQueue, program_image, kernel_image);
    return 1;
  }

  printf("set buffer args\n");
  errNum = clSetKernelArg(kernel_image, 0, sizeof(cl_mem), &img);
  errNum = clSetKernelArg(kernel_image, 1, sizeof(cl_mem), &img_dst);
  if (errNum != CL_SUCCESS) {
    std::cerr << "Error setting kernel_image arguments." << std::endl;
    Cleanup(context, commandQueue, program_image, kernel_image);
    return 1;
  }

  size_t globalWorkSizeImage[2] = {64, 64};
  size_t localWorkSizeImage[2] = {1, 1};
  // Queue the kernel up for execution across the array
  Timer timer;
  errNum = clEnqueueNDRangeKernel(commandQueue, kernel_image, 2, NULL,
                                  globalWorkSizeImage, localWorkSizeImage, 0,
                                  NULL, NULL);
  if (errNum != CL_SUCCESS) {
    std::cerr << "Error queuing kernel_image for execution. errcode: " << errNum
              << std::endl;
    Cleanup(context, commandQueue, program_image, kernel_image);
    return 1;
  }

  if (test_args == 0) {
    printf("call svm map to host contrel\n");
    clEnqueueSVMMap(commandQueue, CL_TRUE, CL_MAP_WRITE_INVALIDATE_REGION,
                    svm_ptr, ARRAY_SIZE * sizeof(float), 0, NULL, NULL);
  }
  clFinish(commandQueue);
  auto t = timer.get_msecs_reset();
  printf("use time %fms\n", t);


  int offset = 64 * 64 * 4;
  printf("test offset: %d result: %f %f %f %f\n", offset, svm_ptr[0 + offset],
         svm_ptr[1 + offset], svm_ptr[2 + offset], svm_ptr[3 + offset]);

  offset = offset * 2 - 4;
  printf("test offset: %d result: %f %f %f %f\n", offset, svm_ptr[0 + offset],
         svm_ptr[1 + offset], svm_ptr[2 + offset], svm_ptr[3 + offset]);

  offset = offset + 4;
  printf("test offset: %d result: %f %f %f %f\n", offset, svm_ptr[0 + offset],
         svm_ptr[1 + offset], svm_ptr[2 + offset], svm_ptr[3 + offset]);
  //! add all svm_ptr value
  long long sum = 0;
  for (size_t t = 0; t < ARRAY_SIZE; t++) {
    sum += svm_ptr[t];
  }
  printf("sum: %lld\n", sum);

  std::cout << "Executed program succesfully." << std::endl;
  Cleanup(context, commandQueue, program, kernel);
  Cleanup(context, commandQueue, program_image, kernel_image);

  printf("free svm ptr\n");
  clSVMFree(context, svm_ptr);

  return 0;
}
