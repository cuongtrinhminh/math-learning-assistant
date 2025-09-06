import 'package:flutter/material.dart';

class MathErrorParseKey {
  static const String errorMessage = "error_message";
}

class MathError {
  final String errorMessage;

  MathError({
    required this.errorMessage
  });

  factory MathError.fromJson(Map<String, dynamic> json) {
    return MathError(
      errorMessage: json[MathErrorParseKey.errorMessage] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      MathErrorParseKey.errorMessage: errorMessage,
    };
  }
}