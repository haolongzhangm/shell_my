//******************************************************************************************************************************
// Copyright (c) 2019-2022 Qualcomm Technologies, Inc.
// All Rights Reserved.
// Confidential and Proprietary - Qualcomm Technologies, Inc.
//******************************************************************************************************************************

#ifndef CL_QCOM_ML_OPS_H
#define CL_QCOM_ML_OPS_H

#define CL_QCOM_ML_OPS_H_MAJOR_VERSION 3
#define CL_QCOM_ML_OPS_H_MINOR_VERSION 0

#include <MCL/cl_platform.h>
#include <MCL/cl_ext_qcom.h>

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

/**
* Maximum number of supported ML tensor dimensions
*/
#define CL_ML_TENSOR_MAX_DIMS_QCOM             5
#define CL_ML_TENSOR_MAX_SPATIAL_DIMS_QCOM     3

/**
* ML op properties keys.
*/
#define CL_ML_OP_PROPERTY_LIST_END_QCOM           0
#define CL_ML_OP_REQUIRE_TUNING_CACHE_HIT_QCOM    1
#define CL_ML_OP_TRAINING_COMPATIBLE_QCOM         2
#define CL_ML_BINARY_OP_UPDATE_PARAMETERS_QCOM    3
#define CL_ML_BATCH_NORM_OP_EPSILON_QCOM          4
#define CL_ML_PAD_OP_CONSTANT_VALUE_QCOM          5

/**
* ML tensor properties keys.
*/
#define CL_ML_TENSOR_PROPERTY_LIST_END_QCOM     0

/**
* Error codes.
*/
#define CL_ML_OP_NOT_ACCELERATED_QCOM           -1102
#define CL_ML_INVALID_TENSOR_LAYOUT_QCOM        -1103

/**
* Data structure to represent ML op properties key or value.
*/
typedef intptr_t  cl_ml_op_properties_qcom;

/**
* Data structure to represent ML tensor properties key or value.
*/
typedef intptr_t  cl_ml_tensor_properties_qcom;

/**
* Handle to the data structure implementing an ML tensor in ML ops.
*/
typedef struct _cl_ml_tensor_qcom*               cl_ml_tensor_qcom;

/**
* Handle to the data structure implementing an ML op.
*/
typedef struct _cl_ml_op_qcom*                   cl_ml_op_qcom;

/**
* Handle to the data structure implementing an ML tuning cache for ML ops.
*/
typedef struct _cl_ml_tuning_cache_qcom*         cl_ml_tuningcache_qcom;

/**
* Handle to the data structure implementing an ML tensor memory descriptor set.
*/
typedef struct _cl_ml_tensor_mem_desc_set_qcom*  cl_ml_tensor_mem_desc_set_qcom;

/**
* Spatial dimension for ML tensors.
*/
typedef enum _cl_spatial_dim
{
    CL_SPATIAL_DIM_H = 0,
    CL_SPATIAL_DIM_W = 1,
    CL_SPATIAL_DIM_D = 2,
} cl_spatial_dim;

/**
* ML tensor layout.
*/
typedef enum _cl_ml_tensor_layout_qcom {
    CL_TENSOR_LAYOUT_OPTIMAL_QCOM = 0,
    CL_TENSOR_LAYOUT_NCHW_QCOM    = 1,
    CL_TENSOR_LAYOUT_NHWC_QCOM    = 2,
} cl_ml_tensor_layout_qcom;

/**
* Supported ML tensor dimension.
*/
typedef enum _cl_ml_tensor_dimensions_qcom {
    CL_TENSOR_DIMENSIONS_4D_QCOM  = 0,
    CL_TENSOR_DIMENSIONS_5D_QCOM  = 1,
    CL_TENSOR_UNUSED_QCOM         = 2,
} cl_ml_tensor_dimensions_qcom;

/**
* Transform for input tensors in GEMM op.
*/
typedef enum _cl_gemm_transform_qcom {
    CL_GEMM_TRANSFORM_NONE_QCOM      = 0,
    CL_GEMM_TRANSFORM_TRANSPOSE_QCOM = 1,
} cl_gemm_transform_qcom;

/**
* Transform for the weight tensor in fully connected op.
*/
typedef enum _cl_fc_weight_transform_qcom {
    CL_FC_WEIGHT_TRANSFORM_NONE_QCOM      = 0,
    CL_FC_WEIGHT_TRANSFORM_TRANSPOSE_QCOM = 1,
} cl_fc_weight_transform_qcom;

/**
* Arithmetic mode for ML Ops.
*/
typedef enum _cl_arithmetic_mode_qcom {
    CL_ARITHMETIC_MODE_FP16_QCOM       = 0,
    CL_ARITHMETIC_MODE_FP16_ACC32_QCOM = 1,
    CL_ARITHMETIC_MODE_FP32_QCOM       = 2,
    CL_ARITHMETIC_MODE_INT32_QCOM      = 3,
} cl_arithmetic_mode_qcom;

/**
* Convolution mode.
*/
typedef enum _cl_convolution_mode_qcom {
    CL_CONVOLUTION_MODE_CONVOLUTION_QCOM  = 0,
    CL_CONVOLUTION_MODE_TRANSPOSE_QCOM    = 1,
    CL_CONVOLUTION_MODE_DEPTHWISE_QCOM    = 2,
} cl_convolution_mode_qcom;

/**
* Batchnorm mode.
*/
typedef enum _cl_batchnorm_mode_qcom {
    CL_BATCHNORM_MODE_SPATIAL_QCOM  = 0,
} cl_batchnorm_mode_qcom;

/**
* Activation function.
*/
typedef enum _cl_activation_function_qcom {
    CL_ACTIVATION_RELU       = 0,
    CL_ACTIVATION_TANH       = 1,
    CL_ACTIVATION_SIGMOID    = 2,
    CL_ACTIVATION_RELU6      = 3,
    CL_ACTIVATION_ELU        = 4,
    CL_ACTIVATION_PRELU      = 5,
    CL_ACTIVATION_LEAKY_RELU = 6,
} cl_activation_function_qcom;

/**
* Nan propagation.
*/
typedef enum _cl_nan_mode_qcom {
    CL_DO_NOT_PROPAGATE_NAN_QCOM = 0,
    CL_PROPAGATE_NAN_QCOM        = 1,
} cl_nan_mode_qcom;

/**
* Pooling mode.
*/
typedef enum _cl_pooling_mode_qcom {
    CL_POOLING_MODE_MAX_QCOM                     = 0,
    CL_POOLING_MODE_AVERAGE_INCLUDE_PADDING_QCOM = 1,
    CL_POOLING_MODE_AVERAGE_EXCLUDE_PADDING_QCOM = 2,
    CL_POOLING_MODE_GLOBAL_MAX_QCOM              = 3,
    CL_POOLING_MODE_GLOBAL_AVERAGE_QCOM          = 4,
} cl_pooling_mode_qcom;

/**
* Binary op type.
*/
typedef enum _cl_binary_op_qcom {
    CL_TENSOR_OP_ADD_QCOM   = 0,
    CL_TENSOR_OP_SUB_QCOM   = 1,
    CL_TENSOR_OP_MUL_QCOM   = 2,
    CL_TENSOR_OP_MIN_QCOM   = 3,
    CL_TENSOR_OP_MAX_QCOM   = 4,
    CL_TENSOR_OP_DIV_QCOM   = 5,
} cl_binary_op_qcom;

/**
* Unary op type.
*/
typedef enum _cl_unary_op_qcom {
    CL_TENSOR_UNARY_OP_SUM_QCOM      = 0,
    CL_TENSOR_UNARY_OP_MIN_QCOM      = 1,
    CL_TENSOR_UNARY_OP_MAX_QCOM      = 2,
    CL_TENSOR_UNARY_OP_L2_NORM_QCOM  = 3,
} cl_unary_op_qcom;

/**
* Padding mode.
*/
typedef enum _cl_softmax_algorithm_qcom {
    CL_SOFTMAX_ALGORITHM_ACCURATE_QCOM = 1,
} cl_softmax_algorithm_qcom;

/**
* Softmax mode.
*/
typedef enum _cl_softmax_mode_qcom {
    CL_SOFTMAX_MODE_INSTANCE_QCOM = 0,
    CL_SOFTMAX_MODE_CHANNEL_QCOM  = 1,
    CL_SOFTMAX_MODE_SPATIAL_QCOM  = 2,
} cl_softmax_mode_qcom;

/**
* Padding mode.
*/
typedef enum _cl_pad_mode_qcom {
    CL_PAD_MODE_CONSTANT_QCOM  = 0,
    CL_PAD_MODE_REFLECT_QCOM   = 1,
    CL_PAD_MODE_SYMMETRIC_QCOM = 2,
    CL_PAD_MODE_EDGE_QCOM      = 3
} cl_pad_mode_qcom;

/**
* Loss forward function.
*/
typedef enum _cl_loss_fwd_function_qcom {
    CL_LOSS_FWD_MSE_QCOM                      = 0,
    CL_LOSS_FWD_CROSSENTROPY_QCOM             = 1,
    CL_LOSS_FWD_BINARY_CROSSENTROPY_QCOM      = 2,
    CL_LOSS_FWD_MAE_QCOM                      = 3,
} cl_loss_fwd_function_qcom;

/**
* Loss forward reduction mode.
*/
typedef enum _cl_loss_fwd_reduction_mode_qcom {
    CL_LOSS_FWD_REDUCE_NONE_QCOM          = 0,
    CL_LOSS_FWD_REDUCE_SUM_INSTANCE_QCOM  = 1,
} cl_loss_fwd_reduction_mode_qcom;

/**
* Loss backward function.
*/
typedef enum _cl_loss_bwd_function_qcom {
    CL_LOSS_BWD_MSE_QCOM                    = 0,
    CL_LOSS_BWD_SOFTMAX_CROSSENTROPY_QCOM   = 1,
    CL_LOSS_BWD_SIGMOID_CROSSENTROPY_QCOM   = 2,
    CL_LOSS_BWD_CROSSENTROPY_QCOM           = 3,
    CL_LOSS_BWD_BINARY_CROSSENTROPY_QCOM    = 4,
    CL_LOSS_BWD_MAE_QCOM                    = 5,
} cl_loss_bwd_function_qcom;

/**
* Clipping mode.
*/
typedef enum _cl_clip_mode_qcom {
    CL_CLIP_BY_VALUE_QCOM = 0,
    CL_CLIP_BY_NORM_QCOM  = 1,
} cl_clip_mode_qcom;

typedef enum _cl_arg_max_mode_qcom {
    CL_ARGMAX_MODE_INSTANCE_QCOM = 0,
    CL_ARGMAX_MODE_CHANNEL_QCOM  = 1,
    CL_ARGMAX_MODE_SPATIAL_QCOM  = 2,
} cl_arg_max_mode_qcom;

/**
* Unary op mode.
*/
typedef enum _cl_unary_op_mode_qcom {
    CL_UNARY_OP_MODE_INSTANCE_QCOM = 0,
    CL_UNARY_OP_MODE_CHANNEL_QCOM  = 1,
    CL_UNARY_OP_MODE_SPATIAL_QCOM  = 2,
} cl_unary_op_mode_qcom;

/**
* Local Response Norm mode.
*/
typedef enum _cl_local_response_norm_mode_qcom {
    CL_LOCAL_RESPONSE_NORM_MODE_CHANNEL_QCOM  = 0
} cl_local_response_norm_mode_qcom;

typedef enum _cl_parameter_update_sgd_function_qcom {
    CL_SGD_QCOM                          = 0,
    CL_SGD_WITH_WEIGHT_DECAY_QCOM        = 1,
    CL_SGD_WITH_MOMENTUM_QCOM            = 2
} cl_parameter_update_sgd_function_qcom;

typedef enum _cl_parameter_update_adam_function_qcom {
    CL_ADAM_QCOM                          = 0
} cl_parameter_update_adam_function_qcom;

/**
* Data structure to define an ML tensor in ML ops.
*/
typedef struct _cl_ml_tensor_desc_qcom {
    cl_channel_type               data_type;
    cl_ml_tensor_layout_qcom      layout;
    cl_uint                       n;
    cl_uint                       c;
    cl_uint                       h;
    cl_uint                       w;
    cl_uint                       d;
    cl_ml_tensor_dimensions_qcom  num_dimensions;
    cl_int                        stride[CL_ML_TENSOR_MAX_DIMS_QCOM];
} cl_ml_tensor_desc_qcom;

/**
* Data type.
*/
typedef struct _cl_ml_value_qcom {
   union _u {
       cl_float          fp32;
       cl_half           fp16;
       cl_int            intg32;
   } u;
   cl_channel_type       type;
} cl_ml_value_qcom;

/**
* Data structure to define Gemm op.
*/
typedef struct _cl_ml_op_gemm_desc_qcom {
    cl_uint                    m;
    cl_uint                    n;
    cl_uint                    k;
    cl_gemm_transform_qcom     trans_a;
    cl_gemm_transform_qcom     trans_b;
    cl_ml_value_qcom           alpha;
    cl_ml_value_qcom           beta;
    cl_arithmetic_mode_qcom    arithmetic_mode;
} cl_ml_op_gemm_desc_qcom;

/**
* Data structure to define transpose op.
*/
typedef struct _cl_ml_op_transpose_desc_qcom {
    cl_uint                    m;
    cl_uint                    n;
    cl_arithmetic_mode_qcom    arithmetic_mode;
} cl_ml_op_transpose_desc_qcom;

/**
* Data structure to define binary op.
*/
typedef struct _cl_ml_op_binary_desc_qcom {
    cl_binary_op_qcom          binary_op;
    cl_ml_value_qcom           alpha;
    cl_ml_value_qcom           beta;
    cl_ml_value_qcom           gamma;
    cl_arithmetic_mode_qcom    arithmetic_mode;
} cl_ml_op_binary_desc_qcom;

/**
* Data structure to define fully connected op.
*/
typedef struct _cl_ml_op_fully_connected_desc_qcom {
    cl_uint                        first_flatten_axis;
    cl_fc_weight_transform_qcom    weight_transform;
    cl_arithmetic_mode_qcom        arithmetic_mode;
} cl_ml_op_fully_connected_desc_qcom;

/**
* Data structure to define convolution op.
*/
typedef struct _cl_ml_op_convolution_desc_qcom {
    cl_convolution_mode_qcom    mode;
    cl_uint                     group_count;
    cl_uint                     num_dimensions;
    cl_uint                     input_padding_before[CL_ML_TENSOR_MAX_SPATIAL_DIMS_QCOM];
    cl_uint                     input_padding_after[CL_ML_TENSOR_MAX_SPATIAL_DIMS_QCOM];
    cl_uint                     filter_stride[CL_ML_TENSOR_MAX_SPATIAL_DIMS_QCOM];
    cl_uint                     dilation[CL_ML_TENSOR_MAX_SPATIAL_DIMS_QCOM];
    cl_bitfield                 flags;
    cl_arithmetic_mode_qcom     arithmetic_mode;
} cl_ml_op_convolution_desc_qcom;

/**
* Data structure to define activation op.
*/
typedef struct _cl_ml_op_activation_desc_qcom {
    cl_activation_function_qcom     function;
    cl_nan_mode_qcom                nan_propagation;
    cl_arithmetic_mode_qcom         arithmetic_mode;
} cl_ml_op_activation_desc_qcom;

/**
* Data structure to define pooling op.
*/
typedef struct _cl_ml_op_pooling_desc_qcom {
    cl_pooling_mode_qcom         mode;
    cl_uint                      num_dimensions;
    cl_uint                      input_padding_before[CL_ML_TENSOR_MAX_SPATIAL_DIMS_QCOM];
    cl_uint                      input_padding_after[CL_ML_TENSOR_MAX_SPATIAL_DIMS_QCOM];
    cl_uint                      stride[CL_ML_TENSOR_MAX_SPATIAL_DIMS_QCOM];
    cl_uint                      window_size[CL_ML_TENSOR_MAX_SPATIAL_DIMS_QCOM];
    cl_nan_mode_qcom             nan_propagation;
    cl_arithmetic_mode_qcom      arithmetic_mode;
} cl_ml_op_pooling_desc_qcom;

/**
* Data structure to define batchnorm op.
*/
typedef struct _cl_ml_op_batchnorm_desc_qcom {
    cl_batchnorm_mode_qcom       mode;
    cl_arithmetic_mode_qcom      arithmetic_mode;
} cl_ml_op_batchnorm_desc_qcom;

/**
* Data structure to define softmax op.
*/
typedef struct _cl_ml_op_softmax_desc_qcom {
    cl_softmax_algorithm_qcom    algo;
    cl_softmax_mode_qcom         mode;
    cl_arithmetic_mode_qcom      arithmetic_mode;
} cl_ml_op_softmax_desc_qcom;

/**
* Data structure to define concat op.
*/
typedef struct _cl_ml_op_concat_desc_qcom {
    cl_uint                      axis;
    cl_uint                      num_input_tensors;
    cl_arithmetic_mode_qcom      arithmetic_mode;
} cl_ml_op_concat_desc_qcom;

/**
* Data structure to define permute op.
*/
typedef struct _cl_ml_op_permute_desc_qcom {
    cl_uint                      len_order;
    cl_uint                      order[CL_ML_TENSOR_MAX_DIMS_QCOM];
    cl_arithmetic_mode_qcom      arithmetic_mode;
} cl_ml_op_permute_desc_qcom;

/**
* Data structure to define depthtospace op.
*/
typedef struct _cl_ml_op_depthtospace_desc_qcom {
    cl_uint                      block_dim;
    cl_arithmetic_mode_qcom      arithmetic_mode;
} cl_ml_op_depthtospace_desc_qcom;

/**
* Data structure to define fill op.
*/
typedef struct _cl_ml_op_fill_desc_qcom {
    cl_ml_value_qcom             fill_value;
    cl_arithmetic_mode_qcom      arithmetic_mode;
} cl_ml_op_fill_desc_qcom;

/**
* Data structure to define resize bilinear op.
*/
typedef struct _cl_ml_op_resize_bilinear_desc_qcom {
    cl_bool                      align_corners;
    cl_bool                      half_pixel_centers;
    cl_arithmetic_mode_qcom      arithmetic_mode;
} cl_ml_op_resize_bilinear_desc_qcom;

/**
* Data structure to define pad op.
*/
typedef struct _cl_ml_op_pad_desc_qcom {
    cl_pad_mode_qcom             pad_mode;
    cl_uint                      paddings_shape[2];
    cl_uint                      paddings[8];
    cl_arithmetic_mode_qcom      arithmetic_mode;
} cl_ml_op_pad_desc_qcom;

/**
* Data structure to store an ML tensor handle and its backed memory handle.
*/
typedef struct _cl_ml_tensor_memory_desc {
    cl_ml_tensor_qcom             tensor;
    cl_mem                        memory;
} cl_ml_tensor_memory_desc_qcom;

