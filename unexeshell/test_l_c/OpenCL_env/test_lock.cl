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
#define MIN_VALUE (-INT_MAX)
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



#define SUM 0
#define SUM_SQR 1
#define PRODUCT 2
#define MIN 3
#define MAX 4
#define MEAN 5

#if (MODE == SUM)
#define APPLY(res,in) res += in;
#define APPLY_MERGE(res,in) APPLY(res, in)
#define INIT_VAL 0

#elif (MODE == MEAN)
#define APPLY(res,in) res += in;
#define APPLY_MERGE(res,in) APPLY(res, in)
#define INIT_VAL 0

#elif (MODE == SUM_SQR)
#define APPLY(res,in) res += (in * in);
#define APPLY_MERGE(res,in) res += in;
#define INIT_VAL 0

#elif (MODE == PRODUCT)
#define APPLY(res,in) res *= in;
#define APPLY_MERGE(res,in) APPLY(res, in)
#define INIT_VAL 1

#elif (MODE == MIN)
#define APPLY(res,in) res = min(res, in);
#define APPLY_MERGE(res,in) APPLY(res, in)
#define INIT_VAL MAX_VALUE

#elif (MODE == MAX)
#define APPLY(res,in) res = max(res, in);
#define APPLY_MERGE(res,in) APPLY(res, in)
#define INIT_VAL MIN_VALUE
#endif


#if ARG_INDEX
#define DST_TYPE int
#define INIT_DATA_VEC \
    VECTOR(COMP_TYPE, VEC_SIZE) ret = INIT_VAL; \
    VECTOR(int, VEC_SIZE) index = 0;
#define INIT_DATA_ONE \
    COMP_TYPE ret = INIT_VAL; \
    int index = 0;

#undef APPLY
#undef APPLY_MERGE

#if (MODE == MIN)

#define APPLY(val,val_in,index,index_in,size) \
    do { \
        index = select( \
                index, index_in, \
                (CONVERT(float, size, val) > CONVERT(float, size, val_in))); \
        val = min(val, val_in); \
    } while (0);

#define APPLY_MERGE(val,val_in,index,index_in) \
    do { \
        index = select(index, index_in, \
                       (val > val_in || (val == val_in && index > index_in))); \
        val = min(val, val_in); \
    } while (0);

#else
#define APPLY(val,val_in,index,index_in,size) \
    do { \
        index = select( \
                index, index_in, \
                (CONVERT(float, size, val) < CONVERT(float, size, val_in))); \
        val = max(val, val_in); \
    } while (0);

#define APPLY_MERGE(val,val_in,index,index_in) \
    do { \
        index = select(index, index_in, \
                       (val < val_in || (val == val_in && index > index_in))); \
        val = max(val, val_in); \
    } while (0);
#endif

#define MERGE(a,b,c,d,size) \
    do { \
        VECTOR(float, size) temp_a = CONVERT(float, size, a); \
        VECTOR(float, size) temp_b = CONVERT(float, size, b); \
        APPLY_MERGE(temp_a, temp_b, c, d); \
        a = CONVERT(COMP_TYPE, size, temp_a); \
    } while (0);
#define OP(a,b,c,d,size) APPLY(a, b, c, d, size)
#define OP_MERGE(a,b,c,d,size) MERGE(a, b, c, d, size)
#define GET_RESULT(a,b) b

#if (VEC_SIZE > 4)
#define GENERATE_INDEX(base) \
    VECTOR(int, VEC_SIZE) \
    temp_index = {base, base + 1, base + 2, base + 3, \
                  base + 4, base + 5, base + 6, base + 7};
#else
#define GENERATE_INDEX(base) \
    VECTOR(int, VEC_SIZE) \
    temp_index = {base, base + 1, base + 2, base + 3};
#endif


#else
#define DST_TYPE TYPE
#define INIT_DATA_VEC VECTOR(COMP_TYPE, VEC_SIZE) ret = INIT_VAL;
#define INIT_DATA_ONE COMP_TYPE ret = INIT_VAL;
#define OP(a,b,c,d,size) APPLY(a, b)
#define OP_MERGE(a,b,c,d,size) APPLY_MERGE(a, b)
#if (MODE == MEAN)
#define GET_RESULT(a,b) (DST_TYPE)(a / (float)B)
#else
#define GET_RESULT(a,b) (DST_TYPE)(a)
#endif
#define GENERATE_INDEX(base) 
#endif


