
__kernel void hello_kernel(__global  float *a,
						__global  float *b,
						__global float *result)
{
#pragma OPENCL EXTENSION cl_khr_fp16 : enable
    int gid = get_global_id(0);

    half t = convert_half(*a) * convert_half(*b) - convert_half(0.1245);
    half t0 = convert_half(*b) / 3.1415;
    t = t * t + t ;
    result[gid] = convert_float(t);
}

//__kernel void hello_kernel(__global  float *a,
//						__global  float *b,
//						__global float *result)
//{
//#pragma OPENCL EXTENSION cl_khr_fp16 : enable
//    int gid = get_global_id(0);
//
//    float t = (*a) * (*b) - 0.1245;
//    float t0 = (*b) / 3.1415;
//    t = t * t + t ;
//    result[gid] = (t);
//}
