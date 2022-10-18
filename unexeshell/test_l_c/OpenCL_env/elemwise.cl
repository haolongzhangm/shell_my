#define RELU 0
#define ABS 1
#define ACOS 2
#define ASIN 3
#define CEIL 4
#define COS 5
#define EXP 6
#define EXPM1 7
#define FLOOR 8
#define LOG 9
#define LOG1P 10
#define NEGATE 11
#define SIGMOID 12
#define SIN 13
#define TANH 14
#define ABS_GRAD 15
#define ADD 16
#define FLOOR_DIV 17
#define MAX 18
#define MIN 19
#define MOD 20
#define MUL 21
#define POW 22
#define SIGMOID_GRAD 23
#define SUB 24
#define SWITCH_GT0 25
#define TANH_GRAD 26
#define TRUE_DIV 27
#define LOG_SUM_EXP 28
#define LT 29
#define LEQ 30
#define EQ 31
#define SHL 32
#define SHR 33
#define COND_LEQ_MOV 34
#define FUSE_MUL_ADD3 35
#define FUSE_MUL_ADD4 36
#define FUSE_ADD_RELU 37
#define FUSE_ADD_SIGMOID 38
#define FUSE_ADD_TANH 39
#define FAST_TANH 40
#define FAST_TANH_GRAD 41
#define ROUND 42
#define RMULH 43
#define ATAN2 44
#define ERF 45
#define ERFINV 46
#define ERFC 47
#define ERFCINV 48
#define H_SWISH 49
#define H_SWISH_GRAD 50
#define FUSE_ADD_H_SWISH 51
#define NOT 52
#define AND 53
#define OR 54
#define XOR 55
#define SILU 56
#define SILU_GRAD 57
#define GELU 58
#define GELU_GRAD 59
#define COND_LT_MOV 60
#define NEQ 61
#define ISNAN 62
#define ISINF 63
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
#define INT_MIN_FIX_QCOM -INT_MAX



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
#define MIN_VALUE INT_MIN_FIX_QCOM
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





#define OTHER 0
#define FLOAT 1
#define INT 2

#define VLOADN__(size) vload ##size
#define VLOADN_(size) VLOADN__(size)
#define VLOADN VLOADN_(VEC_SIZE)

#define VSTOREN__(size) vstore ##size
#define VSTOREN_(size) VSTOREN__(size)
#define VSTOREN VSTOREN_(VEC_SIZE)

#define VEC_DATA_TYPE_STR(type,size) type ##size
#define VEC_DATA_TYPE(type,size) VEC_DATA_TYPE_STR(type, size)
#define VEC_TYPE VEC_DATA_TYPE(TYPE, VEC_SIZE)

#ifndef MODE

#define MODE -1
#endif


#if ARITY == 1

#if MODE == NEGATE
#define OP(x) (-x)
#elif MODE == RELU
#define OP(x) (x <= IMM(0) ? IMM(0) : x)
#elif MODE == ABS
#define OP(x) (x >= IMM(0) ? x : -x)


#elif MODE == ACOS
#define OP(x) acos(x)
#elif MODE == ASIN
#define OP(x) asin(x)
#elif MODE == CEIL
#define OP(x) ceil(x)
#elif MODE == COS
#define OP(x) cos(x)
#elif MODE == EXP
#define OP(x) exp(x)
#elif MODE == EXPM1
#define OP(x) expm1(x)
#elif MODE == FLOOR
#define OP(x) floor(x)
#elif MODE == LOG
#define OP(x) log(x)
#elif MODE == LOG1P
#define OP(x) log1p(x)
#elif MODE == SIGMOID
#define OP(x) (IMM(1.f) / (exp(-x) + IMM(1.f)))
#elif MODE == SIN
#define OP(x) sin(x)
#elif MODE == TANH
#define OP(x) tanh(x)
#elif MODE == FAST_TANH

#define OP(x) (x * (IMM(8.f / 3.f) / (IMM(3.f) + x * x) + IMM(1.f / 9.f)))
#elif MODE == ROUND
#define OP(x) round(x)
#elif MODE == H_SWISH
#define OP(x) (x * (fmin(fmax(x + IMM(3.f), IMM(0.f)), IMM(6.f))) / IMM(6.f))
#elif MODE == SILU
#define OP(x) (x / (exp(-x) + IMM(1.f)))
#elif MODE == GELU
#define OP(x) (IMM(0.5f) * x * (IMM(1.f) + erf(x / IMM(1.414213f))))
#elif !defined(OP)
#error "unknown mode for elemwise arity1"
#endif

#if INPUT_SHAPE == UNKNOWN_SHAPE
__kernel void elemwise_arity1_naive(
        const __global TYPE* src1, const uint src1_offset, __global TYPE* dst,
        const uint dst_offset, const uint8 shape1, const int8 stride1) {
    src1 += src1_offset;
    dst += dst_offset;
    uint idx = get_global_id(0);
    TYPE x = src1[get_offset(idx, shape1, stride1)];
    dst[idx] = OP(x);
}
__kernel void elemwise_arity1_naive_nhwcd4(
        const __global TYPE* src1, const uint src1_offset, __global TYPE* dst,
        const uint dst_offset, const uint8 shape1, const int8 stride1,
        const uint8 dst_shape, const int8 dst_stride) {
    src1 += src1_offset;
    dst += dst_offset;
    uint idx = get_global_id(0);
    TYPE x = src1[get_offset(idx, shape1, stride1)];
    dst[get_offset(idx, dst_shape, dst_stride)] = OP(x);
}
#endif

