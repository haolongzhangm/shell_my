#define K_FLOAT32 1
#define K_FLOAT16 2
#define K_INT32 3
#define K_INT16 4
#define K_INT8 5
#define K_UINT8 6
#define K_UINT16 7


#define VEC 0
#define VEC_VEC 1
#define VEC_SCALA 2
#define SCALA_VEC 3
#define VEC_BCAST10 4
#define BCAST10_VEC 5
#define VEC_VEC_VEC 6
#define VEC_VEC_SCALA 7
#define BCAST101_VEC_BCAST101 8
#define VEC_BCAST101_VEC 9
#define VEC_SCALA_SCALA 10

#define UNKNOWN_SHAPE -1



#ifndef TYPE_ENUM
#define TYPE_ENUM 1
#endif

#ifdef TYPE
#error "Can not define TYPE in opencl kernel, use TYPE_ENUM"
#endif

#if TYPE_ENUM == 1 || TYPE_ENUM == 2
#define VMIN(a,b) fmin(a, b)
#define VMAX(a,b) fmax(a, b)

#if TYPE_ENUM == 1
#define TYPE float
#else
#define TYPE half
#endif

#else
#define VMIN(a,b) min(a, b)
#define VMAX(a,b) max(a, b)
#endif

#if TYPE_ENUM == 1 || TYPE_ENUM == 2

#define MAX_VALUE FLT_MAX
#define MIN_VALUE -FLT_MAX
#elif TYPE_ENUM == 3

#define MAX_VALUE INT_MAX
#define MIN_VALUE -INT_MAX
#define TYPE int
#elif TYPE_ENUM == 4

#define MAX_VALUE SHRT_MAX
#define MIN_VALUE SHRT_MIN
#define TYPE short
#elif TYPE_ENUM == 5

#define MAX_VALUE CHAR_MAX
#define MIN_VALUE CHAR_MIN
#define TYPE char
#elif TYPE_ENUM == 6

#define MAX_VALUE UCHAR_MAX
#define MIN_VALUE 0
#define TYPE uchar
#else
#error "No support TYPE_ENUM"
#endif


#if OPENCL_ENABLE_FP16
#pragma OPENCL EXTENSION cl_khr_fp16 : enable
#endif
#if OPENCL_ENABLE_DOT_PRODUCT_INT8
#pragma OPENCL EXTENSION cl_arm_integer_dot_product_int8 : enable
#endif
#if OPENCL_ENABLE_DOT_PRODUCT_ACC_INT8
#pragma OPENCL EXTENSION cl_arm_integer_dot_product_accumulate_int8 : enable
#endif
#if OPENCL_ENABLE_DOT_PRODUCT_ACC_INT8
#define ARM_DOT_ACC(a,b,val) val = arm_dot_acc(a, b, val);
#elif OPENCL_ENABLE_DOT_PRODUCT_INT8
#define ARM_DOT_ACC(a,b,val) val += arm_dot(a, b);
#else
#define ARM_DOT_ACC(a,b,val) \
    val += (int)(a.x) * (int)(b.x) + (int)(a.y) * (int)(b.y) + \
           (int)(a.z) * (int)(b.z) + (int)(a.w) * (int)(b.w);
#endif



#if OPENCL_SUPPORT_FMA
#define may_fma fma
#else
#define may_fma mad
#endif


#if OPENCL_ENABLE_DOT_PRODUCT_INT8
#define ARM_DOT(a,b) arm_dot(a, b)
#else
#define ARM_DOT(a,b) \
    ((int)(a.x) * (int)(b.x) + (int)(a.y) * (int)(b.y) + (int)(a.z) * (int)(b.z) + \
     (int)(a.w) * (int)(b.w))
#endif


#define float1 float
#define half1 half
#define int1 int
#define short1 short
#define char1 char
#define uchar1 uchar
#define ushort1 ushort

#define VECTOR_STR(type,size) type ##size
#define VECTOR(type,size) VECTOR_STR(type, size)

#define convert_float1 convert_float
#define convert_half1 convert_half
#define convert_int1 convert_int
#define convert_short1 convert_short
#define convert_char1 convert_char
#define convert_uchar1 convert_uchar
#define convert_ushort1 convert_ushort

#define CONVERT_STR(type,size,v) convert_ ##type ##size(v)
#define CONVERT(type,size,v) CONVERT_STR(type, size, v)