/**
* Data structure to an ML op array arg.
*/
typedef struct _cl_ml_op_array_arg_qcom {
    cl_uint                        dispatch_index;
    cl_ml_tensor_memory_desc_qcom* tensor_descriptors;
    cl_uint                        num_tensors;
} cl_ml_op_array_arg_qcom;

/**
* Data structure to define loss forward op.
*/

typedef struct _cl_ml_op_loss_fwd_desc_qcom {
    cl_loss_fwd_function_qcom           function;
    cl_loss_fwd_reduction_mode_qcom     mode;
    cl_nan_mode_qcom                    nan_propagation;
    cl_ml_value_qcom                    scaling;
    cl_arithmetic_mode_qcom             arithmetic_mode;
} cl_ml_op_loss_fwd_desc_qcom;

/**
* Data structure to define loss backward op.
*/

typedef struct _cl_ml_op_loss_bwd_desc_qcom {
    cl_loss_bwd_function_qcom       function;
    cl_nan_mode_qcom                nan_propagation;
    cl_ml_value_qcom                scaling;
    cl_arithmetic_mode_qcom         arithmetic_mode;
} cl_ml_op_loss_bwd_desc_qcom;

/**
* Data structure to define clip op.
*/

typedef struct _cl_ml_op_clip_desc_qcom {
    cl_clip_mode_qcom               clip_mode;
    cl_ml_value_qcom                clip_value_max;
    cl_ml_value_qcom                clip_value_min;
    cl_arithmetic_mode_qcom         arithmetic_mode;
} cl_ml_op_clip_desc_qcom;

/**
* Data structure to define slice op.
*/
typedef struct _cl_ml_op_slice_desc_qcom {
    cl_uint                         start_pos_each_dims[5];
    cl_uint                         end_pos_each_dims[5];
    cl_arithmetic_mode_qcom         arithmetic_mode;
} cl_ml_op_slice_desc_qcom;

/**
* Data structure to define gather op.
*/
typedef struct _cl_ml_op_gather_desc_qcom {
    cl_uint                         axis;
    cl_arithmetic_mode_qcom         arithmetic_mode;
} cl_ml_op_gather_desc_qcom;

/**
* Data structure to define Arg Max op.
*/
typedef struct _cl_ml_op_arg_max_desc_qcom {
    cl_arg_max_mode_qcom            mode;
    cl_arithmetic_mode_qcom         arithmetic_mode;
} cl_ml_op_arg_max_desc_qcom;

/**
* Data structure to define One-Hot Encoding op.
*/
typedef struct _cl_ml_op_one_hot_desc_qcom {
    cl_uint                         axis;
    cl_ml_value_qcom                on_value;
    cl_ml_value_qcom                off_value;
    cl_uint                         num_classes;
    cl_arithmetic_mode_qcom         arithmetic_mode;
} cl_ml_op_one_hot_desc_qcom;

/**
* Data structure to define spacetodepth op.
*/
typedef struct _cl_ml_op_spacetodepth_desc_qcom {
    cl_uint                      block_dim;
    cl_arithmetic_mode_qcom      arithmetic_mode;
} cl_ml_op_spacetodepth_desc_qcom;

/**
* Data structure to define Unary op.
*/
typedef struct _cl_ml_op_unary_desc_qcom {
    cl_unary_op_qcom             unary_op;
    cl_unary_op_mode_qcom        mode;
    cl_ml_value_qcom             scaling_factor;
    cl_arithmetic_mode_qcom      arithmetic_mode;
} cl_ml_op_unary_desc_qcom;

/**
* Data structure to define Local Response Norm op.
*/
typedef struct _cl_ml_op_local_response_norm_desc_qcom {
    cl_local_response_norm_mode_qcom  mode;
    cl_uint                           radius;
    cl_ml_value_qcom                  bias;
    cl_ml_value_qcom                  alpha;
    cl_ml_value_qcom                  beta;
} cl_ml_op_local_response_norm_desc_qcom;

/**
* Data structure to define Update parameter SGD op.
*/
typedef struct _cl_ml_op_update_parameter_sgd_desc_qcom {
    cl_ml_value_qcom                       learning_rate;
    cl_ml_value_qcom                       weight_decay;
    cl_ml_value_qcom                       momentum;
    cl_parameter_update_sgd_function_qcom  sgd_function;
    cl_arithmetic_mode_qcom                arithmetic_mode;
} cl_ml_op_update_parameter_sgd_desc_qcom;

/**
* Data structure to define Update parameter ADAM op.
*/
typedef struct _cl_ml_op_update_parameter_adam_desc_qcom {
    cl_ml_value_qcom                       learning_rate;
    cl_ml_value_qcom                       beta_1;
    cl_ml_value_qcom                       beta_2;
    cl_ml_value_qcom                       epsilon;
    cl_ml_value_qcom                       weight_decay;
    cl_parameter_update_adam_function_qcom adam_function;
    cl_arithmetic_mode_qcom                arithmetic_mode;
} cl_ml_op_update_parameter_adam_desc_qcom;

