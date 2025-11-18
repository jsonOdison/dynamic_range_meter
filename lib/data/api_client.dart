import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dtos/test_case_dto.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

class ApiClient {
  static const String _baseUrl =
      'https://nd-assignment.azurewebsites.net/api/get-ranges';
  static const String _authToken =
      'eb3dae0a10614a7e719277e07e268b12aeb3af6d7a4655472608451b321f5a95';

  Future<List<TestCaseDto>> fetchTestCases() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $_authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw ApiException('Failed to fetch test cases', response.statusCode);
    }

    final data = json.decode(response.body);
    if (data is! List) {
      throw ApiException('Invalid data format');
    }
    return data
        .map((e) => TestCaseDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