#if INPUT_SHAPE == VEC
__kernel void elemwise_arity1_vec(
        const __global TYPE* src1, const uint src1_offset, __global TYPE* dst,
        const uint dst_offset, const uint size) {
    src1 += src1_offset;
    dst += dst_offset;
    uint offset = get_global_id(0) * VEC_SIZE;
    int remain = size - offset;
    if (remain >= VEC_SIZE) {
        VEC_TYPE item1 = VLOADN(0, src1 + offset);
        VEC_TYPE res = OP(item1);
        VSTOREN(res, 0, dst + offset);
    } else {
        for (int idx = 0; idx < remain; idx++) {
            TYPE item1 = src1[offset + idx];
            dst[offset + idx] = OP(item1);
        }
    }
}

#if TYPE_ENUM == K_FLOAT32 || TYPE_ENUM == K_FLOAT16
__kernel void elemwise_arity1_vec_nhwcd4(
        IMAGE_R(src), IMAGE_W(dst), __private const int global_size_dim0,
        __private const int global_size_dim1, __private const int wc_size,
        __private const int hb_size) {
    INIT_IMAGE2(src, dst);
    int hb = get_global_id(1);
    int wc = get_global_id(0);

#ifndef NON_UNIFORM_WORK_GROUP
    if (wc >= global_size_dim0 || hb >= global_size_dim1)
        return;
#endif

    for (; hb < hb_size; hb += global_size_dim1) {
        for (; wc < wc_size; wc += global_size_dim0) {
            int2 coord = (int2)(wc, hb);
            VECTOR(TYPE, 4) in = READ_IMAGE2(src, coord);
            VECTOR(TYPE, 4) out = OP(in);
            WRITE_IMAGE2(dst, coord, out);
        }
        wc = get_global_id(0);
    }
}
#endif
#endif


#elif ARITY == 2

#if MODE == ABS_GRAD
#define COMPUTE(x,y) (x > IMM(0) ? y : -y)
#elif MODE == ADD
#define COMPUTE(x,y) (x + y)
#elif MODE == MAX

#if CATEGORY == INT
#define COMPUTE(x,y) max(x, y)
#else
#define COMPUTE(x,y) fmax(x, y)
#endif

#elif MODE == MIN
#if CATEGORY == INT
#define COMPUTE(x,y) min(x, y)
#else
#define COMPUTE(x,y) fmin(x, y)
#endif

#elif MODE == MUL
#define COMPUTE(x,y) (x * y)
#elif MODE == SIGMOID_GRAD
#define COMPUTE(x,y) (x * (IMM(1) - x) * y)
#elif MODE == SUB
#define COMPUTE(x,y) (x - y)
#elif MODE == SWITCH_GT0
#define COMPUTE(x,y) (x > IMM(0) ? y : IMM(0))
#elif MODE == TANH_GRAD
#define COMPUTE(x,y) ((IMM(1) - x * x) * y)
#elif MODE == LT




#define COMPUTE(x,y) (x < y ? IMM(1) : x * IMM(0))
#elif MODE == LEQ
#define COMPUTE(x,y) (x <= y ? IMM(1) : x * IMM(0))
#elif MODE == EQ
#define COMPUTE(x,y) (x == y ? IMM(1) : x * IMM(0))
#elif MODE == FLOOR_DIV

#if CATEGORY == INT
#define COMPUTE(x,y) \
    ((x / y) - (((x ^ y) >= IMM(0)) ? IMM(0) : (((x % y) != IMM(0)) ? IMM(1) : IMM(0))))
#else
#define COMPUTE(x,y) floor(x / y)
#endif

#elif MODE == MOD

#if CATEGORY == INT
#define COMPUTE(x,y) (x % y)
#else
#define COMPUTE(x,y) fmod(x, y)
#endif

#elif MODE == FUSE_ADD_RELU


#define COMPUTE(x,y) (x <= -y ? IMM(0) : (x + y))


#elif MODE == SHL
#define COMPUTE(x,y) (x << y)
#elif MODE == SHR
#define COMPUTE(x,y) (x >> y)


#elif MODE == TRUE_DIV
#define COMPUTE(x,y) x / y
#elif MODE == POW
#define COMPUTE(x,y) pow(x, y)
#elif MODE == LOG_SUM_EXP
#define COMPUTE(x,y) ((x < y ? y : x) + log1p(exp(x < y ? x - y : y - x)))

#elif MODE == FAST_TANH_GRAD
#define COMPUTE(x,y) \
    (y * ((IMM(8.f / 3.f) / (IMM(3.f) + x * x) + IMM(1.f / 9.f)) - \
          IMM(16.f / 3.f) * x * (x / ((IMM(3.f) + x * x) * (IMM(3.f) + x * x)))))

#elif MODE == FUSE_ADD_TANH
#define COMPUTE(x,y) tanh(x + y)
#elif MODE == FUSE_ADD_SIGMOID
#define COMPUTE(x,y) (IMM(1.f) / (exp(-(x + y)) + IMM(1.f)))
#elif MODE == ATAN2
#define COMPUTE(y,x) atan2(y, x)
#elif MODE == H_SWISH_GRAD
#define COMPUTE(x,y) \
    x < IMM(-3.f) ? IMM(0.f) \
                  : (x > IMM(3.f) ? y : (IMM(2.f) * x + IMM(3.f)) / IMM(6.f) * y)
