import 'package:flutter/foundation.dart';
import '../../data/repositories/test_repository.dart';
import '../../domain/models/test_case.dart';
import '../../domain/models/range_section.dart';

class TestCasesViewModel extends ChangeNotifier {
  final TestRepository repository;

  bool isLoading = false;
  String? errorMessage;
  List<TestCase> testCases = [];
  TestCase? selectedTestCase;
  double? currentValue;

  TestCasesViewModel({required this.repository});

  Future<void> loadTestCases() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      testCases = await repository.getTestCases();
      if (testCases.isNotEmpty) {
        selectedTestCase = testCases.first;
      } else {
        selectedTestCase = null;
      }
    } catch (e) {
      errorMessage = e.toString();
      testCases = [];
      selectedTestCase = null;
    }
    isLoading = false;
    notifyListeners();
  }

  void selectTestCase(TestCase testCase) {
    selectedTestCase = testCase;
    currentValue = null;
    notifyListeners();
  }

  void updateCurrentValue(double? value) {
    currentValue = value;
    notifyListeners();
  }

  RangeSection? getCurrentRange() {
    if (currentValue == null || selectedTestCase == null) return null;
    final ranges = selectedTestCase!.ranges;
    for (int i = 0; i < ranges.length; i++) {
      final r = ranges[i];
      final isLast = i == ranges.length - 1;
      if (currentValue! >= r.start &&
          (currentValue! < r.end || (isLast && currentValue! <= r.end))) {
        return r;
      }
    }
    return null;
  }
}
