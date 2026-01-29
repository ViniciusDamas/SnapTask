class CardSummary {
  final String id;
  final String title;
  final String? description;
  final int order;
  final String columnId;

  CardSummary({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    required this.columnId,
  });

  factory CardSummary.fromJson(Map<String, dynamic> json) {
    return CardSummary(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      order: json['order'] as int? ?? 0,
      columnId: json['columnId'] as String,
    );
  }
}

class CreateCardRequest {
  final String columnId;
  final String title;
  final String? description;

  CreateCardRequest({
    required this.columnId,
    required this.title,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'columnId': columnId,
    'title': title,
    'description': description,
  };
}
