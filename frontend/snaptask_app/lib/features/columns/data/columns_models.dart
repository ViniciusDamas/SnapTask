import 'package:snaptask_app/features/cards/data/cards_models.dart';

class ColumnSummary {
  final String id;
  final String name;
  final int order;
  final String boardId;

  ColumnSummary({
    required this.id,
    required this.name,
    required this.order,
    required this.boardId,
  });

  factory ColumnSummary.fromJson(Map<String, dynamic> json) {
    return ColumnSummary(
      id: json['id'] as String,
      name: json['name'] as String,
      order: json['order'] as int? ?? 0,
      boardId: json['boardId'] as String,
    );
  }
}

class CreateColumnRequest {
  final String boardId;
  final String name;

  CreateColumnRequest({required this.boardId, required this.name});

  Map<String, dynamic> toJson() => {'boardId': boardId, 'name': name};
}

class UpdateColumnRequest {
  final String name;

  UpdateColumnRequest({required this.name});

  Map<String, dynamic> toJson() => {'name': name};
}

class ColumnDetails {
  final String id;
  final String name;
  final int order;
  final List<CardSummary> cards;

  ColumnDetails({
    required this.id,
    required this.name,
    required this.order,
    required this.cards,
  });

  factory ColumnDetails.fromJson(Map<String, dynamic> json) {
    final cardsJson = json['cards'];
    return ColumnDetails(
      id: json['id'] as String,
      name: json['name'] as String,
      order: json['order'] as int? ?? 0,
      cards: cardsJson is List
          ? cardsJson
                .map((e) => CardSummary.fromJson(e as Map<String, dynamic>))
                .toList()
          : <CardSummary>[],
    );
  }
}
