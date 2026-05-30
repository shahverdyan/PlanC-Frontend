class ValidationResult {
  final String estat;
  final double distancia;
  final bool success;

  const ValidationResult({
    required this.estat,
    required this.distancia,
    required this.success,
  });

  factory ValidationResult.fromJson(Map<String, dynamic> json) {
    return ValidationResult(
      estat: json['estat']?.toString() ?? '',
      distancia: (json['distancia'] as num?)?.toDouble() ?? 0.0,
      success: json['success'] as bool? ?? true,
    );
  }
}