/*
 * APIs
 */

 /*******************************************************************************************************************************
 *   pfnClCreateMLTensorQCOM
 *
 *   @brief
 *       Creates an instance of ML tensor object.
 *   @param
 *       context             [in]: Handle to previously created OpenCL context.
 *   @param
 *       pTensorProperties   [in]: Pointer to a user created zero terminated list of ML tensor property key value pairs. If it
 *                                 is NULL, it will be ignored.
 *   @param
 *       pTensorDescriptor   [in]: Pointer to a user created ML tensor descriptor object.
 *   @param
 *       pTensor            [out]: Pointer to ML tensor handle and returns an abstract reference to the created instance of
 *                                 ML tensor.
 *   @return
 *       CL_SUCCESS if the function executed successfully.
 *
 *******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLTensorQCOM)(
    cl_context                          context,
    const cl_ml_tensor_properties_qcom* pTensorProperties,
    const cl_ml_tensor_desc_qcom*       pTensorDescriptor,
    cl_ml_tensor_qcom*                  pTensor);

/*******************************************************************************************************************************
*   pfnClReleaseMLTensorQCOM
*
*   @brief
*       Releases a previously created ML tensor object.
*   @param
*       tensor [in]: Handle to a previously created ML tensor object.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int (*pfnClReleaseMLTensorQCOM)(
    cl_ml_tensor_qcom              tensor);

/*******************************************************************************************************************************
*   pfnClReleaseMLOpQCOM
*
*   @brief
*       Releases a previously created ML op object.
*   @param
*       operation [in]: Handle to a previously created ML op object
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int (*pfnClReleaseMLOpQCOM)(
    cl_ml_op_qcom               operation);

/*******************************************************************************************************************************
*   pfnClCreateMLOpGemmQCOM
*   @brief
*       Creates an instance of GEMM op. This op computes <input_output_C> tensor.
*   @note
*        Mathematically, CLML Gemm op is input_output_C = Alpha * input_A * input_B + beta * input_output_C. So the third
*        tensor <input_output_C> in Gemm op  is technically both input and output tensor for non zero beta value. If beta is
*        zero, it will be output only.
*   @param
*       context               [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties        [in]: Pointer to a user created zero terminated list of ML op property key value pairs. If it is
*                                   NULL, it will be ignored.
*   @param
*       pGemm_descriptor      [in]: Pointer to a user created GEMM op descriptor object.
*   @param
*       input_A               [in]: Handle to a previously created GEMM op input_A tensor object.
*   @param
*       input_B               [in]: Handle to a previously created GEMM op input_B tensor object.
*   @param
*       input_output_C        [in]: Handle to a previously created GEMM op input_output_C tensor object.
*   @param
*       pOperation           [out]: Pointer to ML op handle and returns an abstract reference to the created instance of GEMM op.
*   @param
*       tuning_cache          [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpGemmQCOM)(
    cl_context                      context,
    const cl_ml_op_properties_qcom* pOp_properties,
    const cl_ml_op_gemm_desc_qcom*  pGemm_descriptor,
    cl_ml_tensor_qcom               input_A,
    cl_ml_tensor_qcom               input_B,
    cl_ml_tensor_qcom               input_output_C,
    cl_ml_op_qcom*                  pOperation,
    cl_ml_tuningcache_qcom          tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpTransposeQCOM
*   @brief
*       Creates an instance of transpose op. This op computes <output> tensor.
*   @param
*       context                [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties         [in]: Pointer to a user created zero terminated list of ML op property key value pairs. If it
*                                    is NULL, it will be ignored.
*   @param
*       pTranspose_descriptor  [in]: Pointer to a user created transpose op descriptor object.
*   @param
*       input                  [in]: Handle to a previously created transpose op input tensor object.
*   @param
*       output                 [in]: Handle to a previously created transpose op output tensor object.
*   @parma
*       pOperation            [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                    transpose op.
*   @param
*       tuning_cache           [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                    ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpTransposeQCOM)(
    cl_context                           context,
    const cl_ml_op_properties_qcom*      pOp_properties,
    const cl_ml_op_transpose_desc_qcom*  pTranspose_descriptor,
    cl_ml_tensor_qcom                    input,
    cl_ml_tensor_qcom                    output,
    cl_ml_op_qcom*                       pOperation,
    cl_ml_tuningcache_qcom               tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpFullyConnectedQCOM
*
*   @brief
*       Creates an instance of forward fully-connected op. This op computes <output> tensor.
*   @note
*       Mathematically, CLML fully connected op is output = input x weight + bias.
*   @param
*       context                      [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties               [in]: Pointer to a user created zero terminated list of ML op property key value pairs.
*                                          If it is NULL, it will be ignored.
*   @param
*       pFullyConnected_descriptor   [in]: Pointer to a user created fully-connected op descriptor object.
*   @param
*       input                        [in]: Handle to a previously created fully-connected input tensor object in
*                                          fwd propagation.
*   @param
*       weight                       [in]: Handle to a previously created fully-connected weight tensor object.
*   @param
*       bias                         [in]: Handle to a previously created fully-connected bias tensor object.
*   @param
*       output                       [in]: Handle to a previously created fully-connected output tensor object in fwd
*                                          propagation.
*   @param
*       pOperation                  [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                          fully-connected op.
*   @param
*       tuning_cache                 [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                          ignored.
* @return
*       CL_SUCCESS if the function executed successfully.
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpFullyConnectedQCOM)(
    cl_context                                 context,
    const cl_ml_op_properties_qcom*            pOp_properties,
    const cl_ml_op_fully_connected_desc_qcom*  pFullyConnected_descriptor,
    cl_ml_tensor_qcom                          input,
    cl_ml_tensor_qcom                          weight,
    cl_ml_tensor_qcom                          bias,
    cl_ml_tensor_qcom                          output,
    cl_ml_op_qcom*                             pOperation,
    cl_ml_tuningcache_qcom                     tuning_cache);

/*******************************************************************************************************************************
*   pfnClEnqueueMLOpQCOM
*
*   @brief
*      Enqueues an ML op to execute on device.
*   @param
*      queue:                     [in]: Handle to previously created OpenCL queue.
*   @param
*       operation                 [in]: Handle to a previously created ML op object.
*   @param
*       tensor_mem_descriptor_set [in]: Handle to a previously created ML tensor memory descriptor set. ML Tensor memory
*                                       descriptor set is a pool of ML tensor memory association from where each ML tensor
*                                       in an ML op will get its associated memory.
*   @param
*       num_events_in_wait_list   [in]: Number of events that need to complete before this particular ML op can be executed.
*   @param
*       pEvent_wait_list          [in]: Pointer to a list of events of size equals to <num_events_in_wait_list> that need to
*                                       complete before this particular ML op can be executed. If <num_events_in_wait_list>
*                                       is zero, it will be ignored; otherwise, it should point to a list of valid events.
*   @param
*       pEvent                   [out]: Pointer to event handle and returns an abstract reference to the created instance of
*                                       opencl event for this ML op. If it is null, it will be ignored and no event will be
*                                       created for this ML op; therefore it will not be possible for the application to
*                                       query (such as profiling info.) or queue a wait for this particular ML op.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int (*pfnClEnqueueMLOpQCOM)(
    cl_command_queue                    queue,
    cl_ml_op_qcom                       operation,
    cl_ml_tensor_mem_desc_set_qcom      tensor_mem_descriptor_set,
    cl_uint                             num_events_in_wait_list,
    const cl_event*                     pEvent_wait_list,
    cl_event*                           pEvent);

/*******************************************************************************************************************************
*   pfnClEnqueueMLOpImmutableQCOM
*
*   @brief
*       Enqueues an immutable ML op to execute on device.
*   @param
*      queue:                     [in]: Handle to previously created OpenCL queue.
*   @param
*       operation                 [in]: Handle to a previously created op object.
*   @param
*       tensor_mem_descriptor_set [in]: Handle to a previously created ML tensor memory descriptor set. ML Tensor memory
*                                       descriptor set is a pool of ML tensor memory association from where memory for each
*                                       tensor in an ML op will get its associated memory.
*   @param
*       num_events_in_wait_list   [in]: Number of events that need to complete before this particular ML op can be executed.
*   @param
*       pEvent_wait_list          [in]: Pointer to a list of events of size equals to <num_events_in_wait_list> that need to
*                                       complete before this particular ML op can be executed. If <num_events_in_wait_list>
*                                       is zero, it will be ignored; otherwise, it should point to a list of valid events.
*   @param
*       pEvent                   [out]: Pointer to event handle and returns an abstract reference to the created instance of
*                                       opencl event for this ML op. If it is null, it will be ignored and no event will be
*                                       created for this ML op; therefore it will not be possible for the application to
*                                       query (such as profiling info.) or queue a wait for this particular ML op.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int(*pfnClEnqueueMLOpImmutableQCOM)(
    cl_command_queue                    queue,
    cl_ml_op_qcom                       operation,
    cl_ml_tensor_mem_desc_set_qcom      tensor_mem_descriptor_set,
    cl_uint                             num_events_in_wait_list,
    const cl_event*                     event_wait_list,
    cl_event*                           pEvent);

/*******************************************************************************************************************************
*   pfnClEnqueueRecordingMLOpQCOM
*
*   @brief
*       Enqueues all ML ops and kernels in a recordable queue to execute on device with any parameter changes.
*   @param
*      queue:                   [in]: Handle to previously created OpenCL queue.
*   @param
*       recording               [in]: Handle to a previously created recording object.
*   @param
*       num_args                [in]: Number of kernel arg array struct elements pointed by <arg_array>.
*   @param
*       arg_array               [in]: Pointer to a user created list of kernel arg array struct to set kernel arguments.
*   @param
*       num_op_args             [in]: Number of ML op array struct elements pointed by <op_arg_array>.
*   @param
*       op_arg_array            [in]: Pointer to a user created list of ML op array struct to set tensor and correspoing
*                                     memory for an ML op.
*   @param
*       num_svm_args            [in]: Number of svm array structs pointed by <svm_arg_array>.
*   @param
*       svm_arg_array           [in]: Pointer to a user created list of svm array struct.
*   @param
*       num_global_offsets      [in]: Number of global offset array struct elements pointed by <global_offset_array>.
*   @param
*       global_offset_array     [in]: Pointer to a user created list of global offset array struct.
*   @param
*       num_global_workgroups   [in]: Number of global work group array struct elements pointed by <global_workgroup_array>.
*   @param
*       global_workgroup_array   in]: Pointer to a user created list of global workgroup array struct.
*   @param
*       num_local_workgroups    [in]: Number of local workgroup array struct elements pointed by <local_workgroup_array>.
*   @param
*       local_workgroup_array   [in]: Pointer to a user created list of local workgroup array struct.
*   @param
*       num_non_arg_objs        [in]: Number of non arg array struct elements pointed by <non_arg_obj_array>.
*   @param
*       non_arg_obj_array       [in]: Pointer to a user created list of non arg array struct.
*   @param
*       num_events_in_wait_list [in]: Number of events that need to complete before this particular recording can be executed.
*   @param
*       pEvent_wait_list        [in]: Pointer to a list of events of size equals to <num_events_in_wait_list> that need to
*                                     complete before this recording command can be executed. If <num_events_in_wait_list>
*                                     is zero, it will be ignored; otherwise, it should point to a list of valid events.
*   @param
*       pEvent                 [out]: Pointer to event handle and returns an abstract reference to the created instance of
*                                     opencl event for this recording. If it is null, it will be ignored and no event will be
*                                     created for this op; therefore it will not be possible for the application to query
*                                     (such as profiling info.) or queue a wait for this particular recording command.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int (*pfnClEnqueueRecordingMLOpQCOM)(
    cl_command_queue                        queue,
    cl_recording_qcom                       recording,
    size_t                                  num_args,
    const cl_array_arg_qcom*                arg_array,
    size_t                                  num_op_args,
    const cl_ml_op_array_arg_qcom*          op_arg_array,
    size_t                                  num_svm_args,
    const cl_array_arg_qcom*                svm_arg_array,
    size_t                                  num_global_offsets,
    const cl_offset_qcom*                   global_offset_array,
    size_t                                  num_global_workgroups,
    const cl_workgroup_qcom*                global_workgroup_array,
    size_t                                  num_local_workgroups,
    const cl_workgroup_qcom*                local_workgroup_array,
    size_t                                  num_non_arg_objs,
    const cl_array_kernel_exec_info_qcom*   non_arg_obj_array,
    cl_uint                                 num_events_in_wait_list,
    const cl_event*                         pEvent_wait_list,
    cl_event*                               pEvent);

/*******************************************************************************************************************************
*   pfnClCreateMLOpConvolutionForwardQCOM
*
*   @brief
*       Creates an instance of forward convolution op. This op computes <output> tensor.
*   @param
*       context                  [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties           [in]: Pointer to a user created zero terminated list of ML op property key value pairs.
*                                      If it is NULL, it will be ignored.
*   @param
*       pConvolution_descriptor  [in]: Pointer to a user created convolution descriptor object.
*   @param
*       input                    [in]: Handle to a previously created convolution input tensor object in fwd propagation.
*   @param
*       weight                   [in]: Handle to a previously created convolution weight tensor object.
*   @param
*       bias                     [in]: Handle to a previously created convolution bias tensor object.
*   @param
*       output                   [in]: Handle to a previously created convolution output tensor object in fwd propagation.
*   @param
*       pOperation              [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                      convolution forward op.
*   @param
*       tuning_cache             [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                      ignored.
*    @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpConvolutionForwardQCOM)(
    cl_context                             context,
    const cl_ml_op_properties_qcom*        pOp_properties,
    const cl_ml_op_convolution_desc_qcom*  pConvolution_descriptor,
    cl_ml_tensor_qcom                      input,
    cl_ml_tensor_qcom                      weight,
    cl_ml_tensor_qcom                      bias,
    cl_ml_tensor_qcom                      output,
    cl_ml_op_qcom*                         pOperation,
    cl_ml_tuningcache_qcom                 tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpBatchNormForwardQCOM
*
*   @brief
*       Creates an instance of forward batchnorm op. This op computes <output> tensor.
*   @param
*       context                [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties         [in]: Pointer to a user created zero terminated list of ML op property key value pairs.
*                                    If it is NULL, it will be ignored.
*   @param
*       pBatchNorm_descriptor  [in]: Pointer to a user created batchnorm descriptor object.
*   @param
*       input                  [in]: Handle to a previously created batchnorm input tensor object in fwd propagation.
*   @param
*       mean                   [in]: Handle to a previously created batchnorm mean tensor object.
*   @param
*       variance               [in]: Handle to a previously created batchnorm variance tensor object.
*   @param
*       scale                  [in]: Handle to a previously created batchnorm scale tensor object.
*   @param
*       output                 [in]: Handle to a previously created batchnorm output tensor object in fwd propagation.
*   @param
*       pOperation            [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                    batchnorm forward op.
*   @param
*       tuning_cache           [in]: Handle to a previously created ML tuning cache object. If it  is NULL, it will be
*                                    ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpBatchNormForwardQCOM)(
    cl_context                           context,
    const cl_ml_op_properties_qcom*      pOp_properties,
    const cl_ml_op_batchnorm_desc_qcom*  pBatchNorm_descriptor,
    cl_ml_tensor_qcom                    input,
    cl_ml_tensor_qcom                    mean,
    cl_ml_tensor_qcom                    variance,
    cl_ml_tensor_qcom                    scale,
    cl_ml_tensor_qcom                    bias,
    cl_ml_tensor_qcom                    output,
    cl_ml_op_qcom*                       pOperation,
    cl_ml_tuningcache_qcom               tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpBatchNormAccumulateStatisticsQCOM
*   @brief
*       Creates an instance of forward batchnorm statistics op to accumulate batchnorm statistics (mean and variance) during
*       training. This op computes <mean> and <variance>.
*   @param
*       context               [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties        [in]: Pointer to a user created zero terminated list of ML op property key value pairs.
*                                   If it is NULL, it will be ignored.
*   @param
*       pBatchNorm_descriptor [in]: Pointer to a user created batchnorm descriptor object.
*   @param
*      incr_batch_size        [in]: Unsigned integer value representing the incremental batch-size after each iteration within
*                                   a mini-batch.
*   @param
*       input                 [in]: Handle to a previously created batchnorm statistics input tensor object in fwd propagation.
*   @param
*       mean                  [in]: Handle to a previously created batchnorm mean tensor object.
*   @param
*       variacne              [in]: Handle to a previously created batchnorm variance tensor object.
*   @param
*       pOperation           [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                   batchnorm statistics op.
*   @param
*       tuning_cache          [in]: Handle to a previously created ML tuning cache object. If it  is NULL, it will be
*                                   ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int(*pfnClCreateMLOpBatchNormAccumulateStatisticsQCOM)(
    cl_context                           context,
    const cl_ml_op_properties_qcom*      pOp_properties,
    const cl_ml_op_batchnorm_desc_qcom*  pBatchNorm_descriptor,
    const cl_uint                        incr_batch_size,
    cl_ml_tensor_qcom                    input,
    cl_ml_tensor_qcom                    mean,
    cl_ml_tensor_qcom                    variance,
    cl_ml_op_qcom*                       pOperation,
    cl_ml_tuningcache_qcom               tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpBatchNormFinalizeStatisticsQCOM
*   @brief
*       Creates an instance of forward batchnorm statistics op to finalize batchnorm statistics (mean and variance) during
*       training. This op computes <mean> and <variance>.
*   @param
*       context               [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties        [in]: Pointer to a user created zero terminated list of ML op property key value pairs.
*                                   If it is NULL, it will be ignored.
*   @param
*       pBatchNorm_descriptor [in]: Pointer to a user created batchnorm descriptor object.
*   @param
*      batch_size             [in]: Unsigned integer value representing the size of mini-batch to finalize batchnorm
*                                   statistics over.
*   @param
*       input                 [in]: Handle to a previously created batchnorm statistics input tensor object in fwd propagation.
*   @param
*       mean                  [in]: Handle to a previously created batchnorm mean tensor object.
*   @param
*       variacne              [in]: Handle to a previously created batchnorm variance tensor object.
*   @param
*       pOperation            out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                   batchnorm statistics op.
*   @param
*       tuning_cache          [in]: Handle to a previously created ML tuning cache object. If it  is NULL, it will be
*                                   ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpBatchNormFinalizeStatisticsQCOM)(
    cl_context                           context,
    const cl_ml_op_properties_qcom*      pOp_properties,
    const cl_ml_op_batchnorm_desc_qcom*  pBatchNorm_descriptor,
    const cl_uint                        batch_size,
    cl_ml_tensor_qcom                    input,
    cl_ml_tensor_qcom                    mean,
    cl_ml_tensor_qcom                    variance,
    cl_ml_op_qcom*                       pOperation,
    cl_ml_tuningcache_qcom               tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpBatchNormVarianceGradientQCOM
*   @brief
*       Creates a cl_ml_op_qcom object for a batchnorm Op variance gradient. This op computes <variance_grad> tensor.
*   @param
*       context               [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties        [in]: Pointer to a user created zero terminated list of ML op property key value pairs.
*                                   If it is NULL, it will be ignored.
*   @param
*       pBatchNorm_descriptor [in]: Pointer to a user created batchnorm descriptor object.
*   @param
*       fwd_input             [in]: Handle to a previously created batchnorm input tensor object in fwd propagation.
*   @param
*       fwd_output_grad       [in]: Handle to a previously created batchnorm output gradient tensor object. Represents
*                                   gradient of loss w.r.t batchnorm output tensor in fwd propagation.
*   @param
*       mean                  [in]: Handle to a previously created batchnorm mean tensor object.
*   @param
*       variance              [in]: Handle to a previously created batchnorm variance tensor object.
*   @param
*       scale                 [in]: Handle to a previously created batchnorm scale tensor object.
*   @param
*       variance_grad         [in]: Handle to a previously created batchnorm variance gradient tensor object.
*   @param
*       pOperation            out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                   batchnorm variance gradient op.
*   @param
*       tuning_cache          [in]: Handle to a previously created ML tuning cache object. If it  is NULL, it will be
*                                   ignored.
*   @return
*       CL_SUCCESS if successful
*
*******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpBatchNormVarianceGradientQCOM)(
    cl_context                           context,
    const cl_ml_op_properties_qcom*      pOp_properties,
    const cl_ml_op_batchnorm_desc_qcom*  pBatchNorm_descriptor,
    cl_ml_tensor_qcom                    fwd_input,
    cl_ml_tensor_qcom                    fwd_output_grad,
    cl_ml_tensor_qcom                    mean,
    cl_ml_tensor_qcom                    variance,
    cl_ml_tensor_qcom                    scale,
    cl_ml_tensor_qcom                    variance_grad,
    cl_ml_op_qcom*                       pOperation,
    cl_ml_tuningcache_qcom               tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpBatchNormMeanGradientQCOM
*   @brief
*       Creates a cl_ml_op_qcom object for a batchnorm Op mean gradient. This op computes <mean_grad> tensor.
*   @param
*       context               [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties        [in]: Pointer to a user created zero terminated list of ML op property key value pairs.
*                                   If it is NULL, it will be ignored.
*   @param
*       pBatchNorm_descriptor [in]: Pointer to a user created batchnorm descriptor object.
*   @param
*      batch_size             [in]: Unsiged integer value representing size of mini-batch.
*   @param
*       fwd_input             [in]: Handle to a previously created batchnorm input tensor object in fwd propagation.
*   @param
*       fwd_output_grad       [in]: Handle to a previously created batchnorm output gradient tensor object. Represents
*                                   gradient of loss w.r.t batchnorm output tensor in fwd propagation.
*   @param
*       mean                  [in]: Handle to a previously created batchnorm mean tensor object.
*   @param
*       variance              [in]: Handle to a previously created batchnorm variance tensor object.
*   @param
*       scale                 [in]: Handle to a previously created batchnorm scale tensor object.
*   @param
*       variance_grad         [in]: Handle to a previously created batchnorm variance gradient tensor object.
*   @param
*       mean_grad             [in]: Handle to a previously created bathnorm mean gradient tensor object.
*   @param
*       pOperation           [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                   batchnorm mean gradient op.
*   @param
*       tuning_cache          [in]: Handle to a previously created ML tuning cache object. If it  is NULL, it will be
*                                   ignored.
*   @return
*       CL_SUCCESS if successful
*
*******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpBatchNormMeanGradientQCOM)(
    cl_context                           context,
    const cl_ml_op_properties_qcom*      pOp_properties,
    const cl_ml_op_batchnorm_desc_qcom*  pBatchNorm_descriptor,
    const cl_uint                        batch_size,
    cl_ml_tensor_qcom                    fwd_input,
    cl_ml_tensor_qcom                    fwd_output_grad,
    cl_ml_tensor_qcom                    mean,
    cl_ml_tensor_qcom                    variance,
    cl_ml_tensor_qcom                    scale,
    cl_ml_tensor_qcom                    variance_grad,
    cl_ml_tensor_qcom                    mean_grad,
    cl_ml_op_qcom*                       pOperation,
    cl_ml_tuningcache_qcom               tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpActivationForwardQCOM
*
*   @brief
*       Creates an instance of forward activation op. This op computes <output> tensor.
*   @param
*       context                 [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties          [in]: Pointer to a user created zero terminated list of ML Op property key value pairs.
*                                     If it is NULL, it will be ignored.
*   @param
*       pActivation_descriptor  [in]: Pointer to a user created activation descriptor object.
*   @param
*       input                   [in]: Handle to a previously created activation input tensor object in fwd propagation.
*   @param
*       param                   [in]: Handle to a previously created activation parameter tensor object.
*   @param
*       output_tensor           [in]: Handle to a previously created activation output tensor object in fwd propagation.
*   @param
*       pOperation             [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                     forward activation op.
*   @param
*       tuning_cache            [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                     ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpActivationForwardQCOM)(
    cl_context                           context,
    const cl_ml_op_properties_qcom*      pOp_properties,
    const cl_ml_op_activation_desc_qcom* pActivation_descriptor,
    cl_ml_tensor_qcom                    input,
    cl_ml_tensor_qcom                    param,
    cl_ml_tensor_qcom                    output,
    cl_ml_op_qcom*                       pOperation,
    cl_ml_tuningcache_qcom               tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpPoolingForwardQCOM
*
*   @brief
*       Creates an instance of forward pooling op. This op computes <output> and optional <mask> tensors.
*   @param
*       context              [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties       [in]: Pointer to a user created zero terminated list of ML tensor op key value pairs. If it is
*                                  NULL, it will be ignored.
*   @param
*       pPooling_descriptor  [in]: Pointer to a user created pooling descriptor object.
*   @param
*       input                [in]: Handle to a previously created pooling input tensor object in fwd propagation.
*   @param
*       mask                 [in]: Handle to a previously created pooling mask tensor object.
*   @param
*       output               [in]: Handle to a previously created pooling output tensor object in fwd propagation.
*   @param
*       pOperation          [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                  forward pooling op.
*   @param
*       tuning_cache         [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                  ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpPoolingForwardQCOM)(
    cl_context                         context,
    const cl_ml_op_properties_qcom*    pOp_properties,
    const cl_ml_op_pooling_desc_qcom*  pPooling_descriptor,
    cl_ml_tensor_qcom                  input,
    cl_ml_tensor_qcom                  mask,
    cl_ml_tensor_qcom                  output,
    cl_ml_op_qcom*                     pOperation,
    cl_ml_tuningcache_qcom             tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpFusedConvolutionActivationForwardQCOM
*
*   @brief
*       Creates an instance of forward fused convolution activation op. This op computes <output> tensor.
*   @param
*       context                   [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties            [in]: Pointer to a user created zero terminated list of ML op property key value pairs.
*                                       If it is NULL, it will be ignored.
*   @param
*       pConvolution_descriptor   [in]: Pointer to a user created convolution descriptor object.
*   @param
*       pActivation_descriptor    [in]: Pointer to a user created activation descriptor object.
*   @param
*       input                     [in]: Handle to a previously created convolution input tensor object in fwd propagation.
*   @param
*       weight                    [in]: Handle to a previously created convolution weight tensor object.
*   @param
*       bias                      [in]: Handle to a previously created convolution bias tensor object.
*   @param
*       param                     [in]: Handle to a previously created activation parameter tensor object.
*   @param
*       output                    [in]: Handle to a previously created activation output tensor in fwd propagation.
*   @param
*       pOperation               [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                       forward fused convolution activation op.
*   @param
*       tuning_cache              [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                       ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpFusedConvolutionActivationForwardQCOM)(
    cl_context                             context,
    const cl_ml_op_properties_qcom*        pOp_properties,
    const cl_ml_op_convolution_desc_qcom*  pConvolution_descriptor,
    const cl_ml_op_activation_desc_qcom*   pActivation_descriptor,
    cl_ml_tensor_qcom                      input,
    cl_ml_tensor_qcom                      weight,
    cl_ml_tensor_qcom                      bias,
    cl_ml_tensor_qcom                      param,
    cl_ml_tensor_qcom                      output,
    cl_ml_op_qcom*                         pOperation,
    cl_ml_tuningcache_qcom                 tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpFusedConvolutionBatchNormForwardQCOM
*
*   @brief
*       Creates an instance of forward fused convolution batchnorm op. This op computes <output> tensor.
*   @param
*       context                 [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties          [in]: Pointer to a user created zero terminated list of ML op property key value pairs.
*                                        If it is NULL, it will be ignored.
*   @param
*       pConvolution_descriptor [in]: Pointer to a user created convolution descriptor object.
*   @param
*       pBatchNorm_descriptor   [in]: Pointer to a user created batchnorm descriptor object.
*   @param
*       input                   [in]: Handle to a previously created convolution input tensor in fwd propagation.
*   @param
*       weight                  [in]: Handle to a previously created convolution weight tensor object.
*   @param
*       conv_bias               [in]: Handle to a previously created convolution bias tensor object.
*   @param
*       output                  [in]: Handle to a previously created batchnorm output tensor object in fwd propagation.
*   @param
*       mean                    [in]: Handle to a previously created batchnorm mean tensor object.
*   @param
*       variance                [in]: Handle to a previously created batchnorm variance tensor object.
*   @param
*       scale                   [in]: Handle to a previously created batchnorm scale tensor object.
*   @param
*       bn_bias                 [in]: Handle to a previously created batchnorm bias tensor object.
*   @param
*       pOperation             [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                     forward fused convolution batchnorm op.
*   @param
*       tuning_cache            [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                     ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpFusedConvolutionBatchNormForwardQCOM)(
    cl_context                             context,
    const cl_ml_op_properties_qcom*        pOp_properties,
    const cl_ml_op_convolution_desc_qcom*  pConvolution_descriptor,
    const cl_ml_op_batchnorm_desc_qcom*    pBatchNorm_descriptor,
    cl_ml_tensor_qcom                      input,
    cl_ml_tensor_qcom                      weight,
    cl_ml_tensor_qcom                      conv_bias,
    cl_ml_tensor_qcom                      output,
    cl_ml_tensor_qcom                      mean,
    cl_ml_tensor_qcom                      variance,
    cl_ml_tensor_qcom                      scale,
    cl_ml_tensor_qcom                      bn_bias,
    cl_ml_op_qcom*                         pOperation,
    cl_ml_tuningcache_qcom                 tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpFusedConvolutionBatchNormActivationForwardQCOM
*
*   @brief
*       Creates an instance of forward fused convolution batchnorm and activation forward op.  This op computes
*       <output> tensor.
*   @param
*       context                [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties         [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                    If it is NULL, it will be ignored.
*   @param
*       pConvolution_descriptor[in]: Pointer to a user created convolution descriptor object.
*   @param
*       pBatchNorm_descriptor  [in]: Pointer to a user created batchnorm descriptor object.
*   @param
*       pActivation_descriptor [in]: Pointer to a user created activation descriptor object.
*   @param
*       input                  [in]: Handle to a previously created convolution input tensor object in fwd propagation.
*   @param
*       weight                 [in]: Handle to a previously created convolution weight tensor object.
*   @param
*       conv_bias              [in]: Handle to a previously created convolution bias tensor object.
*   @param
*       output                 [in]: Handle to a previously created activation output tensor object in fwd propagation.
*   @param
*       param                  [in]: Handle to a previously created activation parameter tensor object.
*   @param
*       mean                   [in]: Handle to a previously created batchnorm mean tensor object.
*   @param
*       variance               [in]: Handle to a previously created batchnorm variance tensor object.
*   @param
*       scale                  [in]: Handle to a previously created batchnorm scale tensor object.
*   @param
*       bn_bias                [in]: Handle to a previously created batchnorm bias tensor object.
*   @param
*       pOperation            [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                    forward fused convolution batchnorm and activation op.
*   @param
*       tuning_cache           [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                    ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpFusedConvolutionBatchNormActivationForwardQCOM)(
    cl_context                             context,
    const cl_ml_op_properties_qcom*        pOp_properties,
    const cl_ml_op_convolution_desc_qcom*  pConvolution_descriptor,
    const cl_ml_op_batchnorm_desc_qcom*    pBatchNorm_descriptor,
    const cl_ml_op_activation_desc_qcom*   pActivation_descriptor,
    cl_ml_tensor_qcom                      input,
    cl_ml_tensor_qcom                      weight,
    cl_ml_tensor_qcom                      conv_bias,
    cl_ml_tensor_qcom                      output,
    cl_ml_tensor_qcom                      param,
    cl_ml_tensor_qcom                      mean,
    cl_ml_tensor_qcom                      variance,
    cl_ml_tensor_qcom                      scale,
    cl_ml_tensor_qcom                      bn_bias,
    cl_ml_op_qcom*                         pOperation,
    cl_ml_tuningcache_qcom                 tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpBinaryQCOM
*
*   @brief
*       Creates an instance of binary op. This op computes <input_output_C> tensor.
*   @note
*       Mathematically, CLML binary operation is input_output_C = (alpha * input_A) <operation> (beta * input_B) + gamma *
*       input_output_C. So the third tensor <input_output_C> in Binary op  is technically both input and output tensor for non
*       zero beta value. If beta is zero, it will be output only.
*   @param
*       context             [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties      [in]: Pointer to a user created zero terminated list of ML op property key value pairs.
*                                 If it is NULL, it will be ignored.
*   @param
*       pBinary_descriptor  [in]: Pointer to a user created binary descriptor object.
*   @param
*       input_A             [in]: Handle to a previously created binary input_A tensor object in fwd propagation.
*   @param
*       input_B             [in]: Handle to a previously created binary input_B tensor object in fwd propagation.
*   @param
*       input_output_C      [in]: Handle to a previously created binary input_output_C tensor object in fwd propagation.
*   @param
*       pOperation         [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                 binary op.
*   @param
*       tuning_cache        [in]: Handle to a previously created ML tuning cache object. If it is NULL, it  will be
*                                 ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpBinaryQCOM)(
    cl_context                        context,
    const cl_ml_op_properties_qcom*   pOp_properties,
    const cl_ml_op_binary_desc_qcom*  pBinary_descriptor,
    cl_ml_tensor_qcom                 input_A,
    cl_ml_tensor_qcom                 input_B,
    cl_ml_tensor_qcom                 input_output_C,
    cl_ml_op_qcom*                    pOperation,
    cl_ml_tuningcache_qcom            tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpSoftmaxQCOM
*
*   @brief
*       Creates an instance of forward softmax op. This op computes <output> tensor.
*   @param
*       context             [ in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties       [in]: Pointer to a user created zero terminated list of ML op property key value pairs.
*                                  If it is NULL, it will be ignored.
*   @param
*       pSoftmax_descriptor  [in]: Pointer to a user created softmax descriptor object.
*   @param
*       input                [in]: Handle to a previously created softmax input tensor object in fwd propagation.
*   @param
*       output               [in]: Handle to a previously created softmax output tensor object in fwd propagation.
*   @param
*       pOperation          [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                  softmax op.
*   @param
*       tuning_cache         [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                  ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpSoftmaxQCOM)(
    cl_context                        context,
    const cl_ml_op_properties_qcom*   pOp_properties,
    const cl_ml_op_softmax_desc_qcom* pSoftmax_descriptor,
    cl_ml_tensor_qcom                 input,
    cl_ml_tensor_qcom                 output,
    cl_ml_op_qcom*                    pOperation,
    cl_ml_tuningcache_qcom            tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpConcatQCOM
*
*   @brief
*       Creates an instance of forward concat op. This op computes <output> tensor.
*   @param
*       context             [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties      [in]: Pointer to a user created zero terminated list of ML op property key value pairs.
*                                 If it is NULL, it will be ignored.
*   @param
*       pConcat_descriptor  [in]: Pointer to a user created concat descriptor object.
*   @param
*       pInput_list         [in]: Pointer to a list of previously created handles to concat input tensor objects in
*                                 fwd propagation.
*   @param
*       output              [in]: Handle to a previously created concat output tensor object in fwd propagation.
*   @param
*       pOperation         [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                 concat op.
*   @param
*       tuning_cache        [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpConcatQCOM)(
    cl_context                        context,
    const cl_ml_op_properties_qcom*   pOp_properties,
    const cl_ml_op_concat_desc_qcom*  pConcat_descriptor,
    cl_ml_tensor_qcom*                pInput_list,
    cl_ml_tensor_qcom                 output,
    cl_ml_op_qcom*                    pOperation,
    cl_ml_tuningcache_qcom            tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpPermuteQCOM
*
*   @brief
*       Creates an instance of forward permute op. This op computes <output> tensor.
*   @param
*       context              [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties       [in]: Pointer to a user created zero terminated list of ML op property key value pairs.
*                                  If it is NULL, it will be ignored.
*   @param
*       pPermute_descriptor  [in]: Pointer to a user created permute descriptor object.
*   @param
*       input                [in]: Handle to a previously created permute input tensor object in fwd propagation.
*   @param
*       output               [in]: Handle to a previously created permute output tensor object in fwd propagation.
*   @param
*       pOperation          [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                  permute op.
*   @param
*       tuning_cache         [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpPermuteQCOM)(
    cl_context                        context,
    const cl_ml_op_properties_qcom*   pOp_properties,
    const cl_ml_op_permute_desc_qcom* pPermute_descriptor,
    cl_ml_tensor_qcom                 input,
    cl_ml_tensor_qcom                 output,
    cl_ml_op_qcom*                    pOperation,
    cl_ml_tuningcache_qcom            tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpDepthToSpaceQCOM
*
*   @brief
*       Creates an instance of depth to space operation. This op computes <output> tensor.
*   @param
*       context                     [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties              [in]: Pointer to a user created zero terminated list of ML tensor property key value pairs.
*                                         If it is NULL, it will be ignored.
*   @param
*       pDepthToSpace_descriptor    [in]: Pointer to a user created depth to space descriptor object.
*   @param
*       input                       [in]: Handle to a previously created depth to space input tensor object.
*   @param
*       output                      [in]: Handle to a previously created depth to space output tensor object.
*   @param
*       pOperation                 [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                         depth to space operation.
*   @param
*       tuning_cache                [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                         ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpDepthToSpaceQCOM)(
    cl_context                             context,
    const cl_ml_op_properties_qcom*        pOp_properties,
    const cl_ml_op_depthtospace_desc_qcom* pDepthToSpace_descriptor,
    cl_ml_tensor_qcom                      input,
    cl_ml_tensor_qcom                      output,
    cl_ml_op_qcom*                         pOperation,
    cl_ml_tuningcache_qcom                 tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpFusedDepthToSpaceActivationQCOM
*
*   @brief
*       Creates an instance of fused depth to space activation operation. This op computes <output> tensor.
*   @param
*       context                     [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties              [in]: Pointer to a user created zero terminated list of ML Op property key value pairs.
*                                         If it is NULL, it will be ignored.
*   @param
*       pDepthToSpace_descriptor    [in]: Pointer to a user created depth to space descriptor object.
*   @param
*       pActivation_descriptor      [in]: Pointer to a user created activation descriptor object.
*   @param
*       input                       [in]: Handle to a previously created depth to space input tensor object.
*   @param
*       param                       [in]: Handle to a previously activation parameter tensor object.
*   @param
*       output                      [in]: Handle to a previously created activation output tensor object.
*   @param
*       pOperation                 [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                         fused depth to space activation operation.
*   @param
*       tuning_cache                [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                         ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpFusedDepthToSpaceActivationQCOM)(
    cl_context                                context,
    const cl_ml_op_properties_qcom*           pOp_properties,
    const cl_ml_op_depthtospace_desc_qcom*    pDepthToSpace_descriptor,
    const cl_ml_op_activation_desc_qcom*      pActivation_descriptor,
    cl_ml_tensor_qcom                         input,
    cl_ml_tensor_qcom                         param,
    cl_ml_tensor_qcom                         output,
    cl_ml_op_qcom*                            pOperation,
    cl_ml_tuningcache_qcom                    tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpFillQCOM
*
*   @brief
*       Creates an instance of fill operation operation. This op computes <tensor> tensor.
*   @param
*       context           [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties    [in]: Pointer to a user created zero terminated list of ML op property key value pairs.
*                               If it is NULL, it will be ignored.
*   @param
*       pFill_descriptor  [in]: Pointer to a user created fill descriptor object.
*   @param
*       tensor            [in]: Handle to a previously created fill tensor object.
*   @param
*       pOperation       [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                               fill activation operation.
*   @param
*       tuning_cache      [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                               ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpFillQCOM)(
    cl_context                        context,
    const cl_ml_op_properties_qcom*   pOp_properties,
    const cl_ml_op_fill_desc_qcom*    pFill_descriptor,
    cl_ml_tensor_qcom                 tensor,
    cl_ml_op_qcom*                    pOperation,
    cl_ml_tuningcache_qcom            tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpResizeBilinearQCOM
*
*   @brief
*       Creates an instance of forward resize bilinear operation operation. This op computes <output> tensor.
*   @param
*       context                      [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties               [in]: Pointer to a user created zero terminated list of ML Op property key value pairs.
*                                          If it is NULL, it will be ignored.
*   @param
*       pResizeBilinear_descriptor   [in]: Pointer to a user created resize bilinear descriptor object.
*   @param
*       input                        [in]: Handle to a previously created resize bilinear input tensor object in fwd
*                                          propagation.
*   @param
*       output                       [in]: Handle to a previously created resize bilinear output tensor object in fwd
*                                          propagation.
*   @param
*       pOperation                  [out]: Pointer to ML op handle and returns an abstract reference to the created instance
*                                          of resize bilinear operation.
*   @param
*       tuning_cache                 [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                          ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpResizeBilinearQCOM)(
    cl_context                                 context,
    const cl_ml_op_properties_qcom*            pOp_properties,
    const cl_ml_op_resize_bilinear_desc_qcom*  pResizeBilinear_descriptor,
    cl_ml_tensor_qcom                          input,
    cl_ml_tensor_qcom                          output,
    cl_ml_op_qcom*                             pOperation,
    cl_ml_tuningcache_qcom                     tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpPadQCOM
*
*   @brief
*       Creates an instance of forward pad operation operation. This op computes <output> tensor.
*   @param
*       context         [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties  [in]: Pointer to a user created zero terminated list of ML op property key value pairs. If it is NULL,
*                             it will be ignored.
*   @param
*       pPad_descriptor [in]: Pointer to a user created pad descriptor object.
*   @param
*       input           [in]: Handle to a previously created pad input tensor object.
*   @param
*       output          [in]: Handle to a previously created pad output tensor object.
*   @param
*       p_operation    [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                             pad operation.
*   @param
*       tuning_cache    [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpPadQCOM)(
    cl_context                          context,
    const cl_ml_op_properties_qcom*     pOp_properties,
    const cl_ml_op_pad_desc_qcom*       pPad_descriptor,
    cl_ml_tensor_qcom                   input,
    cl_ml_tensor_qcom                   output,
    cl_ml_op_qcom*                      pOperation,
    cl_ml_tuningcache_qcom              tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpCopyQCOM
*
*   @brief
*       Creates an instance of copy operation. This op computes <output> tensor.
*   @param
*       context         [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties  [in]: Pointer to a user created zero terminated list of ML op property key value pairs. If it is NULL,
*                             it will be ignored.
*   @param
*       input           [in]: Handle to a previously created tensor object to serve as source.
*   @param
*       output          [in]: Handle to a previously created tensor object to serve as destination.
*   @param
*       pOperation     [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                             copy operation.
*   @param
*       tuning_cache    [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpCopyQCOM)(
    cl_context                        context,
    const cl_ml_op_properties_qcom*   pOp_properties,
    cl_ml_tensor_qcom                 input,
    cl_ml_tensor_qcom                 output,
    cl_ml_op_qcom*                    pOperation,
    cl_ml_tuningcache_qcom            tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpReshapeQCOM
*
*   @brief
*       Creates an instance of reshape operation. This op computes <output> tensor.
*   @param
*       context         [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties  [in]: Pointer to a user created zero terminated list of ML op property key value pairs. If it is NULL,
*                             it will be ignored.
*   @param
*       input           [in]: Handle to a previously created reshape input tensor object.
*   @param
*       output          [in]: Handle to a previously created reshape output tensor object.
*   @param
*       pOperation     [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                             reshape operation.
*   @param
*       tuning_cache    [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpReshapeQCOM)(
    cl_context                        context,
    const cl_ml_op_properties_qcom*   pOp_properties,
    cl_ml_tensor_qcom                 input,
    cl_ml_tensor_qcom                 output,
    cl_ml_op_qcom*                    pOperation,
    cl_ml_tuningcache_qcom            tuning_cache);

/*******************************************************************************************************************************
*   pfnClGetMLTensorMemorySizeQCOM
*
*   @brief
*       Queries memory size required for the given ML tensor.
*   @note
*       For linear ML tensors (NCHW/NHWC), this function can be called  to query tensor memeory size immediately after we
*       create ML tensors. But for optimal ML tensors, this function can only be called to query tensor memory size after
*       the ML tensor is used in an ML op. That means, need to first create the ML op that is going to use the ML tensor
*       before calling this function.
*   @param
*       context              [in]: Handle to previously created OpenCL context.
*   @param
*       tensor               [in]: Handle to a previously created ML tensor object.
*   @param
*       pTensor_memory_size [out]: Pointer to cl_unit that returns the memory size required for the given ML tensor.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClGetMLTensorMemorySizeQCOM)(
    cl_context                        context,
    cl_ml_tensor_qcom                 tensor,
    cl_uint*                          pTensor_memory_size);

/*******************************************************************************************************************************
*   pfnClEnqueueReadMLTensorDataQCOM
*
*   @brief
*       Enqueues a read command to read ML tensor data from the associated GPU memory of an ML tensor into the given host
*       memory.
*   @param
*       queue                   [in]: Handle to previously created OpenCL command queue.
*   @param
*       src_tensor              [in]: Handle to a previously created source tensor object.
*   @param
*       src_memory              [in]: Handle to a previously created cl memory object for the source ML tensor.
*   @param
*       dst_layout              [in]: Enum type that specifies in which memory layout data should be copied in the
*                                     destination (host) memory.
*   @param
*       dst_dataptr            [out]: Pointer to a user-allocated host memory. The size of allocated host memory should be
*                                     equal to the size of source memory; otherwise, behaviour is undefined.
*   @param
*       num_events_in_wait_list [in]: Number of events that need to complete before this command can be executed.
*   @param
*       pEvent_wait_list        [in]: Pointer to a list of events of size equals to <num_events_in_wait_list> that need to
*                                     complete before this particular this can be executed. If <num_events_in_wait_list>
*                                     is zero, it will be ignored; otherwise, it should point to a list of valid events.
*   @param
*       pEvent                 [out]: Pointer to event handle and returns an abstract reference to the created instance of
*                                     opencl event for this command. If it is null, it will be ignored and no event will be
*                                     created for this command; therefore it will not be possible for the application to
*                                     query (such as profiling info.) or queue a wait for this particular command.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClEnqueueReadMLTensorDataQCOM)(
    cl_command_queue                  queue,
    cl_ml_tensor_qcom                 src_tensor,
    cl_mem                            src_memory,
    void*                             dst_dataptr,
    cl_ml_tensor_layout_qcom          dst_layout,
    cl_uint                           num_events_in_wait_list,
    const cl_event*                   pEvent_wait_list,
    cl_event*                         pEvent);

/*******************************************************************************************************************************
*   pfnClEnqueueWriteMLTensorDataQCOM
*
*   @brief
*       Enqueues a write command to write ML tensor data into the associated GPU memory of an ML tensor from the given host
*       memory.
*   @param
*       queue                   [in]: Handle to previously created OpenCL command queue.
*   @param
*       src_dataptr             [in]: Pointer to the host memory containing ML tensor data. The size of host memory should be
*                                     equal to the size of destination memory; otherwise, behaviour is undefined.
*   @param
*       src_layout              [in]: Enum type that specifies the source memory layout.
*   @param
*       dst_tensor              [in]: Handle to a previously created destination ML tensor object.
*   @param
*       dst_memory             [out]: Handle to a previously created cl memory object for the destination tensor.
*   @param
*       num_events_in_wait_list [in]: Number of events that need to complete before this command can be executed.
*   @param
*       pEvent_wait_list        [in]: Pointer to a list of events of size equals to <num_events_in_wait_list> that need to
*                                     complete before this particular this can be executed. If <num_events_in_wait_list>
*                                     is zero, it will be ignored; otherwise, it should point to a list of valid events.
*   @param
*       pEvent                 [out]: Pointer to event handle and returns an abstract reference to the created instance of
*                                     opencl event for this command. If it is null, it will be ignored and no event will be
*                                     created for this command; therefore it will not be possible for the application to
*                                     query (such as profiling info.) or queue a wait for this particular command.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClEnqueueWriteMLTensorDataQCOM)(
    cl_command_queue                  queue,
    void*                             src_dataptr,
    cl_ml_tensor_layout_qcom          src_layout,
    cl_ml_tensor_qcom                 dst_tensor,
    cl_mem                            dst_memory,
    cl_uint                           num_events_in_wait_list,
    const cl_event*                   pEvent_wait_list,
    cl_event*                         pEvent);

/*******************************************************************************************************************************
*   pfnClEnqueueCopyMLTensorDataQCOM
*
*   @brief
*       Enqueues a copy command to copy ML tensor data from the associated GPU memory of one ML tensor into the associated GPU
*       memory of another ML tensor.
*   @param
*       queue                   [in]: Handle to previously created OpenCL command queue.
*   @param
*       src_tensor              [in]: Handle to a previously created source ML tensor object.
*   @param
*       src_memory              [in]: Handle to a previously created cl memory object for the source ML tensor.
*   @param
*       dst_tensor              [in]: Handle to a previously created destination ML tensor object.
*   @param
*       dst_memory             [out]: Handle to a previously created cl memory object for the destination ML tensor.
*   @param
*       num_events_in_wait_list [in]: Number of events that need to complete before this command can be executed.
*   @param
*       pEvent_wait_list        [in]: Pointer to a list of events of size equals to <num_events_in_wait_list> that need to
*                                     complete before this particular this can be executed. If <num_events_in_wait_list>
*                                     is zero, it will be ignored; otherwise, it should point to a list of valid events.
*   @param
*       pEvent                 [out]: Pointer to event handle and returns an abstract reference to the created instance of
*                                     opencl event for this command. If it is null, it will be ignored and no event will be
*                                     created for this command; therefore it will not be possible for the application to
*                                     query (such as profiling info.) or queue a wait for this particular command.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClEnqueueCopyMLTensorDataQCOM)(
    cl_command_queue                  queue,
    cl_ml_tensor_qcom                 src_tensor,
    cl_mem                            src_memory,
    cl_ml_tensor_qcom                 dst_tensor,
    cl_mem                            dst_memory,
    cl_uint                           num_events_in_wait_list,
    const cl_event*                   pEvent_wait_list,
    cl_event*                         pEvent);

/*******************************************************************************************************************************
*   pfnClCreateMLTuningCacheQCOM
*
*   @brief
*       Creates an instance of tuning cache objecet to store ML Op tuning results when tuning the ML Op using clTuneMlOpQCOM
*       API.
*   @param
*       pTuning_cache [out]: Pointer to ML tuning cache object handle and returns an abstract reference to the created
*                            instance of ML tuning cache object.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLTuningCacheQCOM)(
    cl_ml_tuningcache_qcom* pTuning_cache);

/*******************************************************************************************************************************
*   pfnClTuneMLOpQCOM
*
*   @brief
*       Tunes the given ML Op for better performance on device.
*   @param
*       queue                    [in]: Handle to previously created OpenCL command queue.
*   @param
*       operation                [in]: Handle to a previously created ML op object.
*   @param
*       tensor_mem_descritor_set [in]: Handle to a previously created ML tensor memeory descriptor object.
*   @param
*       tuning_cache            [out]: Handle to a previously created ML tuning cache object. After successful tuning of
*                                      the given ML op, all the tuned information will be written in this ML tuning cache
*                                      object.
*   @param
*       pTuned_execution_time   [out]: Pointer to cl_ulong and returns the tuned execution time for the given ML op. If it
*                                      is null, it will be ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClTuneMLOpQCOM)(
    cl_command_queue                    queue,
    cl_ml_op_qcom                       operation,
    cl_ml_tensor_mem_desc_set_qcom      tensor_mem_descriptor_set,
    cl_ml_tuningcache_qcom              tuning_cache,
    cl_ulong*                           pTuned_execution_time);


/*******************************************************************************************************************************
*   pfnClSaveMLTuningCacheQCOM
*
*   @brief
*       Saves an existing ML tuning cache object into the given buffer.
*   @param
*       tuning_cache [in]: Handle to previously created ML tuning cache object.
*   @param
*       len          [in]: length of the buffer pointed by pBytes. If PBytes is not NULL, it should be at least of the size
*                          returned by <pLenRet>.
*   @param
*       pBytes      [out]: Pointer to a user-created unsigned char buffer of size len and returns tuning information copied
*                          from the given <tuning_cache> object. If it is NULL, it will be ignored.
*   @param
*       pLen_ret    [out]: Pointer to size_t and returns size of the buffer of type unsigned char that needs to be created
*                          in order to save the <tuning_cache> object. If it is NULL, it will be ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClSaveMLTuningCacheQCOM)(
    cl_ml_tuningcache_qcom  tuning_cache,
    size_t                  len,
    unsigned char*          pBytes,
    size_t*                 pLen_ret);

/*******************************************************************************************************************************
*   pfnClLoadMLTuningCacheQCOM
*
*   @brief
*       Loads an existing tuning information into the given ML tuning cache object.
*   @param
*       tuning_cache [out]: Handle to previously created ML tuning cache object.
*   @param
*       len          [in]: length of the buffer pointed by pBytes. len should be at least the size  of cl_uint.
*   @param
*       pBytes       [in]: Pointer to a unsigned char buffer of size len containing tuning information. It should point to a
*                          valid memory at least of size equals to size of cl_unit.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClLoadMLTuningCacheQCOM)(
    cl_ml_tuningcache_qcom  tuning_cache,
    size_t                  len,
    unsigned char*          pBytes);

/*******************************************************************************************************************************
*   pfnClReleaseMLTuningCacheQCOM
*
*   @brief
*       Releases a previously created ML tuning cache object
*   @param
*       tuning_cache [in]: Handle to previously created ML tuning cache object.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int (*pfnClReleaseMLTuningCacheQCOM)(
    cl_ml_tuningcache_qcom  tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLTensorMemoryDescriptorSetQCOM
*
*   @brief
*       Creates an instance of ML tensor memory descriptor set object.
*   @param
*       pTensor_mem_descriptor_set [out]: Pointer to ML tensor memory descriptor set handle and returns an abstract reference
*                                         to the created instance of ML tensor memory descriptor set object.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLTensorMemoryDescriptorSetQCOM)(
    cl_ml_tensor_mem_desc_set_qcom* pTensor_mem_descriptor_set);

/*******************************************************************************************************************************
*   pfnClReleaseMLTensorMemoryDescriptorSetQCOM
*
*   @brief
*       Releases a previously created ML  tensor memory descritptor set object.
*   @param
*       tensor_mem_descriptor_set [in]: Handle to previously created ML tensor memory descriptor set object.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int (*pfnClReleaseMLTensorMemoryDescriptorSetQCOM)(
    cl_ml_tensor_mem_desc_set_qcom tensor_mem_descriptor_set);

/*******************************************************************************************************************************
*   pfnClUpdateMLTensorMemoryDescriptorSetQCOM
*
*   @brief
*       Update an ML tensor memory descriptor set by registering the memory-tensor association.
*   @desc
*       The associations are created pairwise for every element in mems and ML tensors in order. In other words, if you pass
*       in [cl_mem A, cl_mem B] for mems and [tensor X, tensor Y] for tensors, then the memory A will be associated with
*       tensor X, and the memory B will be associated with tensor Y. Passing in a tensor already used in a previous call
*       overwrites an existing association. If the same tensor is passed in multiple locations in the same call, then the
*       result is implementation-defined, with no guarantee as to the precise behavior.
*   @param
*       tensor_mem_descriptor_set [out]: Handle to previously created ML tensor memory descriptor set object.
*   @param
*       num_tensor_mem_descriptors [in]: size of ML tensor memory pair to be registered as memory-tensor association.
*   @param
*       pTensor_mem_descriptors    [in]: Pointer to a list of ML tensor memory pair of size equals to
*                                        <num_tensor_mem_descriptors>.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int (*pfnClUpdateMLTensorMemoryDescriptorSetQCOM)(
    cl_ml_tensor_mem_desc_set_qcom  tensor_mem_descriptor_set,
    uint32_t                        num_tensor_mem_descriptors,
    cl_ml_tensor_memory_desc_qcom*  pTensor_mem_descriptors);

/*******************************************************************************************************************************
*   pfnCreateKernelArgMLTensorQCOM
*   @brief
*       Creates a cl_mem object which can be used to set the kernel arg of type qcom_tensor_t for a kernel using
*       <clSetKernelArg()> API.
*   @param
*       context                 [in]: Handle to previously created CL context.
*   @param
*       pTensor_mem_descriptors [in]: Pointer to tensor memory descriptor object holding handle to previously created CLML
*                                     optimal tensor and associated buffer backing memory.
*   @param
*       pTensor_arg_ret        [out]: Pointer to ML optimal tensor arg of type cl_mem to be returned.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int(*pfnCreateKernelArgMLTensorQCOM)(
    cl_context                           context,
    const cl_ml_tensor_memory_desc_qcom* pTensor_mem_descriptors,
    cl_mem*                              pTensor_arg_ret);

/*******************************************************************************************************************************
*   pfnClCreateMLOpActivationBackwardQCOM
*   @brief
*       Creates a cl_ml_op_qcom object for a backward activation op. This op computes <fwd_input_grad> tensor.
*   @param
*       context                [in]: Handle to previously created CL context.
*   @param
*       pOp_properties         [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                    If it is NULL, it will be ignored.
*   @param
*       pActivation_descriptor [in]: Pointer to a user created activation descriptor object.
*   @param
*       fwd_input              [in]: Handle to a previously created activation input tensor object in fwd propagation.
*   @param
*       fwd_output_grad        [in]: Handle to a previously created activation output gradient tensor object. Represents
*                                    gradient of loss w.r.t activation output tensor in fwd propagation.
*   @param
*       param                  [in]: Handle to a previously created act param tensor object.
*   @param
*       fwd_input_grad         [in]: Handle to a previously created activation input gradient tensor object. Represents
*                                    gradient of loss w.r.t activation input tensor in fwd propagation.
*   @param
*       pOperation            [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                    activation backward op.
*   @param
*       tuning_cache           [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                    ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpActivationBackwardQCOM)(
    cl_context                              context,
    const cl_ml_op_properties_qcom*         pOp_properties,
    const cl_ml_op_activation_desc_qcom*    pActivation_descriptor,
    cl_ml_tensor_qcom                       fwd_input,
    cl_ml_tensor_qcom                       fwd_output_grad,
    cl_ml_tensor_qcom                       param,
    cl_ml_tensor_qcom                       fwd_input_grad,
    cl_ml_op_qcom*                          pOperation,
    cl_ml_tuningcache_qcom                  tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpActivationParamGradientsQCOM
*   @brief
*       Creates a cl_ml_op_qcom object for activation parameter gradient op for Prelu activation. This op computes
*       <param_grad> tensor.
*   @param
*       context                [in]: Handle to previously created CL context.
*   @param
*       pOp_properties         [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                    If it is NULL, it will be ignored.
*   @param
*       pActivation_descriptor [in]: Pointer to a user created activation descriptor object.
*   @param
*       fwd_input              [in]: Handle to a previously created activation input tensor object in fwd propagation.
*   @param
*       fwd_output_grad        [in]: Handle to a previously created activation output gradient tensor object. Represents
*                                    gradient of loss w.r.t. activation output tensor in fwd propagation.
*   @param
*       param_grad             [in]: Handle to a previously activation parameter gradient tensor object and provides parameter
*                                    gradient data to update <param> tensor.
*   @param
*       param                  [in]: Handle to a previously created activation parameter tensor object.
*   @param
*       pOperation            [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                    activation parameter gradient op.
*   @param
*       tuning_cache           [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                    ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int(*pfnClCreateMLOpActivationParamGradientQCOM)(
    cl_context                              context,
    const cl_ml_op_properties_qcom*         pOp_properties,
    const cl_ml_op_activation_desc_qcom*    pActivation_descriptor,
    cl_ml_tensor_qcom                       fwd_input,
    cl_ml_tensor_qcom                       fwd_output_grad,
    cl_ml_tensor_qcom                       param_grad,
    cl_ml_tensor_qcom                       param,
    cl_ml_op_qcom*                          pOperation,
    cl_ml_tuningcache_qcom                  tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpLossForwardQCOM
*   @brief
*       Creates a cl_ml_op_qcom object for a specified loss function op. This op computes <output_loss> tensor.
*   @param
*       context                [in]: Handle to previously created CL context.
*   @param
*       pOp_properties         [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                    If it is NULL, it will be ignored.
*   @param
*       pLoss_fwd_descriptor   [in]: Pointer to a user created loss fwd descriptor object.
*   @param
*       model_output           [in]: Handle to a previously created model output tensor object.
*   @param
*       target_output          [in]: Handle to a previously created target output tensor object and provides true output
*                                    data (labels on a given dataset).
*   @param
*       weight                 [in]: Handle to a previously created weight tensor object and provides weighted value for each
*                                    output loss value.
*   @param
*       output_loss            [in]: Handle to a previously created output loss tensor object.
*   @param
*       pOperation            [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                    activation parameter gradient op.
*   @param
*       tuning_cache           [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                    ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpLossForwardQCOM)(
    cl_context                         context,
    const cl_ml_op_properties_qcom*    pOp_properties,
    const cl_ml_op_loss_fwd_desc_qcom* pLoss_fwd_descriptor,
    cl_ml_tensor_qcom                  model_output,
    cl_ml_tensor_qcom                  target_output,
    cl_ml_tensor_qcom                  weight,
    cl_ml_tensor_qcom                  output_loss,
    cl_ml_op_qcom*                     pOperation,
    cl_ml_tuningcache_qcom             tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpLossBackwardQCOM
*   @brief
*       Creates a cl_ml_op_qcom object for a specified loss function gradient op. This op computes <fwd_model_output_grad>
*       tensor.
*   @param
*       context                [in]: Handle to previously created CL context.
*   @param
*       pOp_properties         [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                    If it is NULL, it will be ignored.
*   @param
*       pLoss_bwd_descriptor   [in]: Pointer to a user created loss backward descriptor object.
*   @param
*       fwd_model_output       [in]: Handle to a previously created model output tensor object in fwd propagation.
*   @param
*       fwd_target_output      [in]: Handle to a previously created target output tensor object in fwd propagation and
*                                    provides true output data (labels on a given dataset).
*   @param
*       weight                 [in]: Handle to a previously created weight tensor object and provides weighted value for
*                                    each fwd model output grad value.
*   @param
*       fwd_model_output_grad  [in]: Handle to a previously created model output gradient tensor object. Represents
*                                    gradient of loss w.r.t model output tensor in fwd propagation.
*   @param
*       pOperation            [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                    activation parameter gradient op.
*   @param
*       tuning_cache           [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                    ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpLossBackwardQCOM)(
    cl_context                         context,
    const cl_ml_op_properties_qcom*    pOp_properties,
    const cl_ml_op_loss_bwd_desc_qcom* pLoss_bwd_descriptor,
    cl_ml_tensor_qcom                  fwd_model_output,
    cl_ml_tensor_qcom                  fwd_target_output,
    cl_ml_tensor_qcom                  weight,
    cl_ml_tensor_qcom                  fwd_model_output_grad,
    cl_ml_op_qcom*                     pOperation,
    cl_ml_tuningcache_qcom             tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpConvolutionBackwardQCOM
*   @brief
*       Creates a cl_ml_op_qcom object for a backward convolution Op. This op computes <fwd_input_grad> tensor.
*   @param
*       context                 [in]: Handle to previously created CL context.
*   @param
*       pOp_properties          [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                     If it is NULL, it will be ignored.
*   @param
*       pConvolution_descriptor [in]: Pointer to a user created convolution descriptor object.
*   @param
*       fwd_output_grad         [in]: Handle to a previously created convolution output gradient tensor object. Represents
*                                     gradient of loss w.r.t convolution output tensor in fwd propagation.
*   @param
*       weight                  [in]: Handle to a previously created convolution weight tensor object.
*   @param
*       fwd_input_grad          [in]: Handle to a previously created convolution input gradient tensor object. Represents
*                                     gradient of loss w.r.t convolution input tensor in fwd propagation.
*   @param
*       pOperation             [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                     convolution backward op.
*   @param
*       tuning_cache            [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                     ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpConvolutionBackwardQCOM)(
    cl_context                             context,
    const cl_ml_op_properties_qcom*        pOp_properties,
    const cl_ml_op_convolution_desc_qcom*  pConvolution_descriptor,
    cl_ml_tensor_qcom                      fwd_output_grad,
    cl_ml_tensor_qcom                      weight,
    cl_ml_tensor_qcom                      fwd_input_grad,
    cl_ml_op_qcom*                         pOperation,
    cl_ml_tuningcache_qcom                 tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpConvolutionParamGradientsQCOM
*   @brief
*       Creates a cl_ml_op_qcom object for a convolution Op parameter gradient. This op computes <weight_grad> and <bias_grad>
*       tensors.
*   @param
*       context                 [in]: Handle to previously created CL context.
*   @param
*       pOp_properties          [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                     If it is NULL, it will be ignored.
*   @param
*       pConvolution_descriptor [in]: Pointer to a user created convolution descriptor object.
*   @param
*       fwd_input               [in]: Handle to a previously created convolution input tensor object in fwd propagation.
*   @param
*       fwd_output_grad         [in]: Handle to a previously created convolution ouptut gradient tensor object. Represents
*                                     gradient of loss w.r.t convolution output tensor in fwd propagation.
*   @param
*       weight_grad            [in]: Handle to a previously weight gradient tensor object and provides weight gradient
*                                     data to update <weight> tensor.
*   @param
*       bias_grad               [in]: Handle to a previously bias gradient tensor object and provides bias gradient
*                                     data to update <bias> tensor.
*   @param
*       weight                  [in]: Handle to a previously created convolution weight tensor object.
*   @param
*       bias                    [in]: Handle to a previously created convolution bias tensor object.
*   @param
*       pOperation             [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                     convolution backward op.
*   @param
*       tuning_cache            [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                     ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int(*pfnClCreateMLOpConvolutionParamGradientsQCOM)(
    cl_context                             context,
    const cl_ml_op_properties_qcom*        pOp_properties,
    const cl_ml_op_convolution_desc_qcom*  pConvolution_descriptor,
    cl_ml_tensor_qcom                      fwd_input,
    cl_ml_tensor_qcom                      fwd_output_grad,
    cl_ml_tensor_qcom                      weight_grad,
    cl_ml_tensor_qcom                      bias_grad,
    cl_ml_tensor_qcom                      weight,
    cl_ml_tensor_qcom                      bias,
    cl_ml_op_qcom*                         pOperation,
    cl_ml_tuningcache_qcom                 tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateOpPoolingBackwardQCOM
*   @brief
*       Creates a cl_ml_op_qcom object for a backward pooling op. This op computes <fwd_input_grad> tensor.
*   @param
*       context                 [in]: Handle to previously created CL context.
*   @param
*       pOp_properties          [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                     If it is NULL, it will be ignored.
*   @param
*       pPooling_descriptor     [in]: Pointer to a user created pooling descriptor object.
*   @param
*       fwd_output_grad         [in]: Handle to a previously created Pooling output gradient tensor object. Represents
*                                     gradient of loss w.r.t pooling output tensor in fwd propagation.
*   @param
*       fwd_mask                [in]: Handle to a previously created pooling mask tensor object in fwd propagation.
*   @param
*       fwd_input_grad          [in]: Handle to a previously created Pooling input gradient tensor object. Represents
*                                     gradient of loss w.r.t Pooling input tensor in forward propagation
*   @param
*       pOperation             [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                     pooling backward op.
*   @param
*       tuning_cache            [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                     ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpPoolingBackwardQCOM)(
    cl_context                         context,
    const cl_ml_op_properties_qcom*    pOp_properties,
    const cl_ml_op_pooling_desc_qcom*  pPooling_descriptor,
    cl_ml_tensor_qcom                  fwd_output_grad,
    cl_ml_tensor_qcom                  fwd_mask,
    cl_ml_tensor_qcom                  fwd_input_grad,
    cl_ml_op_qcom*                     pOperation,
    cl_ml_tuningcache_qcom             tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpBatchNormBackwardQCOM
*   @brief
*       Creates a cl_ml_op_qcom object for a backward Batch-Norm op. This op computes <fwd_input_grad> tensor.
*   @param
*       context                 [in]: Handle to previously created CL context.
*   @param
*       pOp_properties          [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                     If it is NULL, it will be ignored.
*   @param
*       pBatchNorm_descriptor   [in]: Pointer to a user created batchnorm descriptor object.
*   @param
*       batch_size              [in]: Unsigned int variable to pass in batch size during training.
*   @param
*       fwd_input               [in]: Handle to a previously created batchnorm input tensor object in fwd propagation.
*   @param
*       fwd_output_grad         [in]: Handle to a previously created batchnorm output gradient tensor object. Represents
*                                     gradient of loss w.r.t batchnorm output tensor in fwd propagation.
*   @param
*       mean                    [in]: Handle to a previously created batchnorm mean tensor object.
*   @param
*       variance                [in]: Handle to a previously created batchnorm variance tensor object.
*   @param
*       scale                   [in]: Handle to a previously created batchnorm scale tensor object.
*   @param
*       variance_grad           [in]: Handle to a previously created batchnorm variance gradient tensor object.
*   @param
*       mean_grad               [in]: Handle to a previously created bathnorm mean gradient tensor object.
*   @param
*       fwd_input_grad          [in]: Handle to a previously created batchnorm input gradient tensor object. Represents
*                                     gradient of loss w.r.t batchnorm input tensor in fwd propagation.
*   @param
*       pOperation             [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                     batchnorm backward op.
*   @param
*       tuning_cache            [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                     ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpBatchNormBackwardQCOM)(
    cl_context                           context,
    const cl_ml_op_properties_qcom*      pOp_properties,
    const cl_ml_op_batchnorm_desc_qcom*  pBatchNorm_descriptor,
    const cl_uint                        batch_size,
    cl_ml_tensor_qcom                    fwd_input,
    cl_ml_tensor_qcom                    fwd_output_grad,
    cl_ml_tensor_qcom                    mean,
    cl_ml_tensor_qcom                    variance,
    cl_ml_tensor_qcom                    scale,
    cl_ml_tensor_qcom                    variance_grad,
    cl_ml_tensor_qcom                    mean_grad,
    cl_ml_tensor_qcom                    fwd_input_grad,
    cl_ml_op_qcom*                       pOperation,
    cl_ml_tuningcache_qcom               tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpBatchNormParamGradientsQCOM
*   @brief
*       Creates a cl_ml_op_qcom object for a Batch-Norm parameter gradients op. This op computes <scale_grad> and <bias_grad>
*       tensors.
*   @param
*       context                 [in]: Handle to previously created CL context.
*   @param
*       pOp_properties          [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                     If it is NULL, it will be ignored.
*   @param
*       pBatchNorm_descriptor   [in]: Pointer to a user created batchnorm descriptor object.
*   @param
*       fwd_input               [in]: Handle to a previously created batchnorm input tensor object in fwd propagation.
*   @param
*       fwd_output_grad         [in]: Handle to a previously created batchnorm output gradient tensor object. Represents
*                                     gradient of loss w.r.t batchnorm output tensor in forward propagation.
*   @param
*       mean                    [in]: Handle to a previously created batchnorm mean tensor object.
*   @param
*       variance                [in]: Handle to a previously batchnorm variance tensor object.
*   @param
*       scale_grad              [in]: Handle to a previously batchnorm scale gradient tensor object and provides scale gradient
*                                     data to update <scale> tensor.
*   @param
*       bias_grad               [in]: Handle to a previously batchnorm bias gradient tensor object and provides bias gradient
*                                     data to update <bias> tensor.
*   @param
*       scale                   [in]: Handle to a previously created batchnorm scale tensor object.
*   @param
*       bias                    [in]: Handle to a previously created batchnorm bias tensor object.
*   @param
*       pOperation             [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                     batchnorm param gradients op.
*   @param
*       tuning_cache            [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                     ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpBatchNormParamGradientsQCOM)(
    cl_context                           context,
    const cl_ml_op_properties_qcom*      pOp_properties,
    const cl_ml_op_batchnorm_desc_qcom*  pBatchNorm_descriptor,
    cl_ml_tensor_qcom                    fwd_input,
    cl_ml_tensor_qcom                    fwd_output_grad,
    cl_ml_tensor_qcom                    mean,
    cl_ml_tensor_qcom                    variance,
    cl_ml_tensor_qcom                    scale_grad,
    cl_ml_tensor_qcom                    bias_grad,
    cl_ml_tensor_qcom                    scale,
    cl_ml_tensor_qcom                    bias,
    cl_ml_op_qcom*                       pOperation,
    cl_ml_tuningcache_qcom               tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpClipQCOM
*   @brief
*       Create Clip Op for clipping values between given Min and Max values for a given ML tensor. This op computes <output>
*       tensor.
*   @param
*       context                 [in]: Handle to previously created CL context.
*   @param
*       pOp_properties          [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                     If it is NULL, it will be ignored.
*   @param
*       pClip_descriptor        [in]: Pointer to a user created clip descriptor object.
*   @param
*       input                   [in]: Handle to a previously created clip input tensor object.
*   @param
*       output                  [in]: Handle to a previously created clip ouput tensor object.
*   @param
*       pOperation             [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                     clip op.
*   @param
*       tuning_cache            [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                     ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int(*pfnClCreateMLOpClipQCOM)(
    cl_context                                     context,
    const cl_ml_op_properties_qcom*                pOp_properties,
    const cl_ml_op_clip_desc_qcom*                 pClip_descriptor,
    cl_ml_tensor_qcom                              input,
    cl_ml_tensor_qcom                              output,
    cl_ml_op_qcom*                                 pOperation,
    cl_ml_tuningcache_qcom                         tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpSliceQCOM
*   @brief
*       Creates a forward cl_ml_op_qcom object for slicing a given tensor. This op computes <output> tensor.
*   @param
*       context                 [in]: Handle to previously created CL context.
*   @param
*       pOp_properties          [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                     If it is NULL, it will be ignored.
*   @param
*       pSlice_descriptor       [in]: Pointer to a user created slice descriptor object.
*   @param
*       input                   [in]: Handle to a previously created slice input tensor object in fwd propagation.
*   @param
*       output                  [in]: Handle to a previously created slice ouput tensor object in fwd propagation.
*   @param
*       pOperation             [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                     slice op.
*   @param
*       tuning_cache            [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                     ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int(*pfnClCreateMLOpSliceQCOM)(
    cl_context                                     context,
    const cl_ml_op_properties_qcom*                pOp_properties,
    const cl_ml_op_slice_desc_qcom*                pSlice_descriptor,
    cl_ml_tensor_qcom                              input,
    cl_ml_tensor_qcom                              output,
    cl_ml_op_qcom*                                 pOperation,
    cl_ml_tuningcache_qcom                         tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpGatherQCOM
*   @brief
*       Creates a forward cl_ml_op_qcom object for gathering tensor values along the axis specified in gather desc according
*       to indices given in the <index> tensor. This op computes <output> tensor.
*   @param
*       context                 [in]: Handle to previously created CL context.
*   @param
*       pOp_properties          [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                     If it is NULL, it will be ignored.
*   @param
*       pGather_descriptor      [in]: Pointer to a user created gather descriptor object.
*   @param
*       input                   [in]: Handle to a previously created gather input tensor object in fwd propagation.
*   @param
*       index                   [in]: Handle to a previously created gather index tensor object.
*   @param
*       output                  [in]: Handle to a previously created gather ouput tensor object in fwd propagation.
*   @param
*       pOperation             [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                     gather op.
*   @param
*       tuning_cache            [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                     ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int(*pfnClCreateMLOpGatherQCOM)(
    cl_context                                     context,
    const cl_ml_op_properties_qcom*                pOp_properties,
    const cl_ml_op_gather_desc_qcom*               pGather_descriptor,
    cl_ml_tensor_qcom                              input,
    cl_ml_tensor_qcom                              index,
    cl_ml_tensor_qcom                              output,
    cl_ml_op_qcom*                                 pOperation,
    cl_ml_tuningcache_qcom                         tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpBinaryBackwardQCOM
*   @brief
*       Creates an instance of binary backward op. This op computes <fwd_input_A_grad> and <fwd_input_B_grad> tensors.
*   @param
*       context                 [in]: Handle to previously created CL context.
*   @param
*       pOp_properties          [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                     If it is NULL, it will be ignored.
*   @param
*       pBinary_descriptor      [in]: Pointer to a user created binary op descriptor object.
*   @param
*       fwd_input_A             [in]: Handle to a previously created binary op inputA tensor object in fwd propagation.
*   @param
*       fwd_input_B             [in]: Handle to a previously created binary op inputB tensor object in fwd propagation.
*   @param
*       fwd_input_output_C_grad [in]: Handle to a previously created binary op input_output_C gradient tensor object.
*                                     Represents of loss w.r.t binary op input_output_C tensor in fwd propagation.
*   @param
*       fwd_input_A_grad        [in]: Handle to a previously created binary op input_A gradient tensor object. Represents
*                                     gradient of loss w.r.t binary op input_A tensor in fwd propagation.
*   @param
*       fwd_input_B_grad        [in]: Handle to a previously created binary op input_B gradient tensor object. Represents
*                                     gradient of loss w.r.t binary op input_B tensor in fwd propagation.
*   @param
*       pOperation             [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                     binary backward op.
*   @param
*       tuning_cache            [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                     ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int(*pfnClCreateMLOpBinaryBackwardQCOM)(
    cl_context                                     context,
    const cl_ml_op_properties_qcom*                pOp_properties,
    const cl_ml_op_binary_desc_qcom*               pBinary_descriptor,
    cl_ml_tensor_qcom                              fwd_input_A,
    cl_ml_tensor_qcom                              fwd_input_B,
    cl_ml_tensor_qcom                              fwd_input_output_C_grad,
    cl_ml_tensor_qcom                              fwd_input_A_grad,
    cl_ml_tensor_qcom                              fwd_input_B_grad,
    cl_ml_op_qcom*                                 pOperation,
    cl_ml_tuningcache_qcom                         tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpResizeBilinearBackwardQCOM
*   @brief
*       Creates an instance of bilinear resize backward op. This op computes <fwd_input_grad> tensor.
*   @param
*       context                     [in]: Handle to previously created CL context.
*   @param
*       pOp_properties              [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                         If it is NULL, it will be ignored.
*   @param
*       pResize_bilinear_descriptor [in]: Pointer to a user created resize bilinear descriptor object.
*   @param
*       fwd_output_grad             [in]: Handle to a previously created resize bilinear output gradient tensor object and is
*                                         gradient of loss w.r.t resize bilinear output tensor in fwd propagation.
*   @param
*       fwd_input_grad              [in]: Handle to a previously created resize bilinear input gradient tensor object and is
*                                         gradient of loss w.r.t resize bilinear input tensor in fwd propagation.
*   @param
*       pOperation                 [out]: Pointer to ML op handle and returns an abstract reference to the created instance
*                                         of resize bilinear backward op.
*   @param
*       tuning_cache                [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                         ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int(*pfnClCreateMLOpResizeBilinearBackwardQCOM)(
    cl_context                                     context,
    const cl_ml_op_properties_qcom*                pOp_properties,
    const cl_ml_op_resize_bilinear_desc_qcom*      pResize_bilinear_descriptor,
    cl_ml_tensor_qcom                              fwd_output_grad,
    cl_ml_tensor_qcom                              fwd_input_grad,
    cl_ml_op_qcom*                                 pOperation,
    cl_ml_tuningcache_qcom                         tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpSliceBackwardQCOM
*   @brief
*       Creates an instance of slice backward op. This op computes <fwd_input_grad> tensor.
*   @param
*       context                 [in]: Handle to previously created CL context.
*   @param
*       pOp_properties          [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                     If it is NULL, it will be ignored.
*   @param
*       pSlice_descriptor       [in]: Pointer to a user created slice descriptor object.
*   @param
*       fwd_output_grad         [in]: Handle to a previously created Slice output gradient tensor object. Represents
*                                     gradient of loss w.r.t Slice output tensor in fwd propagation.
*   @param
*       fwd_input_grad          [in]: Handle to a previously created Slice input gradient tensor object. Represents
*                                     gradient of loss w.r.t Slice input tensor in fwd propagation.
*   @param
*       pOperation             [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                     slice backward op.
*   @param
*       tuning_cache            [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                     ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int(*pfnClCreateMLOpSliceBackwardQCOM)(
    cl_context                                     context,
    const cl_ml_op_properties_qcom*                pOp_properties,
    const cl_ml_op_slice_desc_qcom*                pSlice_descriptor,
    cl_ml_tensor_qcom                              fwd_output_grad,
    cl_ml_tensor_qcom                              fwd_input_grad,
    cl_ml_op_qcom*                                 pOperation,
    cl_ml_tuningcache_qcom                         tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpGatherBackwardQCOM
*   @brief
*       Creates an instance of gather backward op. This op computes <fwd_input_grad> tensor.
*   @param
*       context                 [in]: Handle to previously created CL context.
*   @param
*       pOp_properties          [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                     If it is NULL, it will be ignored.
*   @param
*       pGather_descriptor      [in]: Pointer to a user created gather descriptor object.
*   @param
*       fwd_output_grad         [in]: Handle to a previously created Gather output gradient tensor object. Represents
*                                     gradient of loss w.r.t Gather output tensor in fwd propagation.
*   @param
*       index                   [in]: Handle to a previously created gather index tensor object.
*   @param
*       fwd_input_grad          [in]: Handle to a previously created gather input gradient tensor object. Represents
*                                     gradient of loss w.r.t Slice input tensor in fwd propagation.
*   @param
*       pOperation             [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                     gather backward op.
*   @param
*       tuning_cache            [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                     ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int(*pfnClCreateMLOpGatherBackwardQCOM)(
    cl_context                                     context,
    const cl_ml_op_properties_qcom*                pOp_properties,
    const cl_ml_op_gather_desc_qcom*               pGather_descriptor,
    cl_ml_tensor_qcom                              fwd_output_grad,
    cl_ml_tensor_qcom                              index,
    cl_ml_tensor_qcom                              fwd_input_grad,
    cl_ml_op_qcom*                                 pOperation,
    cl_ml_tuningcache_qcom                         tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpArgMaxQCOM
*   @brief
*       Creates an instance of ArgMax operation. This op computes <output> tensor.
*   @param
*       context                 [in]: Handle to previously created CL context.
*   @param
*       pOp_properties          [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                     If it is NULL, it will be ignored.
*   @param
*       pArgMax_descriptor      [in]: Pointer to a user created arg max descriptor object.
*   @param
*       input                   [in]: Handle to a previously created arg max input tensor object.
*   @param
*       output                  [in]: Handle to a previously created arg max ouput tensor object.
*   @param
*       pOperation             [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                     arg max op.
*   @param
*       tuning_cache            [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                     ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int(*pfnClCreateMLOpArgMaxQCOM)(
    cl_context                                     context,
    const cl_ml_op_properties_qcom*                pOp_properties,
    const cl_ml_op_arg_max_desc_qcom*              pArgMax_descriptor,
    cl_ml_tensor_qcom                              input,
    cl_ml_tensor_qcom                              output,
    cl_ml_op_qcom*                                 pOperation,
    cl_ml_tuningcache_qcom                         tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpOneHotQCOM
*   @brief
*       Creates an instance of One-Hot encoding operation. This op computes <output> tensor.
*   @param
*       context                 [in]: Handle to previously created CL context.
*   @param
*       pOp_properties          [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                     If it is NULL, it will be ignored.
*   @param
*       pOneHot_descriptor      [in]: Pointer to a user created one-hot descriptor object.
*   @param
*       input                   [in]: Handle to a previously created one-hot input tensor object.
*   @param
*       output                  [in]: Handle to a previously created one-hot ouput tensor object.
*   @param
*       pOperation             [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                     one-hot op.
*   @param
*       tuning_cache            [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                     ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int(*pfnClCreateMLOpOneHotQCOM)(
    cl_context                                     context,
    const cl_ml_op_properties_qcom*                pOp_properties,
    const cl_ml_op_one_hot_desc_qcom*              pOneHot_descriptor,
    cl_ml_tensor_qcom                              input,
    cl_ml_tensor_qcom                              output,
    cl_ml_op_qcom*                                 pOperation,
    cl_ml_tuningcache_qcom                         tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpSpaceToDepthQCOM
*   @brief
*       Creates an instance of space to depth operation. This op computes <output> tensor.
*   @param
*       context                  [in]: Handle to previously created CL context.
*   @param
*       pOp_properties           [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                      If it is NULL, it will be ignored.
*   @param
*       pSpaceToDepth_descriptor [in]: Pointer to a user created space to depth descriptor object.
*   @param
*       input                    [in]: Handle to a previously created space to depth input tensor object.
*   @param
*       output                   [in]: Handle to a previously created space to depth ouput tensor object.
*   @param
*       pOperation              [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                      space to depth op.
*   @param
*       tuning_cache             [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                      ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int(*pfnClCreateMLOpSpaceToDepthQCOM)(
    cl_context                             context,
    const cl_ml_op_properties_qcom*        pOp_properties,
    const cl_ml_op_spacetodepth_desc_qcom* pSpaceToDepth_descriptor,
    cl_ml_tensor_qcom                      input,
    cl_ml_tensor_qcom                      output,
    cl_ml_op_qcom*                         pOperation,
    cl_ml_tuningcache_qcom                 tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpUnaryQCOM
*   @brief
*       Creates an instance of unary op to do different operations on <input> tensor. This op computes <output> tensor.
*   @param
*       context                 [in]: Handle to previously created CL context.
*   @param
*       pOp_properties          [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                     If it is NULL, it will be ignored.
*   @param
*       pUnary_descriptor       [in]: Pointer to a user created Unary Op descriptor object.
*   @param
*       input                   [in]: Handle to a previously created Unary Op input tensor object.
*   @param
*       output                  [in]: Handle to a previously created Unary OP ouput tensor object.
*   @param
*       pOperation             [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                     Unary op.
*   @param
*       tuning_cache            [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                     ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int(*pfnClCreateMLOpUnaryQCOM)(
    cl_context                        context,
    const cl_ml_op_properties_qcom*   pOp_properties,
    const cl_ml_op_unary_desc_qcom*   pUnary_descriptor,
    cl_ml_tensor_qcom                 input,
    cl_ml_tensor_qcom                 output,
    cl_ml_op_qcom*                    pOperation,
    cl_ml_tuningcache_qcom            tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpSoftmaxBackwardQCOM
*   @brief
*       Creates an instance of softmax backward op. This op computes <fwd_input_grad> tensor.
*   @param
*       context                 [in]: Handle to previously created CL context.
*   @param
*       pOp_properties          [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                     If it is NULL, it will be ignored.
*   @param
*       pSoftmax_descriptor     [in]: Pointer to a user created Softmax descriptor object.
*   @param
*       fwd_output_grad         [in]: Handle to a previously created Softmax output gradient tensor object. Represents
*                                     gradient of loss w.r.t Softmax output tensor in fwd propagation.
*   @param
*       fwd_input_grad          [in]: Handle to a previously created Softmax input gradient tensor object. Represents
*                                     gradient of loss w.r.t Softmax input tensor in fwd propagation.
*   @param
*       fwd_output              [in]: Handle to a previously created softmax output tensor object in fwd propagation.
*   @param
*       pOperation             [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                     Softmax backward op.
*   @param
*       tuning_cache            [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                     ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int(*pfnClCreateMLOpSoftmaxBackwardQCOM)(
    cl_context                        context,
    const cl_ml_op_properties_qcom*   pOp_properties,
    const cl_ml_op_softmax_desc_qcom* pSoftmax_descriptor,
    cl_ml_tensor_qcom                 fwd_output_grad,
    cl_ml_tensor_qcom                 fwd_input_grad,
    cl_ml_tensor_qcom                 fwd_output,
    cl_ml_op_qcom*                    pOperation,
    cl_ml_tuningcache_qcom            tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpUpdateParameterSGDQCOM
*   @brief
*       Creates an instance of Update Parameter SGD op. This op can be used to update trainable parameters in a neural
*       network using chosen <cl_parameter_update_sgd_function_qcom>. This op updates <param> tensor and optionally
*       accumulates past gradient into <acc_param_grad>.
*   @param
*       context                   [in]: Handle to previously created CL context.
*   @param
*       pOp_properties            [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                       If it is NULL, it will be ignored.
*   @param
*       pUpdate_param_descriptor  [in]: Pointer to a user created Update Parameter descriptor object.
*   @param
*       param                     [in]: Handle to a previously created parameter tensor object.
*   @param
*       param_grad                [in]: Handle to a previously created parameter gradient tensor object.
*   @param
*       acc_param_grad            [in]: Handle to a previously created accumulator parameter gradient tensor object.
*   @param
*       pOperation               [out]: Pointer to ML op handle and returns an abstract reference to the created instance
*                                       of Update Parameter op.
*   @param
*       tuning_cache              [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                       ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int(*pfnClCreateMLOpUpdateParameterSGDQCOM)(
    cl_context                                      context,
    const cl_ml_op_properties_qcom*                 pOp_properties,
    const cl_ml_op_update_parameter_sgd_desc_qcom*  pUpdate_param_sgd_descriptor,
    cl_ml_tensor_qcom                               param,
    cl_ml_tensor_qcom                               param_grad,
    cl_ml_tensor_qcom                               acc_param_grad,
    cl_ml_op_qcom*                                  pOperation,
    cl_ml_tuningcache_qcom                          tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpUpdateParameterADAMQCOM
*   @brief
*       Creates an instance of Update Parameter ADAM op. This op can be used to update trainable parameters in a neural
*       network using chosen <cl_parameter_update_adam_function_qcom>. This op updates <param> tensor and accumulates past
*       first and second gradients into <param_momentum_1> and <param_momentum_2> respectively.
*   @param
*       context                   [in]: Handle to previously created CL context.
*   @param
*       pOp_properties            [in]: Pointer to a user created zero terminated list of ML op  property key value pairs.
*                                       If it is NULL, it will be ignored.
*   @param
*       pUpdate_param_descriptor  [in]: Pointer to a user created Update Parameter descriptor object.
*   @param
*       curr_time_step            [in]: Handle to a previously created current time step tensor object.
*   @param
*       param                     [in]: Handle to a previously created parameter tensor object.
*   @param
*       param_grad                [in]: Handle to a previously created parameter gradient tensor object.
*   @param
*       param_momentum_1          [in]: Handle to a previously created past first gradient tensor object.
*   @param
*       param_momentum_2          [in]: Handle to a previously created past second gradient tensor object.
*   @param
*       pOperation               [out]: Pointer to ML op handle and returns an abstract reference to the created instance
*                                       of Update Parameter op.
*   @param
*       tuning_cache              [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                       ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int(*pfnClCreateMLOpUpdateParameterADAMQCOM)(
    cl_context                                       context,
    const cl_ml_op_properties_qcom*                  pOp_properties,
    const cl_ml_op_update_parameter_adam_desc_qcom*  pUpdate_param_adam_descriptor,
    cl_ml_tensor_qcom                                curr_time_step,
    cl_ml_tensor_qcom                                param,
    cl_ml_tensor_qcom                                param_grad,
    cl_ml_tensor_qcom                                param_momentum_1,
    cl_ml_tensor_qcom                                param_momentum_2,
    cl_ml_op_qcom*                                   pOperation,
    cl_ml_tuningcache_qcom                           tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpPadBackwardQCOM
*
*   @brief
*       Creates an instance of backward pad operation operation. This op computes <fwd_input_grad> tensor.
*   @param
*       context         [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties  [in]: Pointer to a user created zero terminated list of ML op property key value pairs. If it is NULL,
*                             it will be ignored.
*   @param
*       pPad_descriptor [in]: Pointer to a user created pad descriptor object.
*   @param
*       fwd_output_grad [in]: Handle to a previously created Pad output gradient tensor object. Represents
*                             gradient of loss w.r.t Pad output tensor in fwd propagation.
*   @param
*       fwd_input_grad  [in]: Handle to a previously created Pad input gradient tensor object. Represents
*                             gradient of loss w.r.t Pad input tensor in fwd propagation.
*   @param
*       p_operation    [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                             pad operation.
*   @param
*       tuning_cache    [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int(*pfnClCreateMLOpPadBackwardQCOM)(
    cl_context                          context,
    const cl_ml_op_properties_qcom*     pOp_properties,
    const cl_ml_op_pad_desc_qcom*       pPad_descriptor,
    cl_ml_tensor_qcom                   fwd_output_grad,
    cl_ml_tensor_qcom                   fwd_input_grad,
    cl_ml_op_qcom*                      pOperation,
    cl_ml_tuningcache_qcom              tuning_cache);

/*******************************************************************************************************************************
*   pfnClGetMLOpDeviceMemoryRequirementsQCOM
*
*   @brief
*       Gets the amount of device memory used by an ML op internally in bytes.
*   @param
*       context         [in]: Handle to previously created OpenCL context.
*   @param
*       operation       [in]: Handle to a previously created ML op object.
*   @param
*       pSize          [out]: Pointer to an unsigned integer and returns the number of bytes used by the given operation
*                             on device.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClGetMLOpDeviceMemoryRequirementsQCOM)(
    cl_context     context,
    cl_ml_op_qcom  operation,
    cl_uint*       pSize);

/*******************************************************************************************************************************
*   pfnClUpdateMLOpDeviceMemoryQCOM
*
*   @brief
*       Updates ML op's internal device memory to use cl memory provided by a user instead.
*   @note
*       Initial device memory that was allocated during ML op creation will be automatically freed.
*   @param
*       context         [in]: Handle to previously created OpenCL context.
*   @param
*       operation       [in]: Handle to a previously created ML op object.
*   @param
*       memory          [in]: Handle to a previously created cl memory object for the device memory.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClUpdateMLOpDeviceMemoryQCOM)(
    cl_context    context,
    cl_ml_op_qcom operation,
    cl_mem        memory);

/*******************************************************************************************************************************
*   pfnClCreateMLOpLocalResponseNormQCOM
*
*   @brief
*       Creates an instance of Local Response Normalization (LRN) operation. This op computes <output> tensor.
*   @param
*       context         [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties  [in]: Pointer to a user created zero terminated list of ML op property key value pairs. If it is NULL,
*                             it will be ignored.
*   @param
*       pLRN_descriptor [in]: Pointer to a user created local response norm descriptor object.
*   @param
*       input           [in]: Handle to an input tensor object.
*   @param
*       output          [in]: Handle to an output tensor object.
*   @param
*       pOperation     [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                             local response norm operation.
*   @param
*       tuning_cache    [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpLocalResponseNormQCOM)(
    cl_context                                    context,
    const cl_ml_op_properties_qcom*               pOp_properties,
    const cl_ml_op_local_response_norm_desc_qcom* pLRN_descriptor,
    cl_ml_tensor_qcom                             input,
    cl_ml_tensor_qcom                             output,
    cl_ml_op_qcom*                                pOperation,
    cl_ml_tuningcache_qcom                        tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpLocalResponseNormBackwardQCOM
*
*   @brief
*       Creates an instance of Local Response Normalization (LRN) Backward operation. This op computes <fwd_input_grad>
*   @param
*       context          [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties   [in]: Pointer to a user created zero terminated list of ML op property key value pairs. If it is NULL,
*                              it will be ignored.
*   @param
*       pLRN_descriptor  [in]: Pointer to a user created local response norm descriptor object.
*   @param
*       fwd_input        [in]: Handle to a previously created LRN input tensor object in fwd propagation.
*   @param
*       fwd_output       [in]: Handle to a previously created LRN output tensor object in fwd propagation.
*   @param
*       fwd_input_grad   [in]: Handle to a previously created LRN input gradient tensor object. Represents
*                              gradient of loss w.r.t LRN input tensor in fwd propagation.
*   @param
*       fwd_output_grad  [in]: Handle to a previously created LRN output gradient tensor object. Represents
*                              gradient of loss w.r.t LRN output tensor in fwd propagation.
*   @param
*       pOperation      [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                              local response norm backward operation.
*   @param
*       tuning_cache     [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpLocalResponseNormBackwardQCOM)(
    cl_context                                    context,
    const cl_ml_op_properties_qcom*               pOp_properties,
    const cl_ml_op_local_response_norm_desc_qcom* pLRN_descriptor,
    cl_ml_tensor_qcom                             fwd_input,
    cl_ml_tensor_qcom                             fwd_output,
    cl_ml_tensor_qcom                             fwd_input_grad,
    cl_ml_tensor_qcom                             fwd_output_grad,
    cl_ml_op_qcom*                                pOperation,
    cl_ml_tuningcache_qcom                        tuning_cache);


/*******************************************************************************************************************************
*   pfnClCreateMLOpFusedBinaryActivationQCOM
*
*   @brief
*       Creates an instance of fused binary activation op. This op computes <input_output_C> tensor.
*   @note
*       Mathematically, CLML fused binary activation operation is input_output_C = activation_function((alpha * input_A)
*       <operation> (beta * input_B) + gamma * input_output_C).
*   @param
*       context                [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties         [in]: Pointer to a user created zero terminated list of ML op property key value pairs.
*                                    If it is NULL, it will be ignored.
*   @param
*       pBinary_descriptor     [in]: Pointer to a user created binary descriptor object.
*   @param
*       pActivation_descriptor [in]: Pointer to a user created activation descriptor object.
*   @param
*       input_A                [in]: Handle to a previously created binary input_A tensor object in fwd propagation.
*   @param
*       input_B                [in]: Handle to a previously created binary input_B tensor object in fwd propagation.
*   @param
*       param                  [in]: Handle to a previously created activation parameter tensor object.
*   @param
*       input_output_C         [in]: Handle to a previously created binary input_output_C tensor object in fwd propagation.
*   @param
*       pOperation            [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                    fused binary and activation op.
*   @param
*       tuning_cache           [in]: Handle to a previously created ML tuning cache object. If it is NULL, it  will be
*                                    ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpFusedBinaryActivationQCOM)(
    cl_context                            context,
    const cl_ml_op_properties_qcom*       pOp_properties,
    const cl_ml_op_binary_desc_qcom*      pBinary_descriptor,
    const cl_ml_op_activation_desc_qcom*  pActivation_descriptor,
    cl_ml_tensor_qcom                     input_A,
    cl_ml_tensor_qcom                     input_B,
    cl_ml_tensor_qcom                     param,
    cl_ml_tensor_qcom                     input_output_C,
    cl_ml_op_qcom*                        pOperation,
    cl_ml_tuningcache_qcom                tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpFusedFullyConnectedActivationQCOM
*
*   @brief
*       Creates an instance of forward fused fully-connected activation op. This op computes <output> tensor.
*   @note
*       Mathematically, CLML fully connected op is output = activation_function(input x weight + bias).
*   @param
*       context                      [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties               [in]: Pointer to a user created zero terminated list of ML op property key value pairs.
*                                          If it is NULL, it will be ignored.
*   @param
*       pFullyConnected_descriptor   [in]: Pointer to a user created fully-connected op descriptor object.
*   @param
*       pActivation_descriptor       [in]: Pointer to a user created activation descriptor object.
*   @param
*       input                        [in]: Handle to a previously created fully-connected input tensor object in
*                                          fwd propagation.
*   @param
*       weight                       [in]: Handle to a previously created fully-connected weight tensor object.
*   @param
*       bias                         [in]: Handle to a previously created fully-connected bias tensor object.
*   @param
*       param                        [in]: Handle to a previously created activation parameter tensor object.
*   @param
*       output                       [in]: Handle to a previously created fully-connected output tensor object in fwd
*                                          propagation.
*   @param
*       pOperation                  [out]: Pointer to ML op handle and returns an abstract reference to the created instance
*                                          of fused fully-connected and activation op.
*   @param
*       tuning_cache                 [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be
*                                          ignored.
* @return
*       CL_SUCCESS if the function executed successfully.
******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpFusedFullyConnectedActivationQCOM)(
    cl_context                                 context,
    const cl_ml_op_properties_qcom*            pOp_properties,
    const cl_ml_op_fully_connected_desc_qcom*  pFullyConnected_descriptor,
    const cl_ml_op_activation_desc_qcom*       pActivation_descriptor,
    cl_ml_tensor_qcom                          input,
    cl_ml_tensor_qcom                          weight,
    cl_ml_tensor_qcom                          bias,
    cl_ml_tensor_qcom                          param,
    cl_ml_tensor_qcom                          output,
    cl_ml_op_qcom*                             pOperation,
    cl_ml_tuningcache_qcom                     tuning_cache);

/*******************************************************************************************************************************
*   pfnClCreateMLOpFusedGemmActivationQCOM
*   @brief
*       Creates an instance of Fused GEMM Activation op. This op computes <input_output_C> tensor.
*   @note
*        Mathematically, CLML fused Gemm activation op is input_output_C = activation_function(Alpha * input_A * input_B +
*        beta * input_output_C).
*   @param
*       context                [in]: Handle to previously created OpenCL context.
*   @param
*       pOp_properties         [in]: Pointer to a user created zero terminated list of ML op property key value pairs. If it
*                                    is NULL, it will be ignored.
*   @param
*       pGemm_descriptor       [in]: Pointer to a user created GEMM op descriptor object.
*   @param
*       pActivation_descriptor [in]: Pointer to a user created activation descriptor object.
*   @param
*       input_A                [in]: Handle to a previously created GEMM op input_A tensor object.
*   @param
*       input_B                [in]: Handle to a previously created GEMM op input_B tensor object.
*   @param
*       param                  [in]: Handle to a previously created activation parameter tensor object.
*   @param
*       input_output_C         [in]: Handle to a previously created GEMM op input_output_C tensor object.
*   @param
*       pOperation            [out]: Pointer to ML op handle and returns an abstract reference to the created instance of
*                                    fused GEMM and activation op.
*   @param
*       tuning_cache           [in]: Handle to a previously created ML tuning cache object. If it is NULL, it will be ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
typedef cl_int (*pfnClCreateMLOpFusedGemmActivationQCOM)(
    cl_context                           context,
    const cl_ml_op_properties_qcom*      pOp_properties,
    const cl_ml_op_gemm_desc_qcom*       pGemm_descriptor,
    const cl_ml_op_activation_desc_qcom* pActivation_descriptor,
    cl_ml_tensor_qcom                    input_A,
    cl_ml_tensor_qcom                    input_B,
    cl_ml_tensor_qcom                    param,
    cl_ml_tensor_qcom                    input_output_C,
    cl_ml_op_qcom*                       pOperation,
    cl_ml_tuningcache_qcom               tuning_cache);

/**
* CL ML extension interface data strutures for accessing APIs.
*/
typedef struct _CLMLInterfaceV1QCOM
{
    cl_int                                                         majorVersion;
    cl_int                                                         minorVersion;
    pfnClCreateMLOpGemmQCOM                                        clCreateMLOpGemmQCOM;
    pfnClCreateMLOpTransposeQCOM                                   clCreateMLOpTransposeQCOM;
    pfnClCreateMLOpFullyConnectedQCOM                              clCreateMLOpFullyConnectedQCOM;
    pfnClCreateMLOpConvolutionForwardQCOM                          clCreateMLOpConvolutionForwardQCOM;
    pfnClCreateMLOpBatchNormForwardQCOM                            clCreateMLOpBatchNormForwardQCOM;
    pfnClCreateMLOpActivationForwardQCOM                           clCreateMLOpActivationForwardQCOM;
    pfnClCreateMLOpPoolingForwardQCOM                              clCreateMLOpPoolingForwardQCOM;
    pfnClCreateMLOpFusedConvolutionActivationForwardQCOM           clCreateMLOpFusedConvolutionActivationForwardQCOM;
    pfnClCreateMLOpFusedConvolutionBatchNormForwardQCOM            clCreateMLOpFusedConvolutionBatchNormForwardQCOM;
    pfnClCreateMLOpFusedConvolutionBatchNormActivationForwardQCOM  clCreateMLOpFusedConvolutionBatchNormActivationForwardQCOM;
    pfnClCreateMLOpBinaryQCOM                                      clCreateMLOpBinaryQCOM;
    pfnClCreateMLOpSoftmaxQCOM                                     clCreateMLOpSoftmaxQCOM;
    pfnClCreateMLOpFillQCOM                                        clCreateMLOpFillQCOM;
    pfnClCreateMLOpConcatQCOM                                      clCreateMLOpConcatQCOM;
    pfnClCreateMLOpPermuteQCOM                                     clCreateMLOpPermuteQCOM;
    pfnClCreateMLOpReshapeQCOM                                     clCreateMLOpReshapeQCOM;
    pfnClCreateMLOpDepthToSpaceQCOM                                clCreateMLOpDepthToSpaceQCOM;
    pfnClCreateMLOpFusedDepthToSpaceActivationQCOM                 clCreateMLOpFusedDepthToSpaceActivationQCOM;
    pfnClCreateMLOpResizeBilinearQCOM                              clCreateMLOpResizeBilinearQCOM;
    pfnClCreateMLOpPadQCOM                                         clCreateMLOpPadQCOM;
    pfnClCreateMLTensorQCOM                                        clCreateMLTensorQCOM;
    pfnClGetMLTensorMemorySizeQCOM                                 clGetMLTensorMemorySizeQCOM;
    pfnClReleaseMLOpQCOM                                           clReleaseMLOpQCOM;
    pfnClReleaseMLTensorQCOM                                       clReleaseMLTensorQCOM;
    pfnClEnqueueMLOpQCOM                                           clEnqueueMLOpQCOM;
    pfnClEnqueueMLOpImmutableQCOM                                  clEnqueueMLOpImmutableQCOM;
    pfnClEnqueueRecordingMLOpQCOM                                  clEnqueueRecordingMLOpQCOM;
    pfnClEnqueueReadMLTensorDataQCOM                               clEnqueueReadMLTensorDataQCOM;
    pfnClEnqueueWriteMLTensorDataQCOM                              clEnqueueWriteMLTensorDataQCOM;
    pfnClEnqueueCopyMLTensorDataQCOM                               clEnqueueCopyMLTensorDataQCOM;
    pfnClCreateMLTuningCacheQCOM                                   clCreateMLTuningCacheQCOM;
    pfnClTuneMLOpQCOM                                              clTuneMLOpQCOM;
    pfnClSaveMLTuningCacheQCOM                                     clSaveMLTuningCacheQCOM;
    pfnClLoadMLTuningCacheQCOM                                     clLoadMLTuningCacheQCOM;
    pfnClReleaseMLTuningCacheQCOM                                  clReleaseMLTuningCacheQCOM;
    pfnClCreateMLTensorMemoryDescriptorSetQCOM                     clCreateMLTensorMemoryDescriptorSetQCOM;
    pfnClReleaseMLTensorMemoryDescriptorSetQCOM                    clReleaseMLTensorMemoryDescriptorSetQCOM;
    pfnClUpdateMLTensorMemoryDescriptorSetQCOM                     clUpdateMLTensorMemoryDescriptorSetQCOM;
} CLMLInterfaceV1QCOM;