#if ARG_INDEX
void inline fuc_reduce(VECTOR(COMP_TYPE, VEC_SIZE) * ret,
                         VECTOR(int, VEC_SIZE) * index) {

    VECTOR(float, VEC_SIZE) temp_ret = CONVERT(float, VEC_SIZE, *ret);
#if VEC_SIZE >= 16
    APPLY_MERGE(temp_ret.lo, temp_ret.hi, (*index).lo, (*index).hi);
#endif
#if VEC_SIZE >= 8
    APPLY_MERGE(temp_ret.s0123, temp_ret.s4567, (*index).s0123, (*index).s4567);
#endif
    APPLY_MERGE(temp_ret.s01, temp_ret.s23, (*index).s01, (*index).s23);
    APPLY_MERGE(temp_ret.s0, temp_ret.s1, (*index).s0, (*index).s1);
    (*ret).s0 = temp_ret.s0;
}
#define OP_FUNCTION(a,b) fuc_reduce(a, b)

#else
void inline fuc_reduce(VECTOR(COMP_TYPE, VEC_SIZE) * ret) {
#if VEC_SIZE >= 16
    APPLY_MERGE((*ret).lo, (*ret).hi);
#endif
#if VEC_SIZE >= 8
    APPLY_MERGE((*ret).s0123, (*ret).s4567);
#endif
    APPLY_MERGE((*ret).s01, (*ret).s23);
    APPLY_MERGE((*ret).s0, (*ret).s1);
}
#define OP_FUNCTION(a,b) fuc_reduce(a)
#endif


__kernel void reduce_C1_merge(const __global TYPE* src, const uint src_offset,
                              __global DST_TYPE* dst, const uint dst_offset,
                              __local COMP_TYPE* local_dst, const uint A,
                              const uint B, const int block_size) {
    uint local_size = get_local_size(0);
    src += src_offset;
    dst += dst_offset;
    uint local_id = get_local_id(0);
    uint group_id = get_group_id(0);
#if ARG_INDEX
    __local int* local_index = (__local int*)(local_dst + local_size);
    int index_base = local_id * block_size;
#endif
    int B_remain = B - local_id * block_size;
    if (B_remain >= block_size) {
        B_remain = block_size;
    }
    INIT_DATA_VEC;
    src += group_id * B + local_id * block_size;
    int i = 0;
    for (; i + VEC_SIZE <= B_remain; i += VEC_SIZE) {
        VECTOR(COMP_TYPE, VEC_SIZE)
        item = CONVERT(COMP_TYPE, VEC_SIZE, VLOAD(VEC_SIZE, 0, src + i));
        GENERATE_INDEX(index_base + i);
        OP(ret, item, index, temp_index, VEC_SIZE);
    }
    OP_FUNCTION(&ret, &index);
    for (; i < B_remain; i++) {
        OP(ret.s0, (COMP_TYPE)src[i], index.s0, index_base + i, 1);
    }
    local_dst[local_id] = ret.s0;
#if ARG_INDEX
    local_index[local_id] = index.s0;
#endif
    barrier(CLK_LOCAL_MEM_FENCE);





#ifdef USE_ASYNC_MERGE
    for (int i = local_size >> 1; i > 0; i = i >> 1) {
        if (local_id < i) {
            OP_MERGE(local_dst[local_id], local_dst[local_id + i],
                               local_index[local_id], local_index[local_id + i],
                               1);
        }
        barrier(CLK_LOCAL_MEM_FENCE);
    }

    if (local_id == 0) {
        dst[group_id] = GET_RESULT(local_dst[0], local_index[0]);
    }
#else
    if (local_id == 0) {
        INIT_DATA_VEC;
        int i = 0;
#pragma unroll
        for (; i + VEC_SIZE <= local_size; i += VEC_SIZE) {
            VECTOR(COMP_TYPE, VEC_SIZE)
            in = CONVERT(COMP_TYPE, VEC_SIZE,
                         VLOAD(VEC_SIZE, 0, local_dst + i));
#if ARG_INDEX
            VECTOR(int, VEC_SIZE)
            in_index = VLOAD(VEC_SIZE, 0, local_index + i);
#endif
            OP_MERGE(ret, in, index, in_index, VEC_SIZE);
        }
        OP_FUNCTION(&ret, &index);
        for (; i < local_size; i++) {
            OP(ret.s0, (COMP_TYPE)local_dst[i], index.s0, local_index[i], 1);
        }
        dst[group_id] = GET_RESULT(ret.s0, index.s0);
    }
#endif
}

