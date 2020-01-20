//
// Book:      OpenCL(R) Programming Guide
// Authors:   Aaftab Munshi, Benedict Gaster, Timothy Mattson, James Fung, Dan Ginsburg
// ISBN-10:   0-321-74964-2
// ISBN-13:   978-0-321-74964-2
// Publisher: Addison-Wesley Professional
// URLs:      http://safari.informit.com/9780132488006/
//            http://www.openclprogrammingguide.com
//

// HelloWorld.cpp
//
//    This is a simple example that demonstrates basic OpenCL setup and
//    use.

#include <iostream>
#include <fstream>
#include <sstream>

#ifdef __APPLE__
#include <OpenCL/cl.h>
#else
#include <CL/cl.h>
#endif

///
//  Constants
//
const long long ARRAY_SIZE = 1024 * 1024 * 15; //60MB

///
//  Create an OpenCL context on the first available platform using
//  either a GPU or CPU depending on what is available.
//
cl_context CreateContext()
{
    cl_int errNum;
    cl_uint numPlatforms;
    cl_platform_id firstPlatformId;
    cl_context context = NULL;

    // First, select an OpenCL platform to run on.  For this example, we
    // simply choose the first available platform.  Normally, you would
    // query for all available platforms and select the most appropriate one.
    errNum = clGetPlatformIDs(1, &firstPlatformId, &numPlatforms);
    if (errNum != CL_SUCCESS || numPlatforms <= 0)
    {
        std::cerr << "Failed to find any OpenCL platforms." << std::endl;
        return NULL;
    }

    // Next, create an OpenCL context on the platform.  Attempt to
    // create a GPU-based context, and if that fails, try to create
    // a CPU-based context.
    cl_context_properties contextProperties[] =
    {
        CL_CONTEXT_PLATFORM,
        (cl_context_properties)firstPlatformId,
        0
    };
    context = clCreateContextFromType(contextProperties, CL_DEVICE_TYPE_GPU,
                                      NULL, NULL, &errNum);
    if (errNum != CL_SUCCESS)
    {
        std::cout << "Could not create GPU context, trying CPU..." << std::endl;
        context = clCreateContextFromType(contextProperties, CL_DEVICE_TYPE_CPU,
                                          NULL, NULL, &errNum);
        if (errNum != CL_SUCCESS)
        {
            std::cerr << "Failed to create an OpenCL GPU or CPU context." << std::endl;
            return NULL;
        }
    }

    return context;
}

///
//  Create a command queue on the first device available on the
//  context
//
cl_command_queue CreateCommandQueue(cl_context context, cl_device_id *device)
{
    cl_int errNum;
    cl_device_id *devices;
    cl_command_queue commandQueue = NULL;
    size_t deviceBufferSize = -1;

    // First get the size of the devices buffer
    errNum = clGetContextInfo(context, CL_CONTEXT_DEVICES, 0, NULL, &deviceBufferSize);
    if (errNum != CL_SUCCESS)
    {
        std::cerr << "Failed call to clGetContextInfo(...,GL_CONTEXT_DEVICES,...)";
        return NULL;
    }

    if (deviceBufferSize <= 0)
    {
        std::cerr << "No devices available.";
        return NULL;
    }

    // Allocate memory for the devices buffer
    devices = new cl_device_id[deviceBufferSize / sizeof(cl_device_id)];
    errNum = clGetContextInfo(context, CL_CONTEXT_DEVICES, deviceBufferSize, devices, NULL);
    if (errNum != CL_SUCCESS)
    {
        delete [] devices;
        std::cerr << "Failed to get device IDs";
        return NULL;
    }

    // In this example, we just choose the first available device.  In a
    // real program, you would likely use all available devices or choose
    // the highest performance device based on OpenCL device queries
    commandQueue = clCreateCommandQueue(context, devices[0], 0, NULL);
    if (commandQueue == NULL)
    {
        delete [] devices;
        std::cerr << "Failed to create commandQueue for device 0";
        return NULL;
    }

    *device = devices[0];
    delete [] devices;
    return commandQueue;
}

