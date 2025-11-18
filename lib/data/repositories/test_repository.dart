import '../api_client.dart';
import '../../domain/models/test_case.dart';

class TestRepository {
  final ApiClient apiClient;

  TestRepository({required this.apiClient});

  Future<List<TestCase>> getTestCases() async {
    final dtos = await apiClient.fetchTestCases();
    return dtos.map((dto) => dto.toDomain()).toList();
  }
}