#elif MODE == FUSE_ADD_H_SWISH
#define COMPUTE(x,y) \
    ((x + y) * (fmin(fmax((x + y) + IMM(3.f), IMM(0.f)), IMM(6.f))) / IMM(6.f))
#elif !defined(COMPUTE)
#error "unknown mode for elemwise arity2"
#endif

#if QUANTIZED_ASYMM
#define OP(x,y,res,SIZE) \
    do { \
        VECTOR(float, SIZE) \
        temp0 = (CONVERT(float, SIZE, x) - src1_zero) * src1_scale; \
        VECTOR(float, SIZE) \
        temp1 = (CONVERT(float, SIZE, y) - src2_zero) * src2_scale; \
        VECTOR(float, SIZE) out_temp = COMPUTE(temp0, temp1); \
        out_temp = round(out_temp * dst_scale) + dst_zero; \
        res = CONVERT_SAT(TYPE, SIZE, out_temp); \
    } while (0)
#elif QUANTIZED
#define OP(x,y,res,SIZE) \
    do { \
        VECTOR(float, SIZE) \
        temp0 = CONVERT(float, SIZE, x) * src1_scale; \
        VECTOR(float, SIZE) \
        temp1 = CONVERT(float, SIZE, y) * src2_scale; \
        VECTOR(float, SIZE) out_temp = COMPUTE(temp0, temp1); \
        out_temp = round(out_temp * dst_scale); \
        res = CONVERT_SAT(TYPE, SIZE, out_temp); \
    } while (0)
#else
#define OP(x,y,res,SIZE) res = COMPUTE(x, y);
#endif

#if INPUT_SHAPE == UNKNOWN_SHAPE
__kernel void elemwise_arity2_naive(
        COMPATIBLE_BUFFER_R(src1), COMPATIBLE_BUFFER_R(src2), COMPATIBLE_BUFFER_W(dst),
        const uint8 shape1, const int8 stride1, const uint8 shape2,
        const int8 stride2) {
    src1 += src1_offset;
    src2 += src2_offset;
    dst += dst_offset;
    uint idx = get_global_id(0);
    TYPE x = src1[get_offset(idx, shape1, stride1)],
         y = src2[get_offset(idx, shape2, stride2)];
    TYPE res = 0;
    OP(x, y, res, 1);
    dst[idx] = res;
}

__kernel void elemwise_arity2_naive_nhwcd4(
        COMPATIBLE_BUFFER_R(src1), COMPATIBLE_BUFFER_R(src2), COMPATIBLE_BUFFER_W(dst),
        const uint8 shape1, const int8 stride1, const uint8 shape2, const int8 stride2,
        const uint8 dst_shape, const int8 dst_stride) {
    src1 += src1_offset;
    src2 += src2_offset;
    dst += dst_offset;
    uint idx = get_global_id(0);
    TYPE x = src1[get_offset(idx, shape1, stride1)],
         y = src2[get_offset(idx, shape2, stride2)];
    TYPE res;
    OP(x, y, res, 1);
    dst[get_offset(idx, dst_shape, dst_stride)] = res;
}
#endif

#if INPUT_SHAPE == VEC_VEC
__kernel void elemwise_arity2_vec_vec(
        COMPATIBLE_BUFFER_R(src1), COMPATIBLE_BUFFER_R(src2), COMPATIBLE_BUFFER_W(dst),
        const uint size) {
    src1 += src1_offset;
    src2 += src2_offset;
    dst += dst_offset;
    uint offset = get_global_id(0) * VEC_SIZE;
    int remain = size - offset;
    if (remain >= VEC_SIZE) {
        VEC_TYPE item1 = VLOADN(0, src1 + offset);
        VEC_TYPE item2 = VLOADN(0, src2 + offset);
        VEC_TYPE res;
        OP(item1, item2, res, VEC_SIZE);
        VSTOREN(res, 0, dst + offset);
    } else {
        for (int idx = 0; idx < remain; idx++) {
            TYPE item1 = src1[offset + idx];
            TYPE item2 = src2[offset + idx];
            TYPE res;
            OP(item1, item2, res, 1);
            dst[offset + idx] = res;
        }
    }
}

__kernel void elemwise_arity2_vec_vec_nhwcd4(
        COMPATIBLE_IMAGE_R(src1), COMPATIBLE_IMAGE_R(src2), COMPATIBLE_IMAGE_W(dst),
        __private const int global_size_dim0, __private const int global_size_dim1,
        __private const int wc_size, private const int hb_size) {
    INIT_IMAGE3(src1, src2, dst);
    int wc = get_global_id(0);
    int hb = get_global_id(1);

#ifndef NON_UNIFORM_WORK_GROUP
    if (wc >= global_size_dim0 || hb >= global_size_dim1)
        return;
#endif

    for (; hb < hb_size; hb += global_size_dim1) {
        for (; wc < wc_size; wc += global_size_dim0) {
            int2 coord = (int2)(wc, hb);
            VECTOR(TYPE, 4) in1 = READ_IMAGE2(src1, coord);
            VECTOR(TYPE, 4) in2 = READ_IMAGE2(src2, coord);
            VECTOR(TYPE, 4) out;
            OP(in1, in2, out, VEC_SIZE);
            WRITE_IMAGE2(dst, coord, out);
        }
        wc = get_global_id(0);
    }
}
#endif