typedef struct _CLMLInterfaceV2QCOM
{
    cl_int                                                         majorVersion;
    cl_int                                                         minorVersion;
    pfnClCreateMLOpGemmQCOM                                        clCreateMLOpGemmQCOM;
    pfnClCreateMLOpTransposeQCOM                                   clCreateMLOpTransposeQCOM;
    pfnClCreateMLOpFullyConnectedQCOM                              clCreateMLOpFullyConnectedQCOM;
    pfnClCreateMLOpConvolutionForwardQCOM                          clCreateMLOpConvolutionForwardQCOM;
    pfnClCreateMLOpConvolutionBackwardQCOM                         clCreateMLOpConvolutionBackwardQCOM;
    pfnClCreateMLOpConvolutionParamGradientsQCOM                   clCreateMLOpConvolutionParamGradientsQCOM;
    pfnClCreateMLOpBatchNormForwardQCOM                            clCreateMLOpBatchNormForwardQCOM;
    pfnClCreateMLOpBatchNormBackwardQCOM                           clCreateMLOpBatchNormBackwardQCOM;
    pfnClCreateMLOpBatchNormParamGradientsQCOM                     clCreateMLOpBatchNormParamGradientsQCOM;
    pfnClCreateMLOpActivationForwardQCOM                           clCreateMLOpActivationForwardQCOM;
    pfnClCreateMLOpActivationBackwardQCOM                          clCreateMLOpActivationBackwardQCOM;
    pfnClCreateMLOpActivationParamGradientQCOM                     clCreateMLOpActivationParamGradientQCOM;
    pfnClCreateMLOpPoolingForwardQCOM                              clCreateMLOpPoolingForwardQCOM;
    pfnClCreateMLOpPoolingBackwardQCOM                             clCreateMLOpPoolingBackwardQCOM;
    pfnClCreateMLOpFusedConvolutionActivationForwardQCOM           clCreateMLOpFusedConvolutionActivationForwardQCOM;
    pfnClCreateMLOpFusedConvolutionBatchNormForwardQCOM            clCreateMLOpFusedConvolutionBatchNormForwardQCOM;
    pfnClCreateMLOpFusedConvolutionBatchNormActivationForwardQCOM  clCreateMLOpFusedConvolutionBatchNormActivationForwardQCOM;
    pfnClCreateMLOpBinaryQCOM                                      clCreateMLOpBinaryQCOM;
    pfnClCreateMLOpSoftmaxQCOM                                     clCreateMLOpSoftmaxQCOM;
    pfnClCreateMLOpLossForwardQCOM                                 clCreateMLOpLossForwardQCOM;
    pfnClCreateMLOpLossBackwardQCOM                                clCreateMLOpLossBackwardQCOM;
    pfnClCreateMLOpFillQCOM                                        clCreateMLOpFillQCOM;
    pfnClCreateMLOpConcatQCOM                                      clCreateMLOpConcatQCOM;
    pfnClCreateMLOpPermuteQCOM                                     clCreateMLOpPermuteQCOM;
    pfnClCreateMLOpReshapeQCOM                                     clCreateMLOpReshapeQCOM;
    pfnClCreateMLOpDepthToSpaceQCOM                                clCreateMLOpDepthToSpaceQCOM;
    pfnClCreateMLOpFusedDepthToSpaceActivationQCOM                 clCreateMLOpFusedDepthToSpaceActivationQCOM;
    pfnClCreateMLOpResizeBilinearQCOM                              clCreateMLOpResizeBilinearQCOM;
    pfnClCreateMLOpPadQCOM                                         clCreateMLOpPadQCOM;
    pfnClCreateMLTensorQCOM                                        clCreateMLTensorQCOM;
    pfnClGetMLTensorMemorySizeQCOM                                 clGetMLTensorMemorySizeQCOM;
    pfnClReleaseMLOpQCOM                                           clReleaseMLOpQCOM;
    pfnClReleaseMLTensorQCOM                                       clReleaseMLTensorQCOM;
    pfnClEnqueueMLOpQCOM                                           clEnqueueMLOpQCOM;
    pfnClEnqueueMLOpImmutableQCOM                                  clEnqueueMLOpImmutableQCOM;
    pfnClEnqueueRecordingMLOpQCOM                                  clEnqueueRecordingMLOpQCOM;
    pfnClEnqueueReadMLTensorDataQCOM                               clEnqueueReadMLTensorDataQCOM;
    pfnClEnqueueWriteMLTensorDataQCOM                              clEnqueueWriteMLTensorDataQCOM;
    pfnClEnqueueCopyMLTensorDataQCOM                               clEnqueueCopyMLTensorDataQCOM;
    pfnClCreateMLTuningCacheQCOM                                   clCreateMLTuningCacheQCOM;
    pfnClTuneMLOpQCOM                                              clTuneMLOpQCOM;
    pfnClSaveMLTuningCacheQCOM                                     clSaveMLTuningCacheQCOM;
    pfnClLoadMLTuningCacheQCOM                                     clLoadMLTuningCacheQCOM;
    pfnClReleaseMLTuningCacheQCOM                                  clReleaseMLTuningCacheQCOM;
    pfnClCreateMLTensorMemoryDescriptorSetQCOM                     clCreateMLTensorMemoryDescriptorSetQCOM;
    pfnClReleaseMLTensorMemoryDescriptorSetQCOM                    clReleaseMLTensorMemoryDescriptorSetQCOM;
    pfnClUpdateMLTensorMemoryDescriptorSetQCOM                     clUpdateMLTensorMemoryDescriptorSetQCOM;
    pfnClCreateMLOpClipQCOM                                        clCreateMLOpClipQCOM;
    pfnClCreateMLOpSliceQCOM                                       clCreateMLOpSliceQCOM;
    pfnClCreateMLOpGatherQCOM                                      clCreateMLOpGatherQCOM;
    pfnClCreateMLOpBinaryBackwardQCOM                              clCreateMLOpBinaryBackwardQCOM;
    pfnClCreateMLOpResizeBilinearBackwardQCOM                      clCreateMLOpResizeBilinearBackwardQCOM;
    pfnClCreateMLOpSliceBackwardQCOM                               clCreateMLOpSliceBackwardQCOM;
    pfnClCreateMLOpGatherBackwardQCOM                              clCreateMLOpGatherBackwardQCOM;
    pfnClCreateMLOpArgMaxQCOM                                      clCreateMLOpArgMaxQCOM;
    pfnClCreateMLOpOneHotQCOM                                      clCreateMLOpOneHotQCOM;
    pfnClCreateMLOpSpaceToDepthQCOM                                clCreateMLOpSpaceToDepthQCOM;
    pfnClCreateMLOpUnaryQCOM                                       clCreateMLOpUnaryQCOM;
    pfnClCreateMLOpSoftmaxBackwardQCOM                             clCreateMLOpSoftmaxBackwardQCOM;
    pfnCreateKernelArgMLTensorQCOM                                 clCreateKernelArgMLTensorQCOM;
} CLMLInterfaceV2QCOM;

