import '../../domain/models/range_section.dart';

class RangeSectionDto {
  final double start;
  final double end;
  final String label;
  final String color;

  RangeSectionDto({
    required this.start,
    required this.end,
    required this.label,
    required this.color,
  });

  factory RangeSectionDto.fromJson(Map<String, dynamic> json) {
    return RangeSectionDto(
      start: (json['start'] as num).toDouble(),
      end: (json['end'] as num).toDouble(),
      label: json['label'] as String,
      color: json['color'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'start': start,
    'end': end,
    'label': label,
    'color': color,
  };

  // Mapping to domain model
  RangeSection toDomain() {
    return RangeSection(start: start, end: end, label: label, colorHex: color);
  }
}