__kernel void reduce_C1_linear(const __global TYPE* src, const uint src_offset,
                               __global DST_TYPE* dst, const uint dst_offset,
                               const uint A, const uint B) {
    uint it = get_global_id(0);
    src += (src_offset + it * B);
    dst += dst_offset;
    if (it >= A)
        return;
    INIT_DATA_VEC;
    int i = 0;
    for (; i + VEC_SIZE <= B; i += VEC_SIZE) {
        VECTOR(COMP_TYPE, VEC_SIZE)
        item = CONVERT(COMP_TYPE, VEC_SIZE, VLOAD(VEC_SIZE, 0, src + i));
        GENERATE_INDEX(i);
        OP(ret, item, index, temp_index, VEC_SIZE);
    }
    OP_FUNCTION(&ret, &index);
    for (; i < B; i++) {
        OP(ret.s0, (COMP_TYPE)src[i], index.s0, i, 1);
    }
    dst[it] = GET_RESULT(ret.s0, index.s0);
}





__kernel void reduce(const __global TYPE* src, const uint src_offset,
                     __global DST_TYPE* dst, const uint dst_offset,
                     const uint A, const uint B, const uint C,
                     const uint item_per_row) {
    src += src_offset;
    dst += dst_offset;
    uint local_id = get_local_id(0);
    uint global_id = get_global_id(0);

    uint A_idx = global_id / item_per_row;
    uint A_offset = global_id - A_idx * item_per_row;
    __global const TYPE* local_src = src + B * C * A_idx + A_offset * VEC_SIZE;

    if (C < VEC_SIZE) {
        for (int i = 0; i < C; i++) {
            INIT_DATA_ONE;
            for (int j = 0; j < B; j++) {
                OP(ret, (COMP_TYPE)local_src[j * C + i], index, j, 1);
            }
            dst[A_idx * C + i] = GET_RESULT(ret, index);
        }
        return;
    }

    uint C_remain = C - A_offset * VEC_SIZE;
    if (C_remain >= VEC_SIZE) {
        C_remain = 0;
    } else {
        local_src = local_src - (VEC_SIZE - C_remain);
    }
    INIT_DATA_VEC;
    for (int i = 0; i < B; i++) {
        VECTOR(COMP_TYPE, VEC_SIZE)
        item = CONVERT(COMP_TYPE, VEC_SIZE,
                       VLOAD(VEC_SIZE, 0, local_src + i * C));
        OP(ret, item, index, i, VEC_SIZE);
    }
#if ARG_INDEX
    VECTOR(DST_TYPE, VEC_SIZE) sum = index;
#elif MODE == MEAN
    VECTOR(COMP_TYPE, VEC_SIZE)
    sum = CONVERT(COMP_TYPE, VEC_SIZE,
                  CONVERT(float, VEC_SIZE, ret) / (float)B);
#else
    VECTOR(COMP_TYPE, VEC_SIZE) sum = ret;
#endif

    if (C_remain) {






#define SET_DST(i) \
    if (i >= VEC_SIZE - C_remain) \
    dst[A_idx * C + A_offset * VEC_SIZE + C_remain + i - VEC_SIZE] = sum.s##i
#define SET_DST_(i,name) \
    if (i >= VEC_SIZE - C_remain) \
    dst[A_idx * C + A_offset * VEC_SIZE + C_remain + i - VEC_SIZE] = sum.s##name
#if (VEC_SIZE >= 4)
        SET_DST(0);
        SET_DST(1);
        SET_DST(2);
        SET_DST(3);
#endif
#if (VEC_SIZE >= 8)
        SET_DST(4);
        SET_DST(5);
        SET_DST(6);
        SET_DST(7);
#endif
#if (VEC_SIZE >= 16)
        SET_DST(8);
        SET_DST(9);
        SET_DST_(10, a);
        SET_DST_(11, b);
        SET_DST_(12, c);
        SET_DST_(13, d);
        SET_DST_(14, e);
        SET_DST_(15, f);
#endif
    } else {
        VSTORE(VEC_SIZE, CONVERT(DST_TYPE, VEC_SIZE, sum), 0,
               dst + A_idx * C + A_offset * VEC_SIZE);
    }
}