#if INPUT_SHAPE == VEC_SCALA
__kernel void elemwise_arity2_vec_scala(
        COMPATIBLE_BUFFER_R(src1), COMPATIBLE_BUFFER_R(src2), COMPATIBLE_BUFFER_W(dst),
        const uint size) {
    src1 += src1_offset;
    src2 += src2_offset;
    dst += dst_offset;
    uint offset = get_global_id(0) * VEC_SIZE;
    int remain = size - offset;
    if (remain >= VEC_SIZE) {
        VEC_TYPE item1 = VLOADN(0, src1 + offset);
        VEC_TYPE item2 = src2[0];
        VEC_TYPE res;
        OP(item1, item2, res, VEC_SIZE);
        VSTOREN(res, 0, dst + offset);
    } else {
        TYPE item2 = src2[0];
        for (int idx = 0; idx < remain; idx++) {
            TYPE item1 = src1[offset + idx];
            TYPE res;
            OP(item1, item2, res, 1);
            dst[offset + idx] = res;
        }
    }
}

__kernel void elemwise_arity2_vec_scala_nhwcd4(
        COMPATIBLE_IMAGE_R(src1), COMPATIBLE_BUFFER_R(src2), COMPATIBLE_IMAGE_W(dst),
        __private const int global_size_dim0, __private const int global_size_dim1,
        __private const int wc_size, __private const int hb_size) {
    INIT_IMAGE2(src1, dst);
    int wc = get_global_id(0);
    int hb = get_global_id(1);
    src2 += src2_offset;

#ifndef NON_UNIFORM_WORK_GROUP
    if (wc >= global_size_dim0 || hb >= global_size_dim1)
        return;
#endif

    for (; hb < hb_size; hb += global_size_dim1) {
        for (; wc < wc_size; wc += global_size_dim0) {
            VECTOR(TYPE, 4) in1 = READ_IMAGE(src1, wc, hb);
            VECTOR(TYPE, 4) in2 = (VECTOR(TYPE, 4))(src2[0]);
            VECTOR(TYPE, 4) out;
            OP(in1, in2, out, VEC_SIZE);
            WRITE_IMAGE(dst, wc, hb, out);
        }
        wc = get_global_id(0);
    }
}
#endif

#if INPUT_SHAPE == SCALA_VEC
__kernel void elemwise_arity2_scala_vec(
        COMPATIBLE_BUFFER_R(src1), COMPATIBLE_BUFFER_R(src2), COMPATIBLE_BUFFER_W(dst),
        const uint size) {
    src1 += src1_offset;
    src2 += src2_offset;
    dst += dst_offset;
    uint offset = get_global_id(0) * VEC_SIZE;
    int remain = size - offset;
    if (remain >= VEC_SIZE) {
        VEC_TYPE item1 = src1[0];
        VEC_TYPE item2 = VLOADN(0, src2 + offset);
        VEC_TYPE res;
        OP(item1, item2, res, VEC_SIZE);
        VSTOREN(res, 0, dst + offset);
    } else {
        TYPE item1 = src1[0];
        for (int idx = 0; idx < remain; idx++) {
            TYPE item2 = src2[offset + idx];
            TYPE res;
            OP(item1, item2, res, 1);
            dst[offset + idx] = res;
        }
    }
}

__kernel void elemwise_arity2_scala_vec_nhwcd4(
        COMPATIBLE_BUFFER_R(src1), COMPATIBLE_IMAGE_R(src2), COMPATIBLE_IMAGE_W(dst),
        __private const int global_size_dim0, __private const int global_size_dim1,
        __private const int wc_size, __private const int hb_size) {
    INIT_IMAGE2(src2, dst);
    int wc = get_global_id(0);
    int hb = get_global_id(1);
    src1 += src1_offset;

#ifndef NON_UNIFORM_WORK_GROUP
    if (wc >= global_size_dim0 || hb >= global_size_dim1)
        return;
#endif

    for (; hb < hb_size; hb += global_size_dim1) {
        for (; wc < wc_size; wc += global_size_dim0) {
            int2 coord = (int2)(wc, hb);
            VECTOR(TYPE, 4) in1 = (VECTOR(TYPE, 4))(src1[0]);
            VECTOR(TYPE, 4) in2 = READ_IMAGE2(src2, coord);
            VECTOR(TYPE, 4) out;
            OP(in1, in2, out, VEC_SIZE);
            WRITE_IMAGE2(dst, coord, out);
        }
        wc = get_global_id(0);
    }
}
#endif

#if INPUT_SHAPE == VEC_BCAST10
__kernel void elemwise_arity2_vec_bcast10(
        COMPATIBLE_BUFFER_R(src1), COMPATIBLE_BUFFER_R(src2), COMPATIBLE_BUFFER_W(dst),
        const uint size, const uint c_size, const uint hw_size) {
    src1 += src1_offset;
    src2 += src2_offset;
    dst += dst_offset;
    uint it = get_global_id(0) * VEC_SIZE;
    if (it >= size)
        return;
    uint channel_idx = it / hw_size % c_size;
    uint channel_end_idx = (it / hw_size + 1) * hw_size;
    if (it + VEC_SIZE <= channel_end_idx) {
        VEC_TYPE item1 = VLOADN(0, src1 + it);
        VEC_TYPE item2 = src2[channel_idx];
        VEC_TYPE res;
        OP(item1, item2, res, VEC_SIZE);
        VSTOREN(res, 0, dst + it);
    } else {
        uint it_end = (size < it + VEC_SIZE ? size : it + VEC_SIZE);
        while (it < it_end) {
            TYPE item1 = src1[it];
            TYPE item2 = src2[it / hw_size % c_size];
            TYPE res;
            OP(item1, item2, res, 1);
            dst[it] = res;
            ++it;
        }
    }
}