typedef struct _CLMLInterfaceV3QCOM
{
    cl_int                                                         majorVersion;
    cl_int                                                         minorVersion;
    pfnClCreateMLOpGemmQCOM                                        clCreateMLOpGemmQCOM;
    pfnClCreateMLOpTransposeQCOM                                   clCreateMLOpTransposeQCOM;
    pfnClCreateMLOpFullyConnectedQCOM                              clCreateMLOpFullyConnectedQCOM;
    pfnClCreateMLOpConvolutionForwardQCOM                          clCreateMLOpConvolutionForwardQCOM;
    pfnClCreateMLOpConvolutionBackwardQCOM                         clCreateMLOpConvolutionBackwardQCOM;
    pfnClCreateMLOpConvolutionParamGradientsQCOM                   clCreateMLOpConvolutionParamGradientsQCOM;
    pfnClCreateMLOpBatchNormForwardQCOM                            clCreateMLOpBatchNormForwardQCOM;
    pfnClCreateMLOpBatchNormAccumulateStatisticsQCOM               clCreateMLOpBatchNormAccumulateStatisticsQCOM;
    pfnClCreateMLOpBatchNormFinalizeStatisticsQCOM                 clCreateMLOpBatchNormFinalizeStatisticsQCOM;
    pfnClCreateMLOpBatchNormVarianceGradientQCOM                   clCreateMLOpBatchNormVarianceGradientQCOM;
    pfnClCreateMLOpBatchNormMeanGradientQCOM                       clCreateMLOpBatchNormMeanGradientQCOM;
    pfnClCreateMLOpBatchNormBackwardQCOM                           clCreateMLOpBatchNormBackwardQCOM;
    pfnClCreateMLOpBatchNormParamGradientsQCOM                     clCreateMLOpBatchNormParamGradientsQCOM;
    pfnClCreateMLOpActivationForwardQCOM                           clCreateMLOpActivationForwardQCOM;
    pfnClCreateMLOpActivationBackwardQCOM                          clCreateMLOpActivationBackwardQCOM;
    pfnClCreateMLOpActivationParamGradientQCOM                     clCreateMLOpActivationParamGradientQCOM;
    pfnClCreateMLOpPoolingForwardQCOM                              clCreateMLOpPoolingForwardQCOM;
    pfnClCreateMLOpPoolingBackwardQCOM                             clCreateMLOpPoolingBackwardQCOM;
    pfnClCreateMLOpFusedConvolutionActivationForwardQCOM           clCreateMLOpFusedConvolutionActivationForwardQCOM;
    pfnClCreateMLOpFusedConvolutionBatchNormForwardQCOM            clCreateMLOpFusedConvolutionBatchNormForwardQCOM;
    pfnClCreateMLOpFusedConvolutionBatchNormActivationForwardQCOM  clCreateMLOpFusedConvolutionBatchNormActivationForwardQCOM;
    pfnClCreateMLOpBinaryQCOM                                      clCreateMLOpBinaryQCOM;
    pfnClCreateMLOpSoftmaxQCOM                                     clCreateMLOpSoftmaxQCOM;
    pfnClCreateMLOpLossForwardQCOM                                 clCreateMLOpLossForwardQCOM;
    pfnClCreateMLOpLossBackwardQCOM                                clCreateMLOpLossBackwardQCOM;
    pfnClCreateMLOpFillQCOM                                        clCreateMLOpFillQCOM;
    pfnClCreateMLOpConcatQCOM                                      clCreateMLOpConcatQCOM;
    pfnClCreateMLOpPermuteQCOM                                     clCreateMLOpPermuteQCOM;
    pfnClCreateMLOpReshapeQCOM                                     clCreateMLOpReshapeQCOM;
    pfnClCreateMLOpDepthToSpaceQCOM                                clCreateMLOpDepthToSpaceQCOM;
    pfnClCreateMLOpFusedDepthToSpaceActivationQCOM                 clCreateMLOpFusedDepthToSpaceActivationQCOM;
    pfnClCreateMLOpResizeBilinearQCOM                              clCreateMLOpResizeBilinearQCOM;
    pfnClCreateMLOpPadQCOM                                         clCreateMLOpPadQCOM;
    pfnClCreateMLOpPadBackwardQCOM                                 clCreateMLOpPadBackwardQCOM;
    pfnClCreateMLOpCopyQCOM                                        clCreateMLOpCopyQCOM;
    pfnClCreateMLTensorQCOM                                        clCreateMLTensorQCOM;
    pfnClGetMLTensorMemorySizeQCOM                                 clGetMLTensorMemorySizeQCOM;
    pfnClReleaseMLOpQCOM                                           clReleaseMLOpQCOM;
    pfnClReleaseMLTensorQCOM                                       clReleaseMLTensorQCOM;
    pfnClEnqueueMLOpQCOM                                           clEnqueueMLOpQCOM;
    pfnClEnqueueMLOpImmutableQCOM                                  clEnqueueMLOpImmutableQCOM;
    pfnClEnqueueRecordingMLOpQCOM                                  clEnqueueRecordingMLOpQCOM;
    pfnClEnqueueReadMLTensorDataQCOM                               clEnqueueReadMLTensorDataQCOM;
    pfnClEnqueueWriteMLTensorDataQCOM                              clEnqueueWriteMLTensorDataQCOM;
    pfnClEnqueueCopyMLTensorDataQCOM                               clEnqueueCopyMLTensorDataQCOM;
    pfnClCreateMLTuningCacheQCOM                                   clCreateMLTuningCacheQCOM;
    pfnClTuneMLOpQCOM                                              clTuneMLOpQCOM;
    pfnClSaveMLTuningCacheQCOM                                     clSaveMLTuningCacheQCOM;
    pfnClLoadMLTuningCacheQCOM                                     clLoadMLTuningCacheQCOM;
    pfnClReleaseMLTuningCacheQCOM                                  clReleaseMLTuningCacheQCOM;
    pfnClCreateMLTensorMemoryDescriptorSetQCOM                     clCreateMLTensorMemoryDescriptorSetQCOM;
    pfnClReleaseMLTensorMemoryDescriptorSetQCOM                    clReleaseMLTensorMemoryDescriptorSetQCOM;
    pfnClUpdateMLTensorMemoryDescriptorSetQCOM                     clUpdateMLTensorMemoryDescriptorSetQCOM;
    pfnClCreateMLOpClipQCOM                                        clCreateMLOpClipQCOM;
    pfnClCreateMLOpSliceQCOM                                       clCreateMLOpSliceQCOM;
    pfnClCreateMLOpGatherQCOM                                      clCreateMLOpGatherQCOM;
    pfnClCreateMLOpBinaryBackwardQCOM                              clCreateMLOpBinaryBackwardQCOM;
    pfnClCreateMLOpResizeBilinearBackwardQCOM                      clCreateMLOpResizeBilinearBackwardQCOM;
    pfnClCreateMLOpSliceBackwardQCOM                               clCreateMLOpSliceBackwardQCOM;
    pfnClCreateMLOpGatherBackwardQCOM                              clCreateMLOpGatherBackwardQCOM;
    pfnClCreateMLOpArgMaxQCOM                                      clCreateMLOpArgMaxQCOM;
    pfnClCreateMLOpOneHotQCOM                                      clCreateMLOpOneHotQCOM;
    pfnClCreateMLOpSpaceToDepthQCOM                                clCreateMLOpSpaceToDepthQCOM;
    pfnClCreateMLOpUnaryQCOM                                       clCreateMLOpUnaryQCOM;
    pfnClCreateMLOpSoftmaxBackwardQCOM                             clCreateMLOpSoftmaxBackwardQCOM;
    pfnCreateKernelArgMLTensorQCOM                                 clCreateKernelArgMLTensorQCOM;
    pfnClGetMLOpDeviceMemoryRequirementsQCOM                       clGetMLOpDeviceMemoryRequirementsQCOM;
    pfnClUpdateMLOpDeviceMemoryQCOM                                clUpdateMLOpDeviceMemoryQCOM;
    pfnClCreateMLOpLocalResponseNormQCOM                           clCreateMLOpLocalResponseNormQCOM;
    pfnClCreateMLOpLocalResponseNormBackwardQCOM                   clCreateMLOpLocalResponseNormBackwardQCOM;
    pfnClCreateMLOpUpdateParameterSGDQCOM                          clCreateMLOpUpdateParameterSGDQCOM;
    pfnClCreateMLOpUpdateParameterADAMQCOM                         clCreateMLOpUpdateParameterADAMQCOM;
    pfnClCreateMLOpFusedBinaryActivationQCOM                       clCreateMLOpFusedBinaryActivationQCOM;
    pfnClCreateMLOpFusedFullyConnectedActivationQCOM               clCreateMLOpFusedFullyConnectedActivationQCOM;
    pfnClCreateMLOpFusedGemmActivationQCOM                         clCreateMLOpFusedGemmActivationQCOM;
} CLMLInterfaceV3QCOM;

