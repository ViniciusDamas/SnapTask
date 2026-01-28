class BoardSummary {
  final String id;
  final String name;
  final DateTime createdAt;

  BoardSummary({required this.id, required this.name, required this.createdAt});

  factory BoardSummary.fromJson(Map<String, dynamic> json) {
    return BoardSummary(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class CreateBoardRequest {
  final String name;

  CreateBoardRequest({required this.name});

  Map<String, dynamic> toJson() => {'name': name};
}

class UpdateBoardRequest {
  final String name;

  UpdateBoardRequest({required this.name});

  Map<String, dynamic> toJson() => {'name': name};
}

class BoardDetails {
  final String id;
  final String name;
  final DateTime createdAt;
  final List<ColumnDetails> columns;

  BoardDetails({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.columns,
  });

  factory BoardDetails.fromJson(Map<String, dynamic> json) {
    final columnsJson = json['columns'];
    return BoardDetails(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      columns: columnsJson is List
          ? columnsJson
                .map((e) => ColumnDetails.fromJson(e as Map<String, dynamic>))
                .toList()
          : <ColumnDetails>[],
    );
  }
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
