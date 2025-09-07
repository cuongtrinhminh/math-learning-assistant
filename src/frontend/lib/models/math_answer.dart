import 'package:flutter/material.dart';
import 'package:frontend/models/answer_step.dart';

class QuestionParseKey {
  static const String questionId = "question_id";
  static const String questionOverview = "question_overview";
  static const String answerSteps = "answer_steps";
  static const String finalAnswer = "final_answer";
}

class MathAnswer {
  final String questionId;
  final String questionOverview;
  final List<AnswerStep> answerSteps;
  final String finalAnswer;

  MathAnswer({
    required this.questionId,
    required this.questionOverview,
    required this.answerSteps,
    required this.finalAnswer,
  });

  factory MathAnswer.fromJson(Map<String, dynamic> json) {
    return MathAnswer(
      questionId: json[QuestionParseKey.questionId] ?? "",
      questionOverview: json[QuestionParseKey.questionOverview] ?? "",
      answerSteps: (json[QuestionParseKey.answerSteps] as List<dynamic>? ?? [])
          .map((step) => AnswerStep.fromJson(step))
          .toList(),
      finalAnswer: json[QuestionParseKey.finalAnswer] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      QuestionParseKey.questionId: questionId,
      QuestionParseKey.questionOverview: questionOverview,
      QuestionParseKey.answerSteps: answerSteps.map((e) => e.toJson()).toList(),
      QuestionParseKey.finalAnswer: finalAnswer,
    };
  }
}