/*******************************************************************************************************************************
*   clQueryMLInterfaceVersionsQCOM
*
*   @brief
*       Query information about different ML extension interface versions.
*   @desc:
*       This function queries information about the different ML extension interface versions supported by the implementation.
*       Newer interface versions may expose additional Ops.
*   @param
*       pMajorVersions  [out]: Pointer to a user-allocated list of integers where all the supported major version numbers by
*                              the implementation will be returned. If it is NULL, it will be ignored.
*   @param
*       pMajorVersions  [out]: Pointer to a user-allocated list of integers where all the supported minor version numbers by
*                              the implementation will be returned. If it is NULL, it will be ignored.
*   @param
*       numVersions      [in]: Number of interface versions to be queried. If <pMajorVersions> and <pMajorVersions> are NULL,
*                              it will be ignored but <pNumVersionsRet>, if not NULL, can return the number of interfaces
*                              actually available; otherwise, it should be at least the actual number of available versions
*                              returned by <pNumVersionsRet>.
*   @param
*       pNumVersionsRet [out]: Pointer to an integer that returns the number of interface versions that are actually available.
*                              If it is NULL, it will be ignored.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
CL_API_ENTRY cl_int CL_API_CALL clQueryMLInterfaceVersionsQCOM(
    cl_int*  pMajorVersions,
    cl_int*  pMinorVersions,
    cl_uint  numVersions,
    cl_uint* pNumVersionsRet);

/*******************************************************************************************************************************
*   clGetMLInterfaceQCOM
*
*   @brief
*       Provides the extension interface specified by <majorVersion> and <minorVersion>.
*   @note
*       Applications should reinterpret <pInterface> based on the extension interface struct for that version.
*   @param
*       pInterface  [out]: Void Pointer to the extension interface and returns the extension interface specified by
*                          <majorVersion> and <minorVersion>.
*   @param
*       majorVersion [in]: Major version to desired extension interface.
*   @param
*       minorVersion [in]: Minor version to desired extension interface.
*   @return
*       CL_SUCCESS if the function executed successfully.
*
*******************************************************************************************************************************/
CL_API_ENTRY cl_int CL_API_CALL clGetMLInterfaceQCOM(
    void*               pInterface,
    cl_int              majorVersion,
    cl_int              minorVersion);