__kernel void elemwise_arity2_vec_bcast10_nhwcd4(
        COMPATIBLE_IMAGE_R(src1), COMPATIBLE_IMAGE_R(src2), COMPATIBLE_IMAGE_W(dst),
        __private const int global_size_dim0, __private const int global_size_dim1,
        __private const int wc_size, __private const int hb_size,
        __private const uint w_size) {
    INIT_IMAGE3(src1, src2, dst);
    int wc = get_global_id(0);
    int hb = get_global_id(1);

#ifndef NON_UNIFORM_WORK_GROUP
    if (wc >= global_size_dim0 || hb >= global_size_dim1)
        return;
#endif

    for (; hb < hb_size; hb += global_size_dim1) {
        for (; wc < wc_size; wc += global_size_dim0) {
            int2 coord = (int2)(wc, hb);
            int chan_blk_idx = wc / w_size;
            VECTOR(TYPE, 4) in1 = READ_IMAGE2(src1, coord);
            VECTOR(TYPE, 4) in2 = READ_IMAGE(src2, chan_blk_idx, 0);
            VECTOR(TYPE, 4) out;
            OP(in1, in2, out, VEC_SIZE);
            WRITE_IMAGE2(dst, coord, out);
        }
        wc = get_global_id(0);
    }
}
#endif

#if INPUT_SHAPE == BCAST10_VEC
__kernel void elemwise_arity2_bcast10_vec(
        COMPATIBLE_BUFFER_R(src1), COMPATIBLE_BUFFER_R(src2), COMPATIBLE_BUFFER_W(dst),
        const uint size, const uint c_size, const uint hw_size) {
    src1 += src1_offset;
    src2 += src2_offset;
    dst += dst_offset;
    uint it = get_global_id(0) * VEC_SIZE;
    if (it >= size)
        return;
    uint channel_idx = it / hw_size % c_size;
    uint channel_end_idx = (it / hw_size + 1) * hw_size;
    if (it + VEC_SIZE <= channel_end_idx) {
        VEC_TYPE item1 = src1[channel_idx];
        VEC_TYPE item2 = VLOADN(0, src2 + it);
        VEC_TYPE res;
        OP(item1, item2, res, VEC_SIZE);
        VSTOREN(res, 0, dst + it);
    } else {
        uint it_end = (size < it + VEC_SIZE ? size : it + VEC_SIZE);
        while (it < it_end) {
            TYPE item1 = src1[it / hw_size % c_size];
            TYPE item2 = src2[it];
            TYPE res;
            OP(item1, item2, res, 1);
            dst[it] = res;
            ++it;
        }
    }
}

__kernel void elemwise_arity2_bcast10_vec_nhwcd4(
        COMPATIBLE_IMAGE_R(src1), COMPATIBLE_IMAGE_R(src2), COMPATIBLE_IMAGE_W(dst),
        __private const int global_size_dim0, __private const int global_size_dim1,
        __private const int wc_size, __private const int hb_size,
        __private const uint w_size) {
    INIT_IMAGE3(src1, src2, dst);
    int wc = get_global_id(0);
    int hb = get_global_id(1);

#ifndef NON_UNIFORM_WORK_GROUP
    if (wc >= global_size_dim0 || hb >= global_size_dim1)
        return;
#endif

    for (; hb < hb_size; hb += global_size_dim1) {
        for (; wc < wc_size; wc += global_size_dim0) {
            int2 coord = (int2)(wc, hb);
            int chan_blk_idx = wc / w_size;
            VECTOR(TYPE, 4) in1 = READ_IMAGE(src1, chan_blk_idx, 0);
            VECTOR(TYPE, 4) in2 = READ_IMAGE2(src2, coord);
            VECTOR(TYPE, 4) out;
            OP(in1, in2, out, VEC_SIZE);
            WRITE_IMAGE2(dst, coord, out);
        }
        wc = get_global_id(0);
    }
}
#endif


#elif ARITY == 3

#if MODE == COND_LEQ_MOV
#define OP(x,y,z) (x <= y ? z : IMM(0))
#elif MODE == COND_LT_MOV
#define OP(x,y,z) (x < y ? z : IMM(0))
#elif MODE == FUSE_MUL_ADD3
#define OP(x,y,z) (x * y + z)
#elif !defined(OP)
#error "unknown mode for elemwise arity3"
#endif

#if INPUT_SHAPE == UNKNOWN_SHAPE
__kernel void elemwise_arity3_naive(
        const __global TYPE* src1, const uint src1_offset, const __global TYPE* src2,
        const uint src2_offset, const __global TYPE* src3, const uint src3_offset,
        __global TYPE* dst, const uint dst_offset, const uint8 shape1,
        const int8 stride1, const uint8 shape2, const int8 stride2, const uint8 shape3,
        const int8 stride3) {
    src1 += src1_offset;
    src2 += src2_offset;
    src3 += src3_offset;
    dst += dst_offset;
    uint idx = get_global_id(0);
    TYPE x = src1[get_offset(idx, shape1, stride1)],
         y = src2[get_offset(idx, shape2, stride2)],
         z = src3[get_offset(idx, shape3, stride3)];
    dst[idx] = OP(x, y, z);
}

