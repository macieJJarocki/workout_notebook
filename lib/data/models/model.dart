abstract class Model {
  Model({
    required this.uuid,
    required this.name,
    this.comment,
  });

  final String uuid;
  final String name;
  final String? comment;

  Map<String, dynamic> toMap();
  Model copyWith();
}