#define convert_float1_sat convert_float_sat
#define convert_half1_sat convert_half_sat
#define convert_int1_sat convert_int_sat
#define convert_short1_sat convert_short_sat
#define convert_char1_sat convert_char_sat
#define convert_uchar1_sat convert_uchar_sat
#define convert_ushort1_sat convert_ushort_sat

#define CONVERT_SAT_STR(type,size,v) convert_ ##type ##size ##_sat(v)
#define CONVERT_SAT(type,size,v) CONVERT_SAT_STR(type, size, v)

#define AS_TYPE_STR(type,size,v) as_ ##type ##size(v)
#define AS_TYPE(type,size,v) AS_TYPE_STR(type, size, v)


#if OPENCL_ENABLE_SUBGROUPS
#pragma OPENCL EXTENSION cl_intel_subgroups : enable


#if TYPE_ENUM == K_FLOAT32

#define INTEL_IMAGE_TYPE uint

#define INTEL_SUB_GROUP_BLOCK_WRITE_STR(size) intel_sub_group_block_write ##size
#define INTEL_SUB_GROUP_BLOCK_WRITE(size) INTEL_SUB_GROUP_BLOCK_WRITE_STR(size)

#define INTEL_SUB_GROUP_BLOCK_READ_STR(size) intel_sub_group_block_read ##size
#define INTEL_SUB_GROUP_BLOCK_READ(size) INTEL_SUB_GROUP_BLOCK_READ_STR(size)

#elif TYPE_ENUM == K_FLOAT16

#define INTEL_IMAGE_TYPE ushort

#define INTEL_SUB_GROUP_BLOCK_WRITE_STR(size) intel_sub_group_block_write_us ##size
#define INTEL_SUB_GROUP_BLOCK_WRITE(size) INTEL_SUB_GROUP_BLOCK_WRITE_STR(size)

#define INTEL_SUB_GROUP_BLOCK_READ_STR(size) intel_sub_group_block_read_us ##size
#define INTEL_SUB_GROUP_BLOCK_READ(size) INTEL_SUB_GROUP_BLOCK_READ_STR(size)
#endif

#endif
#if OPENCL_ENABLE_SUBGROUPS_SHORT
#pragma OPENCL EXTENSION cl_intel_subgroups_short : enable
#endif

#if HALF_FLOAT

#define COMP_TYPE float
#define VLOAD_STR(size,offset,buf) CONVERT(float, size, vload ##size(offset, buf))
#define VLOAD(size,offset,buf) VLOAD_STR(size, offset, buf)
#define VSTORE_STR(size,v,offset,buf) \
    vstore##size(CONVERT(half, size, v), offset, buf)
#define VSTORE(size,v,offset,buf) VSTORE_STR(size, v, offset, buf)

#define read_imagep read_imagef
#define write_imagep write_imagef

#else
#define COMP_TYPE TYPE
#define VLOAD_STR(size,offset,buf) vload ##size(offset, buf)
#define VLOAD(size,offset,buf) VLOAD_STR(size, offset, buf)
#define VSTORE_STR(size,v,offset,buf) vstore ##size(v, offset, buf)
#define VSTORE(size,v,offset,buf) VSTORE_STR(size, v, offset, buf)

#if TYPE_ENUM == K_FLOAT32
#define read_imagep read_imagef
#define write_imagep write_imagef
#elif TYPE_ENUM == K_FLOAT16
#define read_imagep read_imageh
#define write_imagep write_imageh
#elif TYPE_ENUM == K_INT8
#define read_imagep(name,SAMPLER,coord) \
    CONVERT(TYPE, 4, (read_imagei(name, SAMPLER, coord)))
#define write_imagep(name,coord,val) write_imagei(name, coord, CONVERT(int, 4, (val)))
#elif TYPE_ENUM == K_UINT8
#define read_imagep(name,SAMPLER,coord) \
    CONVERT(TYPE, 4, (read_imageui(name, SAMPLER, coord)))
#define write_imagep(name,coord,val) \
    write_imageui(name, coord, CONVERT(uint, 4, (val)))
#elif TYPE_ENUM == K_INT16
#define read_imagep(name,SAMPLER,coord) \
    CONVERT(TYPE, 4, (read_imagei(name, SAMPLER, coord)))
#define write_imagep(name,coord,val) write_imagei(name, coord, CONVERT(int, 4, (val)))
#else
#define read_imagep read_imagei
#define write_imagep write_imagei
#endif

#endif

#define IMMC(x) ((COMP_TYPE)(x))
#define IMM(x) ((TYPE)(x))


