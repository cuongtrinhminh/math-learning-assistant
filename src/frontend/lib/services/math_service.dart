import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class MathService {
  final String apiUrl = "";

  Future<String> solveMath(File image) async {
    try {
      // Convert image to base64
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Gửi request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"imageBase64": base64Image}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["answer"]; // tùy API
      } else {
        throw Exception("API Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to solve: $e");
    }
  }
}