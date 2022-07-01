#pragma OPENCL EXTENSION cl_khr_3d_image_writes : enable
__kernel void hello_kernel(__read_only image3d_t in1, __read_only image3d_t in2, __write_only image3d_t out) {
  const sampler_t sampler =
      CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP | CLK_FILTER_NEAREST;

  int x = get_global_id(0);
  int y = get_global_id(1);

  float4 src1, src2, dst;

  for (int i = 0; i < 64; i++) {
    int4 coord = {x, y, i, 0};
    src1 = read_imagef(in1, sampler, coord);
    src2 = read_imagef(in1, sampler, coord);
    dst = src1 + src2;
    write_imagef(out, coord, dst);
  }
}