///
//  Create an OpenCL program from the kernel source file
//
cl_program CreateProgram(cl_context context, cl_device_id device, const char* fileName)
{
    cl_int errNum;
    cl_program program;

    std::ifstream kernelFile(fileName, std::ios::in);
    if (!kernelFile.is_open())
    {
        std::cerr << "Failed to open file for reading: " << fileName << std::endl;
        return NULL;
    }

    std::ostringstream oss;
    oss << kernelFile.rdbuf();

    std::string srcStdStr = oss.str();
    const char *srcStr = srcStdStr.c_str();
    program = clCreateProgramWithSource(context, 1,
                                        (const char**)&srcStr,
                                        NULL, NULL);
    if (program == NULL)
    {
        std::cerr << "Failed to create CL program from source." << std::endl;
        return NULL;
    }

    errNum = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
    if (errNum != CL_SUCCESS)
    {
        // Determine the reason for the error
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

///
//  Create memory objects used as the arguments to the kernel
//  The kernel takes three arguments: result (output), a (input),
//  and b (input)
//
//bool CreateMemObjects(cl_context context, cl_mem memObjects[3],
//                      float *a, float *b)
//{
//    memObjects[0] = clCreateBuffer(context, CL_MEM_READ_ONLY ,
//                                   sizeof(float) * ARRAY_SIZE, NULL, NULL);
//    memObjects[1] = clCreateBuffer(context, CL_MEM_READ_ONLY,
//                                   sizeof(float) * ARRAY_SIZE, NULL, NULL);
//    if (memObjects[0] == NULL || memObjects[1] == NULL)
//    {
//        std::cerr << "Error creating memory objects." << std::endl;
//        return false;
//    }
//
//    return true;
//}

///
//  Cleanup any created OpenCL resources
//
void Cleanup(cl_context context, cl_command_queue commandQueue,
             cl_program program, cl_kernel kernel, cl_mem memObjects[1])
{
    for (int i = 0; i < 1; i++)
    {
        if (memObjects[i] != 0)
            clReleaseMemObject(memObjects[i]);
    }
    if (commandQueue != 0)
        clReleaseCommandQueue(commandQueue);

    if (kernel != 0)
        clReleaseKernel(kernel);

    if (program != 0)
        clReleaseProgram(program);

    if (context != 0)
        clReleaseContext(context);

}

///
//	main() for HelloWorld example
//
int main(int argc, char** argv)
{
    cl_context context = 0;
    cl_command_queue commandQueue = 0;
    cl_program program = 0;
    cl_device_id device = 0;
    cl_kernel kernel = 0;
    cl_mem memObjects[1] = { 0 };
    cl_int errNum;
    float *hostPtr;
    float *svm_ptr;
    float *result = (float *) malloc(sizeof(float) * ARRAY_SIZE);
    if (result == NULL) {
      printf("malloc failed\n");
      return 1;
    }
    memset(result, 0, sizeof(float) * ARRAY_SIZE);

    // Create an OpenCL context on first available platform
    context = CreateContext();
    if (context == NULL)
    {
        std::cerr << "Failed to create OpenCL context." << std::endl;
        return 1;
    }

    // Create a command-queue on the first device available
    // on the created context
    commandQueue = CreateCommandQueue(context, &device);
    if (commandQueue == NULL)
    {
        Cleanup(context, commandQueue, program, kernel, memObjects);
        return 1;
    }

    // Create OpenCL program from HelloWorld.cl kernel source
    program = CreateProgram(context, device, "one.cl");
    if (program == NULL)
    {
        Cleanup(context, commandQueue, program, kernel, memObjects);
        return 1;
    }

    // Create OpenCL kernel
    kernel = clCreateKernel(program, "hello_one", NULL);
    if (kernel == NULL)
    {
        std::cerr << "Failed to create kernel" << std::endl;
        Cleanup(context, commandQueue, program, kernel, memObjects);
        return 1;
    }

    int test_args = atoi(argv[1]);
    printf("test args: %d\n", test_args);
    if (test_args == 0) {
      printf("test clCreateBuffer and read\n");
      memObjects[0] = clCreateBuffer(context, CL_MEM_READ_WRITE, sizeof(float) *ARRAY_SIZE,NULL,&errNum);
      if (memObjects[0] == NULL)  {
          Cleanup(context, commandQueue, program, kernel, memObjects);
          return 1;
      }
    } else if( test_args == 1) {
      printf("test clCreateBuffer with mmap\n");
      memObjects[0] = clCreateBuffer(context, 
          CL_MEM_READ_WRITE | CL_MEM_ALLOC_HOST_PTR,
          sizeof(float) * ARRAY_SIZE,
          NULL,
          &errNum);
    } else if (test_args == 2) {
      printf("test svm\n");
      svm_ptr =(float *) clSVMAlloc(context, CL_MEM_READ_WRITE, ARRAY_SIZE*sizeof(float), 0);
    } else {
      printf("errr args\n");
      return -1;
    }


    if (test_args == 2) {
      printf("svm set args\n");
      errNum = clSetKernelArgSVMPointer(kernel, 0, (void *)svm_ptr);
    } else {
      printf("other set args\n");
      errNum = clSetKernelArg(kernel, 0, sizeof(cl_mem), &memObjects[0]);
    }
    if (errNum != CL_SUCCESS)
    {
        std::cerr << "Error setting kernel arguments." << std::endl;
        Cleanup(context, commandQueue, program, kernel, memObjects);
        return 1;
    }

    size_t globalWorkSize[1] = { ARRAY_SIZE };
    size_t localWorkSize[1] = { 32 };
    // Queue the kernel up for execution across the array
    errNum = clEnqueueNDRangeKernel(commandQueue, kernel, 1, NULL,
                                    globalWorkSize, localWorkSize,
                                    0, NULL, NULL);
    if (errNum != CL_SUCCESS)
    {
        std::cerr << "Error queuing kernel for execution." << std::endl;
        Cleanup(context, commandQueue, program, kernel, memObjects);
        return 1;
    }

    // Read the output buffer back to the Host
    //hostPtr = (float *)clEnqueueMapBuffer(commandQueue,memObjects[2],CL_TRUE,CL_MAP_WRITE,0,sizeof(float) * ARRAY_SIZE,0, NULL, NULL, &errNum);
    if (test_args == 0) {
      printf("test clCreateBuffer and read\n");
      errNum = clEnqueueReadBuffer(commandQueue, memObjects[0], CL_TRUE,
          0, ARRAY_SIZE * sizeof(float), result,
          0, NULL, NULL);
    } else if( test_args == 1) {
      printf("test clCreateBuffer with mmap\n");
      hostPtr = (float *)clEnqueueMapBuffer(
          commandQueue,
          memObjects[0],
          CL_TRUE,
          CL_MAP_READ,
          0,
          sizeof(float) * ARRAY_SIZE,
          0, NULL, NULL, &errNum);
    } else if (test_args == 2) {
      printf("test svm\n");
      clEnqueueSVMMap(commandQueue, CL_TRUE, CL_MAP_WRITE_INVALIDATE_REGION, svm_ptr, ARRAY_SIZE*sizeof(float), 0, NULL, NULL);
    } else {
      printf("errr args\n");
      return -1;
    }

    if (errNum != CL_SUCCESS)
    {
        std::cerr << "Error reading result buffer." << std::endl;
        Cleanup(context, commandQueue, program, kernel, memObjects);
        return 1;
    }

    // Output the result buffer
    if (test_args == 0) {
      printf("test clCreateBuffer and read\n");
      printf("test result: %f\n", result[ARRAY_SIZE - 3]);
    } else if( test_args == 1) {
      printf("test clCreateBuffer with mmap\n");
      printf("test result: %f\n", hostPtr[ARRAY_SIZE - 3]);
    } else if (test_args == 2) {
      printf("test svm\n");
      printf("test result: %f\n", svm_ptr[ARRAY_SIZE - 3]);
    } else {
      printf("errr args\n");
      return -1;
    }
    getchar();
    std::cout << std::endl;
    std::cout << "Executed program succesfully." << std::endl;
    Cleanup(context, commandQueue, program, kernel, memObjects);


    return 0;
}
