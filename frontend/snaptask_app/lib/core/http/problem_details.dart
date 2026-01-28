class ProblemDetails {
  final String? type;
  final String? title;
  final int? status;
  final String? detail;
  final String? instance;
  final String? traceId;
  final Map<String, List<String>>? errors;

  ProblemDetails({
    this.type,
    this.title,
    this.status,
    this.detail,
    this.instance,
    this.traceId,
    this.errors,
  });

  factory ProblemDetails.fromJson(Map<String, dynamic> json) {
    Map<String, List<String>>? parsedErrors;

    final rawErrors = json['errors'];
    if (rawErrors is Map<String, dynamic>) {
      parsedErrors = rawErrors.map((key, value) {
        if (value is List) {
          return MapEntry(
            key.toString(),
            value.map((e) => e.toString()).toList(),
          );
        }
        return MapEntry(key.toString(), <String>[value.toString()]);
      });
    }

    final traceId = json['traceId']?.toString();

    return ProblemDetails(
      type: json['type']?.toString(),
      title: json['title']?.toString(),
      status: (json['status'] is int)
          ? json['status'] as int
          : int.tryParse('${json['status']}'),
      detail: json['detail']?.toString(),
      instance: json['instance']?.toString(),
      traceId: traceId,
      errors: parsedErrors,
    );
  }

  String get userMessage {
    if (detail != null && detail!.trim().isNotEmpty) return detail!;
    if (title != null && title!.trim().isNotEmpty) return title!;
    return 'Ocorreu um erro inesperado.';
  }

  List<String> get allValidationMessages {
    if (errors == null) return const [];
    final list = <String>[];
    for (final entry in errors!.entries) {
      for (final msg in entry.value) {
        list.add('${entry.key}: $msg');
      }
    }
    return list;
  }
}
