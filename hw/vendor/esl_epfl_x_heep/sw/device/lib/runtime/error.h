// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Modified version for core-v-mini-mcu
// original at: https://github.com/lowRISC/opentitan/blob/master/sw/

#ifndef _RUNTIME_ERROR_H_
#define _RUNTIME_ERROR_H_

#ifdef __cplusplus
extern "C" {
#endif

#include "absl_status.h"

/**
 * List of modules which can produce errors.
 *
 * Choose a two-letter identifier for each module and encode the module
 * identifier the concatenated ASCII representation of those letters.
 */
enum module_ {
  kModuleUnknown = 0,
  kModuleUart = 0x4155,       // ASCII "UA".
  kModuleHmac = 0x4d48,       // ASCII "HM".
  kModuleSigverify = 0x5653,  // ASCII "SV".
};

/**
 * Helper macro for building up error codes.
 * @param status_ An appropriate general status code from absl_staus.h.
 * @param module_ The module identifier which produces this error.
 * @param error_ The unique error id in that module.  Error ids must not
 *               repeat within a module.
 */
#define ERROR_(error_, module_, status_) \
  ((error_ << 24) | (module_ << 8) | (status_))

// clang-format off
// Use an X-macro to facilitate writing unit tests.
// Note: This list is extend-only and you may not renumber errors after they
//       have been created.  This is required for error-space stability
//       after the ROM is frozen.
#define DEFINE_ERRORS(X) \
  X(kErrorOk, 0x739), \
  X(kErrorUartInvalidArgument,      ERROR_(1, kModuleUart, kInvalidArgument)), \
  X(kErrorUartBadBaudRate,          ERROR_(2, kModuleUart, kInvalidArgument)), \
  X(kErrorHmacInvalidArgument,      ERROR_(1, kModuleHmac, kInvalidArgument)), \
  X(kErrorSigverifyInvalidArgument, ERROR_(1, kModuleSigverify, kInvalidArgument)), \
  X(kErrorUnknown, 0xFFFFFFFF)
// clang-format on

#define ERROR_ENUM_INIT(name_, value_) name_ = value_

/**
 * Unified set of errors for Mask ROM and ROM_EXT.
 */
typedef enum system_error {
  DEFINE_ERRORS(ERROR_ENUM_INIT),
} system_error_t;

/**
 * Evaluate an expression and return if the result is an error.
 *
 * @param expr_ An expression which results in an system_error_t.
 */
#define RETURN_IF_ERROR(expr_)        \
  do {                                \
    system_error_t local_error_ = expr_; \
    if (local_error_ != kErrorOk) {   \
      return local_error_;            \
    }                                 \
  } while (0)

#ifdef __cplusplus
}
#endif

#endif  // OPENTITAN_SW_DEVICE_SILICON_CREATOR_LIB_ERROR_H_
