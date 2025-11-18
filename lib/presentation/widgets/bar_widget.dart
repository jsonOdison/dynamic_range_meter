import 'package:flutter/material.dart';
import '../../domain/models/range_section.dart';
import '../../core/utils/color_parser.dart';

class BarWidget extends StatelessWidget {
  final List<RangeSection> ranges;
  final double? currentValue;

  const BarWidget({super.key, required this.ranges, this.currentValue});

  @override
  Widget build(BuildContext context) {
    if (ranges.isEmpty) {
      return const Text('No ranges to display.');
    }
    final overallMin = ranges
        .map((r) => r.start)
        .reduce((a, b) => a < b ? a : b);
    final overallMax = ranges.map((r) => r.end).reduce((a, b) => a > b ? a : b);
    final totalSpan = overallMax - overallMin;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Row(
              children: ranges.map((r) {
                final widthFactor = (r.end - r.start) / totalSpan;
                return Expanded(
                  flex: (widthFactor * 1000).round(),
                  child: Container(
                    height: 32,
                    color: ColorParser.fromHex(r.colorHex),
                    child: Center(
                      child: Text(
                        r.label,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            if (currentValue != null &&
                currentValue! >= overallMin &&
                currentValue! <= overallMax)
              Positioned(
                left:
                    ((currentValue! - overallMin) / totalSpan) *
                    MediaQuery.of(context).size.width *
                    0.8,
                child: Container(width: 2, height: 36, color: Colors.black),
              ),
          ],
        ),
      ],
    );
  }
}
