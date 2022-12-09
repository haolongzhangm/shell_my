
__kernel void hello_kernel(__global  float *a,
						__global  float *b,
						__global float *result)
{
#pragma OPENCL EXTENSION cl_khr_fp16 : enable
    int gid = get_global_id(0);
#define IMM(x)  (convert_half)(x)

    half t = convert_half(*a);// * convert_half(*b) - convert_half(0.1245);
    half t0 = convert_half(*b);// * convert_half(*b) - convert_half(0.1245);
    //half t0 = convert_half(*b) / 3.1415;
    //t = t * t + t ;
    //half t_r = (t * t0 + t0);
    half t_r = mad(t, t0, t0);
    //half t_r = mad(t, t0, t0);
    //t = (IMM(1.f) / (half_exp(-t) + IMM(1.f)));
    result[gid] = convert_float(t_r);
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
