import 'package:snaptask_app/features/cards/ui/card_status.dart';

class CardSummary {
  final String id;
  final String title;
  final String? description;
  final int order;
  final String columnId;
  final CardStatus status;

  CardSummary({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    required this.columnId,
    required this.status,
  });

  factory CardSummary.fromJson(Map<String, dynamic> json) {
    return CardSummary(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      order: json['order'] as int? ?? 0,
      columnId: json['columnId'] as String,
      status: CardStatusX.fromApi(json['status']),
    );
  }

  CardSummary copyWith({
    String? title,
    String? description,
    int? order,
    String? columnId,
    CardStatus? status,
  }) {
    return CardSummary(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      order: order ?? this.order,
      columnId: columnId ?? this.columnId,
      status: status ?? this.status,
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

class UpdateCardRequest {
  final String? title;
  final String? description;
  final CardStatus? status;

  UpdateCardRequest({this.title, this.description, this.status});

  UpdateCardRequest copyWith({
    String? title,
    String? description,
    CardStatus? status,
  }) {
    return UpdateCardRequest(
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
    if (title != null) 'title': title,
    if (description != null) 'description': description,
    if (status != null) 'status': status!.toApi(),
  };
}
