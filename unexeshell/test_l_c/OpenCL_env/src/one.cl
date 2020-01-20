
__kernel void hello_one(__global float *a)
{
    int gid = get_global_id(0);

    a[gid] = gid % 1000;
}
