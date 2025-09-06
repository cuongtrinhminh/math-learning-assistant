import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:frontend/models/math_answer.dart';
import 'package:frontend/models/math_error.dart';
import 'package:frontend/models/api_response.dart';

class MathService {
  final String apiUrl = "";

  Future<ApiResponse<List<MathAnswer>>> getAnswer(File image) async {
    try {
      // Convert image to base64
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"imageBase64": base64Image}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final answers = jsonList.map((e) => MathAnswer.fromJson(e)).toList();
        return ApiResponse.success(answers);
      } else {
        final json = jsonDecode(response.body);
        return ApiResponse.error(
          MathError.fromJson(json),
          code: response.statusCode,
        );
      }
    } catch (e) {
      throw Exception("Failed to solve: $e");
    }
  }
}