__kernel void elemwise_arity3_naive_nhwcd4(
        const __global TYPE* src1, const uint src1_offset, const __global TYPE* src2,
        const uint src2_offset, const __global TYPE* src3, const uint src3_offset,
        __global TYPE* dst, const uint dst_offset, const uint8 shape1,
        const int8 stride1, const uint8 shape2, const int8 stride2, const uint8 shape3,
        const int8 stride3, const uint8 dst_shape, const int8 dst_stride) {
    src1 += src1_offset;
    src2 += src2_offset;
    src3 += src3_offset;
    dst += dst_offset;
    uint idx = get_global_id(0);
    TYPE x = src1[get_offset(idx, shape1, stride1)],
         y = src2[get_offset(idx, shape2, stride2)],
         z = src3[get_offset(idx, shape3, stride3)];
    dst[get_offset(idx, dst_shape, dst_stride)] = OP(x, y, z);
}
#endif

#if INPUT_SHAPE == VEC_VEC_VEC
__kernel void elemwise_arity3_vec_vec_vec(
        const __global TYPE* src1, const uint src1_offset, const __global TYPE* src2,
        const uint src2_offset, const __global TYPE* src3, const uint src3_offset,
        __global TYPE* dst, const uint dst_offset, const uint size) {
    src1 += src1_offset;
    src2 += src2_offset;
    src3 += src3_offset;
    dst += dst_offset;
    uint offset = get_global_id(0) * VEC_SIZE;
    int remain = size - offset;
    if (remain >= VEC_SIZE) {
        VEC_TYPE item1 = VLOADN(0, src1 + offset);
        VEC_TYPE item2 = VLOADN(0, src2 + offset);
        VEC_TYPE item3 = VLOADN(0, src3 + offset);
        VEC_TYPE res = OP(item1, item2, item3);
        VSTOREN(res, 0, dst + offset);
    } else {
        for (int idx = 0; idx < remain; idx++) {
            TYPE item1 = src1[offset + idx];
            TYPE item2 = src2[offset + idx];
            TYPE item3 = src3[offset + idx];
            dst[offset + idx] = OP(item1, item2, item3);
        }
    }
}

#if TYPE_ENUM == K_FLOAT32 || TYPE_ENUM == K_FLOAT16
__kernel void elemwise_arity3_vec_vec_vec_nhwcd4(
        IMAGE_R(src1), IMAGE_R(src2), IMAGE_R(src3), IMAGE_W(dst),
        __private const int global_size_dim0, __private const int global_size_dim1,
        __private const int wc_size, __private const int hb_size) {
    INIT_IMAGE4(src1, src2, src3, dst);
    int wc = get_global_id(0);
    int hb = get_global_id(1);

#ifndef NON_UNIFORM_WORK_GROUP
    if (wc >= global_size_dim0 || hb >= global_size_dim1)
        return;
#endif

    for (; hb < hb_size; hb += global_size_dim1) {
        for (; wc < wc_size; wc += global_size_dim0) {
            int2 coord = (int2)(wc, hb);
            VECTOR(TYPE, 4) in1 = READ_IMAGE2(src1, coord);
            VECTOR(TYPE, 4) in2 = READ_IMAGE2(src2, coord);
            VECTOR(TYPE, 4) in3 = READ_IMAGE2(src3, coord);
            VECTOR(TYPE, 4) out = OP(in1, in2, in3);
            WRITE_IMAGE2(dst, coord, out);
        }
        wc = get_global_id(0);
    }
}
#endif
#endif

#if INPUT_SHAPE == VEC_VEC_SCALA
__kernel void elemwise_arity3_vec_vec_scala(
        const __global TYPE* src1, const uint src1_offset, const __global TYPE* src2,
        const uint src2_offset, const __global TYPE* src3, const uint src3_offset,
        __global TYPE* dst, const uint dst_offset, const uint size) {
    src1 += src1_offset;
    src2 += src2_offset;
    src3 += src3_offset;
    dst += dst_offset;
    uint offset = get_global_id(0) * VEC_SIZE;
    int remain = size - offset;
    if (remain >= VEC_SIZE) {
        VEC_TYPE item1 = VLOADN(0, src1 + offset);
        VEC_TYPE item2 = VLOADN(0, src2 + offset);
        VEC_TYPE item3 = src3[0];
        VEC_TYPE res = OP(item1, item2, item3);
        VSTOREN(res, 0, dst + offset);
    } else {
        TYPE item3 = src3[0];
        for (int idx = 0; idx < remain; idx++) {
            TYPE item1 = src1[offset + idx];
            TYPE item2 = src2[offset + idx];
            dst[offset + idx] = OP(item1, item2, item3);
        }
    }
}

#if TYPE_ENUM == K_FLOAT32 || TYPE_ENUM == K_FLOAT16
__kernel void elemwise_arity3_vec_vec_scala_nhwcd4(
        IMAGE_R(src1), IMAGE_R(src2), __global TYPE* src3, const uint src3_offset,
        IMAGE_W(dst), __private const int global_size_dim0,
        __private const int global_size_dim1, __private const int wc_size,
        __private const int hb_size) {
    INIT_IMAGE3(src1, src2, dst);

    int wc = get_global_id(0);
    int hb = get_global_id(1);

#ifndef NON_UNIFORM_WORK_GROUP
    if (wc >= global_size_dim0 || hb >= global_size_dim1)
        return;
#endif
    src3 += src3_offset;
    for (; hb < hb_size; hb += global_size_dim1) {
        for (; wc < wc_size; wc += global_size_dim0) {
            int2 coord = (int2)(wc, hb);
            VECTOR(TYPE, 4) in1 = READ_IMAGE2(src1, coord);
            VECTOR(TYPE, 4) in2 = READ_IMAGE2(src2, coord);
            VECTOR(TYPE, 4) in3 = (VECTOR(TYPE, 4))(src3[0]);
            VECTOR(TYPE, 4) out = OP(in1, in2, in3);
            WRITE_IMAGE2(dst, coord, out);
        }
        wc = get_global_id(0);
    }
}
#endif
#endif

