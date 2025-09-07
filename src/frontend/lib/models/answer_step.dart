import 'package:flutter/material.dart';

class AnswerStepParseKey {
  static const String stepNumber = "step_number";
  static const String description = "description";
  static const String calculation = "calculation";
}

class AnswerStep {
  final int stepNumber;
  final String description;
  final String calculation;

  AnswerStep({
    required this.stepNumber,
    required this.description,
    required this.calculation,
  });

  factory AnswerStep.fromJson(Map<String, dynamic> json) {
    return AnswerStep(
      stepNumber: json[AnswerStepParseKey.stepNumber] ?? 0,
      description: json[AnswerStepParseKey.description] ?? "",
      calculation: json[AnswerStepParseKey.calculation] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      AnswerStepParseKey.stepNumber: stepNumber,
      AnswerStepParseKey.description: description,
      AnswerStepParseKey.calculation: calculation,
    };
  }
}