#define BUFFER_R(name) __global const TYPE *name, __private const int name ##_offset

#define BUFFER_R_TYPE(name,type) \
    __global const type *name, __private const int name##_offset

#define BUFFER_W(name) __global TYPE *name, __private const int name ##_offset

#define BUFFER_W_TYPE(name,type) __global type *name, __private const int name ##_offset

#define IMAGE_BUFFER_R(name) \
    __global const TYPE *name, __private const int name##_offset, \
            __private const uint name##_lda

#define IMAGE_BUFFER_R_TYPE(name,type) \
    __global const type *name, __private const int name##_offset, \
            __private const uint name##_lda

#define IMAGE_BUFFER_W(name) \
    __global TYPE *name, __private const int name##_offset, \
            __private const uint name##_lda

#define IMAGE_BUFFER_W_TYPE(name,type) \
    __global type *name, __private const int name##_offset, \
            __private const uint name##_lda

#if QUANTIZED_ASYMM
#define BUFFER_QUANTIZED_R(name) \
    __global const TYPE *name, __private const int name##_offset, \
            __private const float name##_scale, __private const uchar name##_zero

#define BUFFER_QUANTIZED_W(name) \
    __global TYPE *name, __private const int name##_offset, \
            __private const float name##_scale, __private const uchar name##_zero

#define IMAGE_BUFFER_QUANTIZED_R(name) \
    __global const TYPE *name, __private const int name##_offset, \
            __private const uint name##_lda, __private const float name##_scale, \
            __private const uchar name##_zero

#define IMAGE_BUFFER_QUANTIZED_W(name) \
    __global TYPE *name, __private const int name##_offset, \
            __private const uint name##_lda, __private const float name##_scale, \
            __private const uchar name##_zero

#elif QUANTIZED
#define BUFFER_QUANTIZED_R(name) \
    __global const TYPE *name, __private const int name##_offset, \
            __private const float name##_scale

#define BUFFER_QUANTIZED_W(name) \
    __global TYPE *name, __private const int name##_offset, \
            __private const float name##_scale

#define IMAGE_BUFFER_QUANTIZED_R(name) \
    __global const TYPE *name, __private const int name##_offset, \
            __private const uint name##_lda, __private const float name##_scale

#define IMAGE_BUFFER_QUANTIZED_W(name) \
    __global TYPE *name, __private const int name##_offset, \
            __private const uint name##_lda, __private const float name##_scale

#endif

#if !QUANTIZED_ASYMM && !QUANTIZED


#define COMPATIBLE_BUFFER_R(name) BUFFER_R(name)
#define COMPATIBLE_BUFFER_W(name) BUFFER_W(name)
#else

#define COMPATIBLE_BUFFER_R(name) BUFFER_QUANTIZED_R(name)
#define COMPATIBLE_BUFFER_W(name) BUFFER_QUANTIZED_W(name)
#endif

#if USE_BUFFER_FOR_IMAGE

#define INIT_IMAGE1(name1) name1 += name1 ##_offset
#define INIT_IMAGE2(name1,name2) \
    name1 += name1##_offset; \
    name2 += name2##_offset
#define INIT_IMAGE3(name1,name2,name3) \
    name1 += name1##_offset; \
    name2 += name2##_offset; \
    name3 += name3##_offset
#define INIT_IMAGE4(name1,name2,name3,name4) \
    name1 += name1##_offset; \
    name2 += name2##_offset; \
    name3 += name3##_offset; \
    name4 += name4##_offset

#if USE_FILTER_AS_IMAGE
#error "can not define USE_FILTER_AS_IMAGE if defined USE_BUFFER_FOR_IMAGE"
#endif

#define IMAGE_R(name) IMAGE_BUFFER_R(name)
#define IMAGE_R_TYPE(name,type) IMAGE_BUFFER_R_TYPE(name, type)
#define IMAGE_W(name) IMAGE_BUFFER_W(name)
#define IMAGE_W_TYPE(name,type) IMAGE_BUFFER_W_TYPE(name, type)
#define IMAGE(name) name, name ##_offset, name ##_lda

#define IMAGE_QUANTIZED_R(name) IMAGE_BUFFER_QUANTIZED_R(name)
#define IMAGE_QUANTIZED_W(name) IMAGE_BUFFER_QUANTIZED_W(name)