#if INPUT_SHAPE == VEC_SCALA_SCALA
__kernel void elemwise_arity3_vec_scala_scala(
        const __global TYPE* src1, const uint src1_offset, const __global TYPE* src2,
        const uint src2_offset, const __global TYPE* src3, const uint src3_offset,
        __global TYPE* dst, const uint dst_offset, const uint size) {
    src1 += src1_offset;
    src2 += src2_offset;
    src3 += src3_offset;
    dst += dst_offset;
    uint offset = get_global_id(0) * VEC_SIZE;
    int remain = size - offset;
    if (remain >= VEC_SIZE) {
        VEC_TYPE item1 = VLOADN(0, src1 + offset);
        VEC_TYPE item2 = src2[0];
        VEC_TYPE item3 = src3[0];
        VEC_TYPE res = OP(item1, item2, item3);
        VSTOREN(res, 0, dst + offset);
    } else {
        TYPE item2 = src2[0];
        TYPE item3 = src3[0];
        for (int idx = 0; idx < remain; idx++) {
            TYPE item1 = src1[offset + idx];
            dst[offset + idx] = OP(item1, item2, item3);
        }
    }
}

#if TYPE_ENUM == K_FLOAT32 || TYPE_ENUM == K_FLOAT16
__kernel void elemwise_arity3_vec_scala_scala_nhwcd4(
        IMAGE_R(src1), __global TYPE* src2, const uint src2_offset, __global TYPE* src3,
        const uint src3_offset, IMAGE_W(dst), __private const int global_size_dim0,
        __private const int global_size_dim1, __private const int wc_size,
        __private const int hb_size) {
    INIT_IMAGE2(src1, dst);

    int wc = get_global_id(0);
    int hb = get_global_id(1);

#ifndef NON_UNIFORM_WORK_GROUP
    if (wc >= global_size_dim0 || hb >= global_size_dim1)
        return;
#endif
    src2 += src2_offset;
    src3 += src3_offset;

    for (; hb < hb_size; hb += global_size_dim1) {
        for (; wc < wc_size; wc += global_size_dim0) {
            int2 coord = (int2)(wc, hb);
            VECTOR(TYPE, 4) in1 = READ_IMAGE2(src1, coord);
            VECTOR(TYPE, 4) in2 = (VECTOR(TYPE, 4))(src2[0]);
            VECTOR(TYPE, 4) in3 = (VECTOR(TYPE, 4))(src3[0]);
            VECTOR(TYPE, 4) out = OP(in1, in2, in3);
            WRITE_IMAGE2(dst, coord, out);
        }
        wc = get_global_id(0);
    }
}
#endif
#endif

#if INPUT_SHAPE == BCAST101_VEC_BCAST101
__kernel void elemwise_arity3_bcast101_vec_bcast101(
        const __global TYPE* src1, const uint src1_offset, const __global TYPE* src2,
        const uint src2_offset, const __global TYPE* src3, const uint src3_offset,
        __global TYPE* dst, const uint dst_offset, const uint size, const uint c_size,
        const uint hw_size) {
    src1 += src1_offset;
    src2 += src2_offset;
    src3 += src3_offset;
    dst += dst_offset;
    uint it = get_global_id(0) * VEC_SIZE;
    if (it >= size)
        return;
    uint channel_idx = it / hw_size % c_size;
    uint channel_end_idx = (it / hw_size + 1) * hw_size;
    if (it + VEC_SIZE <= channel_end_idx) {
        VEC_TYPE item1 = src1[channel_idx];
        VEC_TYPE item2 = VLOADN(0, src2 + it);
        VEC_TYPE item3 = src3[channel_idx];
        VEC_TYPE res = OP(item1, item2, item3);
        VSTOREN(res, 0, dst + it);
    } else {
        uint it_end = (size < it + VEC_SIZE ? size : it + VEC_SIZE);
        while (it < it_end) {
            TYPE item1 = src1[it / hw_size % c_size];
            TYPE item2 = src2[it];
            TYPE item3 = src3[it / hw_size % c_size];
            dst[it] = OP(item1, item2, item3);
            ++it;
        }
    }
}

#if TYPE_ENUM == K_FLOAT32 || TYPE_ENUM == K_FLOAT16
__kernel void elemwise_arity3_bcast101_vec_bcast101_nhwcd4(
        IMAGE_R(src1), IMAGE_R(src2), IMAGE_R(src3), IMAGE_W(dst),
        __private const int global_size_dim0, __private const int global_size_dim1,
        __private const int wc_size, __private const int hb_size,
        __private const uint w_size) {
    INIT_IMAGE4(src1, src2, src3, dst);
    int wc = get_global_id(0);
    int hb = get_global_id(1);

#ifndef NON_UNIFORM_WORK_GROUP
    if (wc >= global_size_dim0 || hb >= global_size_dim1)
        return;
#endif

    for (; hb < hb_size; hb += global_size_dim1) {
        for (; wc < wc_size; wc += global_size_dim0) {
            int2 coord = (int2)(wc, hb);
            int chan_blk_idx = wc / w_size;
            VECTOR(TYPE, 4)
            in1 = READ_IMAGE(src1, chan_blk_idx, 0);
            VECTOR(TYPE, 4) in2 = READ_IMAGE2(src2, coord);
            VECTOR(TYPE, 4)
            in3 = READ_IMAGE(src3, chan_blk_idx, 0);
            VECTOR(TYPE, 4) out = OP(in1, in2, in3);
            WRITE_IMAGE2(dst, coord, out);
        }
        wc = get_global_id(0);
    }
}
#endif
#endif

