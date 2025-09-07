import 'package:flutter/material.dart';
import 'package:frontend/models/math_error.dart';

class ApiResponse<T> {
  final T? data;
  final MathError? error;
  final int code;
  final bool success;

  ApiResponse.success(this.data, {this.code = 200})
      : error = null,
        success = true;

  ApiResponse.error(this.error, {required this.code})
      : data = null,
        success = false;
}