/**
* Macro for getting extension interface specified by <MAJOR_VER> and <MINOR_VER>
*/
#define CL_GET_ML_INTERFACE_QCOM(P_INTERFACE, MAJOR_VER, MINOR_VER) \
  clGetMLInterfaceQCOM((void*) &P_INTERFACE, MAJOR_VER, MINOR_VER)

/*******************************************************************************************************************************
*   clGetMLInterfaceV1QCOM
*
*   @brief
*       Returns the extension interface for major version 1 and minor version specified by <minorVersion>.
*   @param
*       minorVersion [in]: Minor version to desired major version 1 extension interface.
*   @return
*       extension interface handle if the function executed successfully.
*
*******************************************************************************************************************************/
inline CLMLInterfaceV1QCOM* clGetMLInterfaceV1QCOM(cl_int minorVersion)
{
    CLMLInterfaceV1QCOM* pInterface = NULL;
    cl_int result = CL_GET_ML_INTERFACE_QCOM(pInterface, 1, minorVersion);
    if (result != CL_SUCCESS) return NULL;
    else return pInterface;
}

/*******************************************************************************************************************************
*   clGetMLInterfaceV2QCOM
*
*   @brief
*       Returns the extension interface for major version 2 and minor version specified by <minorVersion>.
*   @param
*       minorVersion [in]: Minor version to desired major version 2 extension interface.
*   @return
*       extension interface handle if the function executed successfully.
*
*******************************************************************************************************************************/
inline CLMLInterfaceV2QCOM* clGetMLInterfaceV2QCOM(cl_int minorVersion)
{
    CLMLInterfaceV2QCOM* pInterface = NULL;
    cl_int result = CL_GET_ML_INTERFACE_QCOM(pInterface, 2, minorVersion);
    if (result != CL_SUCCESS) return NULL;
    else return pInterface;
}

/*******************************************************************************************************************************
*   clGetMLInterfaceV3QCOM
*
*   @brief
*       Returns the extension interface for major version 3 and minor version specified by <minorVersion>.
*   @param
*       minorVersion [in]: Minor version to desired major version 3 extension interface.
*   @return
*       extension interface handle if the function executed successfully.
*
*******************************************************************************************************************************/
inline CLMLInterfaceV3QCOM* clGetMLInterfaceV3QCOM(cl_int minorVersion)
{
    CLMLInterfaceV3QCOM* pInterface = NULL;
    cl_int result = CL_GET_ML_INTERFACE_QCOM(pInterface, 3, minorVersion);
    if (result != CL_SUCCESS) return NULL;
    else return pInterface;
}

#ifdef __cplusplus
}
#endif

#endif // CL_QCOM_ML_OPS_H