#define READ_IMAGE(name,x,y) VLOAD(4, 0, name + (y)*name ##_lda + (x)*4)
#define READ_IMAGE2(name,coord) \
    VLOAD(4, 0, name + (coord.y) * name##_lda + (coord.x) * 4)
#define READ_IMAGE_COND(name,x,y,cond) \
    (cond) ? VLOAD(4, 0, name + (y)*name##_lda + (x)*4) : ((VECTOR(COMP_TYPE, 4))(0))

#define WRITE_IMAGE(name,x,y,val) VSTORE(4, val, 0, name + (y)*name ##_lda + (x)*4)
#define WRITE_IMAGE2(name,coord,val) \
    VSTORE(4, val, 0, name + (coord.y) * name##_lda + (coord.x) * 4)

#define READ_IMAGE_TYPE(name,x,y,type) READ_IMAGE(name, x, y)
#define READ_IMAGE_TYPE2(name,coord,type) READ_IMAGE2(name, coord)
#define READ_IMAGE_TYPE_COND(name,x,y,cond,type) READ_IMAGE_COND(name, x, y, cond)

#else

#define INIT_IMAGE_SAMPLE() \
    const sampler_t SAMPLER = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP;
#define INIT_IMAGE1(name1) INIT_IMAGE_SAMPLE()
#define INIT_IMAGE2(name1,name2) INIT_IMAGE_SAMPLE()
#define INIT_IMAGE3(name1,name2,name3) INIT_IMAGE_SAMPLE()
#define INIT_IMAGE4(name1,name2,name3,name4) INIT_IMAGE_SAMPLE()

#define IMAGE_R(name) __read_only image2d_t name
#define IMAGE_R_TYPE(name,type) IMAGE_R(name)
#define IMAGE_W(name) __write_only image2d_t name
#define IMAGE_W_TYPE(name,type) IMAGE_W(name)
#define IMAGE(name) name


#if QUANTIZED_ASYMM
#define IMAGE_QUANTIZED_R(name) \
    __read_only image2d_t name, __private const float name##_scale, \
            __private const uchar name##_zero
#define IMAGE_QUANTIZED_W(name) \
    __write_only image2d_t name, __private const float name##_scale, \
            __private const uchar name##_zero
#elif QUANTIZED
#define IMAGE_QUANTIZED_R(name) \
    __read_only image2d_t name, __private const float name##_scale
#define IMAGE_QUANTIZED_W(name) \
    __write_only image2d_t name, __private const float name##_scale
#endif

#define READ_IMAGE(name,x,y) read_imagep(name, SAMPLER, (int2)((x), (y)))
#define READ_IMAGE2(name,coord) read_imagep(name, SAMPLER, coord)
#define READ_IMAGE_COND(name,x,y,cond) read_imagep(name, SAMPLER, (int2)((x), (y)))
#define WRITE_IMAGE(name,x,y,val) write_imagep(name, (int2)((x), (y)), val)
#define WRITE_IMAGE2(name,coord,val) write_imagep(name, coord, val)

#define READ_IMAGE_TYPE(name,x,y,type) read_ ##type(name, SAMPLER, (int2)((x), (y)))
#define READ_IMAGE_TYPE2(name,coord,type) read_ ##type(name, SAMPLER, coord)
#define READ_IMAGE_TYPE_COND(name,x,y,cond,type) \
    read_##type(name, SAMPLER, (int2)((x), (y)))

#endif

#if !QUANTIZED_ASYMM && !QUANTIZED


#define COMPATIBLE_IMAGE_R(name) IMAGE_R(name)
#define COMPATIBLE_IMAGE_W(name) IMAGE_W(name)
#else

#define COMPATIBLE_IMAGE_R(name) IMAGE_QUANTIZED_R(name)
#define COMPATIBLE_IMAGE_W(name) IMAGE_QUANTIZED_W(name)
#endif



#ifndef NDIM
#define NDIM 7
#endif

inline int get_offset(uint idx, uint8 shp, int8 strd) {
    int offset = 0;
    uint t = idx;

#define OFFSET(idx) \
    d = t / shp.s##idx; \
    cur = t - d * shp.s##idx; \
    offset += cur * strd.s##idx; \
    t = d;


    uint d, cur;
#if NDIM >= 7
    OFFSET(6)
#endif
#if NDIM >= 6
    OFFSET(5)
#endif
#if NDIM >= 5
    OFFSET(4)
#endif
#if NDIM >= 4
    OFFSET(3)
#endif
#if NDIM >= 3
    OFFSET(2)
#endif
#if NDIM >= 2
    OFFSET(1)
#endif
#if NDIM >= 1
    OFFSET(0)
#endif

#undef OFFSET

    return offset;
}
#define K_FLOAT32 1
#define K_FLOAT16 2
#define K_INT32 3
#define K_INT16 4
#define K_INT8 5
#define K_UINT8 6
#define K_UINT16 7


#define VEC 0
#define VEC_VEC 1
#define VEC_SCALA 2
#define SCALA_VEC 3
#define VEC_BCAST10 4
#define BCAST10_VEC 5
#define VEC_VEC_VEC 6
#define VEC_VEC_SCALA 7
#define BCAST101_VEC_BCAST101 8
#define VEC_BCAST101_VEC 9
#define VEC_SCALA_SCALA 10

#define UNKNOWN_SHAPE -1



#ifndef BLOCK_SIZE
#define BLOCK_SIZE 4
#endif

#ifdef ASYMM_ASYMM
#define QUANTIZED_PARAM \
    , float src_scale, uchar src_zero, float dst_scale, uchar dst_zero
#define CONVERT_OPERATOR(x,ret,SIZE) \
    do { \
        VECTOR(COMPUTE_TYPE, SIZE) \
        src_temp = (CONVERT(COMPUTE_TYPE, SIZE, x) - src_zero) * src_scale * \
                   dst_scale; \
        ret = CONVERT_SAT(DT, SIZE, round(src_temp) + dst_zero); \
    } while (0);
#endif

#ifdef ASYMM_SYMM
#define QUANTIZED_PARAM , float src_scale, uchar src_zero, float dst_scale
#define CONVERT_OPERATOR(x,ret,SIZE) \
    do { \
        VECTOR(COMPUTE_TYPE, SIZE) \
        src_temp = (CONVERT(COMPUTE_TYPE, SIZE, x) - src_zero) * src_scale * \
                   dst_scale; \
        ret = CONVERT_SAT(DT, SIZE, round(src_temp)); \
    } while (0);
#endif

#ifdef ASYMM_OTHER
#define QUANTIZED_PARAM , float src_scale, uchar src_zero
#define CONVERT_OPERATOR(x,ret,SIZE) \
    do { \
        VECTOR(COMPUTE_TYPE, SIZE) \
        src_temp = (CONVERT(COMPUTE_TYPE, SIZE, x) - src_zero) * src_scale; \
        ret = CONVERT(DT, SIZE, src_temp); \
    } while (0);
#endif

#ifdef SYMM_ASYMM
#define QUANTIZED_PARAM , float src_scale, float dst_scale, uchar dst_zero
#define CONVERT_OPERATOR(x,ret,SIZE) \
    do { \
        VECTOR(COMPUTE_TYPE, SIZE) \
        src_temp = CONVERT(COMPUTE_TYPE, SIZE, x) * src_scale * dst_scale; \
        ret = CONVERT_SAT(DT, SIZE, round(src_temp) + dst_zero); \
    } while (0);
#endif

#ifdef SYMM_SYMM
#define QUANTIZED_PARAM , float src_scale, float dst_scale
#define CONVERT_OPERATOR(x,ret,SIZE) \
    do { \
        VECTOR(COMPUTE_TYPE, SIZE) \
        src_temp = CONVERT(COMPUTE_TYPE, SIZE, x) * src_scale * dst_scale; \
        ret = CONVERT_SAT(DT, SIZE, round(src_temp)); \
    } while (0);
#endif

#ifdef SYMM_OTHER
#define QUANTIZED_PARAM , float src_scale
#define CONVERT_OPERATOR(x,ret,SIZE) \
    do { \
        VECTOR(COMPUTE_TYPE, SIZE) \
        src_temp = CONVERT(COMPUTE_TYPE, SIZE, x) * src_scale; \
        ret = CONVERT(DT, SIZE, src_temp); \
    } while (0);
#endif

#ifdef OTHER_ASYMM
#define QUANTIZED_PARAM , float dst_scale, uchar dst_zero
#define CONVERT_OPERATOR(x,ret,SIZE) \
    do { \
        VECTOR(COMPUTE_TYPE, SIZE) \
        src_temp = CONVERT(COMPUTE_TYPE, SIZE, x) * dst_scale; \
        ret = CONVERT(DT, SIZE, round(src_temp) + dst_zero); \
    } while (0);
#endif

#ifdef OTHER_SYMM
#define QUANTIZED_PARAM , float dst_scale
#define CONVERT_OPERATOR(x,ret,SIZE) \
    do { \
        VECTOR(COMPUTE_TYPE, SIZE) \
        src_temp = CONVERT(COMPUTE_TYPE, SIZE, x) * dst_scale; \
        ret = CONVERT(DT, SIZE, round(src_temp)); \
    } while (0);
#endif

#ifndef QUANTIZED_PARAM
#define QUANTIZED_PARAM 
#endif

#ifndef CONVERT_OPERATOR
#define CONVERT_OPERATOR(x,ret,SIZE) ret = CONVERT(DT, SIZE, x);
#endif

#if USE_BUFFER_FOR_IMAGE

#define READ_ST_IMAGE(src,coord) \
    VLOAD(4, 0, src + (coord.y) * src##_lda + (coord.x) * 4)
#define WRITE_DT_IMAGE(dst,coord,out) \
    VSTORE(4, out, 0, dst + (coord.y) * dst##_lda + (coord.x) * 4)

#else

#if ST_ENUM == K_FLOAT32
#define READ_ST_IMAGE(src,coord) \
    CONVERT(ST, 4, (read_imagef(src, SAMPLER, coord)))
#elif ST_ENUM == K_FLOAT16
#define READ_ST_IMAGE(src,coord) \
    CONVERT(ST, 4, (read_imageh(src, SAMPLER, coord)))
#elif ST_ENUM == K_UINT8
#define READ_ST_IMAGE(src,coord) \
    CONVERT(ST, 4, (read_imageui(src, SAMPLER, coord)))
#else
#define READ_ST_IMAGE(src,coord) \
    CONVERT(ST, 4, (read_imagei(src, SAMPLER, coord)))
#endif

#if DT_ENUM == K_FLOAT32
#define WRITE_DT_IMAGE(dst,coord,out) write_imagef(dst, coord, (out))
#elif DT_ENUM == K_FLOAT16
#define WRITE_DT_IMAGE(dst,coord,out) write_imageh(dst, coord, (out))
#elif DT_ENUM == K_UINT8
#define WRITE_DT_IMAGE(dst,coord,out) \
    write_imageui(dst, coord, CONVERT(uint, 4, out))
#else
#define WRITE_DT_IMAGE(dst,coord,out) \
    write_imagei(dst, coord, CONVERT(int, 4, out))
#endif

#endif

__kernel void type_cvt(const __global ST* src, const uint src_offset,
                       __global DT* dst, const uint dst_offset,
                       uint N QUANTIZED_PARAM) {
    src += src_offset;
    dst += dst_offset;
    uint global_id = get_global_id(0);
    uint offset = global_id * BLOCK_SIZE;

    src += offset;
    dst += offset;
    if (offset + BLOCK_SIZE > N) {
        for (uint i = 0; i < N - offset; i++) {
            DT ret;
            CONVERT_OPERATOR(src[i], ret, 1);
            dst[i] = ret;
        }
        return;
    }
    VECTOR(ST, BLOCK_SIZE) src_item = VLOAD(BLOCK_SIZE, 0, src);
    VECTOR(DT, BLOCK_SIZE) ret;
    CONVERT_OPERATOR(src_item, ret, BLOCK_SIZE);
    VSTORE(BLOCK_SIZE, ret, 0, dst);
}

__kernel void type_cvt_general(__global ST* src, uint src_offset,
                               __global DT* dst, uint dst_offset, uint8 src_shp,
                               int8 src_strd, uint8 dst_shp, int8 dst_strd) {
    src += src_offset;
    dst += dst_offset;
    uint idx = get_global_id(0);
    dst[get_offset(idx, dst_shp, dst_strd)] =
            src[get_offset(idx, src_shp, src_strd)];
}


__kernel void type_cvt_nhwcd4(IMAGE_R_TYPE(src, ST), IMAGE_W_TYPE(dst, DT),
                              const int global_size_dim0,
                              const int global_size_dim1,
                              const int wc_size QUANTIZED_PARAM) {
    INIT_IMAGE2(src, dst);

    const int hb = get_global_id(1);
    int wc = get_global_id(0);
    if (wc >= global_size_dim0 || hb >= global_size_dim1)
        return;
    for (; wc < wc_size; wc += global_size_dim0) {
        int2 coord = (int2)(wc, hb);
        VECTOR(ST, 4) in = READ_ST_IMAGE(src, coord);
        VECTOR(DT, 4) out;
        CONVERT_OPERATOR(in, out, 4);
        WRITE_DT_IMAGE(dst, coord, out);

    }
}