#if INPUT_SHAPE == VEC_BCAST101_VEC
__kernel void elemwise_arity3_vec_bcast101_vec(
        const __global TYPE* src1, const uint src1_offset, const __global TYPE* src2,
        const uint src2_offset, const __global TYPE* src3, const uint src3_offset,
        __global TYPE* dst, const uint dst_offset, const uint size, const uint c_size,
        const uint hw_size) {
    src1 += src1_offset;
    src2 += src2_offset;
    src3 += src3_offset;
    dst += dst_offset;
    uint it = get_global_id(0) * VEC_SIZE;
    if (it >= size)
        return;
    uint channel_idx = it / hw_size % c_size;
    uint channel_end_idx = (it / hw_size + 1) * hw_size;
    if (it + VEC_SIZE <= channel_end_idx) {
        VEC_TYPE item1 = VLOADN(0, src1 + it);
        VEC_TYPE item2 = src2[channel_idx];
        VEC_TYPE item3 = VLOADN(0, src3 + it);
        VEC_TYPE res = OP(item1, item2, item3);
        VSTOREN(res, 0, dst + it);
    } else {
        uint it_end = (size < it + VEC_SIZE ? size : it + VEC_SIZE);
        while (it < it_end) {
            TYPE item1 = src1[it];
            TYPE item2 = src2[it / hw_size % c_size];
            TYPE item3 = src3[it];
            dst[it] = OP(item1, item2, item3);
            ++it;
        }
    }
}

#if TYPE_ENUM == K_FLOAT32 || TYPE_ENUM == K_FLOAT16
__kernel void elemwise_arity3_vec_bcast101_vec_nhwcd4(
        IMAGE_R(src1), IMAGE_R(src2), IMAGE_R(src3), IMAGE_W(dst),
        __private const int global_size_dim0, __private const int global_size_dim1,
        __private const int wc_size, __private const int hb_size,
        __private const uint w_size) {
    INIT_IMAGE4(src1, src2, src3, dst);

    int wc = get_global_id(0);
    int hb = get_global_id(1);

#ifndef NON_UNIFORM_WORK_GROUP
    if (wc >= global_size_dim0 || hb >= global_size_dim1)
        return;
#endif

    for (; hb < hb_size; hb += global_size_dim1) {
        for (; wc < wc_size; wc += global_size_dim0) {
            int2 coord = (int2)(wc, hb);
            int chan_blk_idx = wc / w_size;
            VECTOR(TYPE, 4) in1 = READ_IMAGE2(src1, coord);
            VECTOR(TYPE, 4)
            in2 = READ_IMAGE(src2, chan_blk_idx, 0);
            VECTOR(TYPE, 4) in3 = READ_IMAGE2(src3, coord);
            VECTOR(TYPE, 4) out = OP(in1, in2, in3);
            WRITE_IMAGE2(dst, coord, out);
        }
        wc = get_global_id(0);
    }
}
#endif
#endif


#elif ARITY == 4

__kernel void elemwise_fmadd4_naive(
        const __global TYPE* src1, const uint src1_offset, const __global TYPE* src2,
        const uint src2_offset, const __global TYPE* src3, const uint src3_offset,
        const __global TYPE* src4, const uint src4_offset, __global TYPE* dst,
        const uint dst_offset, const uint8 shape1, const int8 stride1,
        const uint8 shape2, const int8 stride2, const uint8 shape3, const int8 stride3,
        const uint8 shape4, const int8 stride4) {
    src1 += src1_offset;
    src2 += src2_offset;
    src3 += src3_offset;
    src4 += src4_offset;
    dst += dst_offset;
    uint idx = get_global_id(0);
    dst[idx] = src1[get_offset(idx, shape1, stride1)] *
                       src2[get_offset(idx, shape2, stride2)] +
               src3[get_offset(idx, shape3, stride3)] *
                       src4[get_offset(idx, shape4, stride4)];
}

__kernel void elemwise_fmadd4_naive_nhwcd4(
        const __global TYPE* src1, const uint src1_offset, const __global TYPE* src2,
        const uint src2_offset, const __global TYPE* src3, const uint src3_offset,
        const __global TYPE* src4, const uint src4_offset, __global TYPE* dst,
        const uint dst_offset, const uint8 shape1, const int8 stride1,
        const uint8 shape2, const int8 stride2, const uint8 shape3, const int8 stride3,
        const uint8 shape4, const int8 stride4, const uint8 dst_shape,
        const int8 dst_stride) {
    src1 += src1_offset;
    src2 += src2_offset;
    src3 += src3_offset;
    src4 += src4_offset;
    dst += dst_offset;
    uint idx = get_global_id(0);
    dst[get_offset(idx, dst_shape, dst_stride)] =
            src1[get_offset(idx, shape1, stride1)] *
                    src2[get_offset(idx, shape2, stride2)] +
            src3[get_offset(idx, shape3, stride3)] *
                    src4[get_offset(idx, shape4, stride4)];
}
#endif
