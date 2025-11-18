import 'range_section_dto.dart';
import '../../domain/models/test_case.dart';

class TestCaseDto {
  final String id;
  final List<RangeSectionDto> ranges;

  TestCaseDto({required this.id, required this.ranges});

  factory TestCaseDto.fromJson(Map<String, dynamic> json) {
    return TestCaseDto(
      id: json['id'] as String? ?? json['name'] as String? ?? '',
      ranges: (json['ranges'] as List<dynamic>? ?? [])
          .map((e) => RangeSectionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'ranges': ranges.map((e) => e.toJson()).toList(),
  };

  // Mapping to domain model
  TestCase toDomain() {
    return TestCase(id: id, ranges: ranges.map((e) => e.toDomain()).toList());
  }
}
