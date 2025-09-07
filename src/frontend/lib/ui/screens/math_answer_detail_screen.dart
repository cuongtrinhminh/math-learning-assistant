import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/assets/constants.dart';
import 'package:frontend/models/math_answer.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class AnswerDetailScreen extends StatelessWidget {
  final List<MathAnswer> answers;

  const AnswerDetailScreen({super.key, required this.answers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Answers")),
      body: ListView.builder(
        itemCount: answers.length,
        itemBuilder: (context, index) {
          final ans = answers[index];
          return Card(
            margin: const EdgeInsets.all(12),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🟢 Question Overview
                  Text(
                    "Q${ans.questionId}: ${ans.questionOverview}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 🟡 Steps
                  ...ans.answerSteps.map((step) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Step ${step.stepNumber}: ${step.description}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        if (step.calculation.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Math.tex(
                              step.calculation,
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                          ),
                      ],
                    ),
                  )),

                  const Divider(),

                  // 🔵 Final Answer
                  Text(
                    "Final Answer: ${ans.finalAnswer}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}