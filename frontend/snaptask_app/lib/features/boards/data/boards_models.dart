import 'package:snaptask_app/features/columns/data/columns_models.dart';

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
