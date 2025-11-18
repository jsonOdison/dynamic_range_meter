import 'package:flutter/material.dart';
import 'package:neo_docs/domain/models/test_case.dart';
import 'package:provider/provider.dart';
import '../viewmodels/test_cases_view_model.dart';
import '../widgets/bar_widget.dart';

class TestCasesScreen extends StatefulWidget {
  const TestCasesScreen({super.key});

  @override
  State<TestCasesScreen> createState() => _TestCasesScreenState();
}

class _TestCasesScreenState extends State<TestCasesScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<TestCasesViewModel>(
        context,
        listen: false,
      ).loadTestCases(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TestCasesViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (viewModel.errorMessage != null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(viewModel.errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: viewModel.loadTestCases,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        if (viewModel.testCases.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('No data available.')),
          );
        }
        final selected = viewModel.selectedTestCase;
        return Scaffold(
          appBar: AppBar(title: const Text('Dynamic Range Meter')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (viewModel.testCases.length > 1)
                  DropdownButton<TestCase>(
                    value: selected,
                    items: viewModel.testCases
                        .map(
                          (tc) =>
                              DropdownMenuItem(value: tc, child: Text(tc.id)),
                        )
                        .toList(),
                    onChanged: (tc) {
                      if (tc != null) viewModel.selectTestCase(tc);
                      _controller.clear();
                    },
                  ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter value',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    final parsed = double.tryParse(val);
                    viewModel.updateCurrentValue(parsed);
                  },
                ),
                const SizedBox(height: 16),
                Builder(
                  builder: (_) {
                    final currentRange = viewModel.getCurrentRange();
                    if (viewModel.currentValue == null) {
                      return const Text('Enter a value to see range.');
                    }
                    if (currentRange == null) {
                      return const Text('Out of range');
                    }
                    return Text(
                      'Current: ${currentRange.label} (${currentRange.start}–${currentRange.end})',
                    );
                  },
                ),
                const SizedBox(height: 24),
                if (selected != null)
                  BarWidget(
                    ranges: selected.ranges,
                    currentValue: viewModel.currentValue,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
