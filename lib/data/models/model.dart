abstract class Model {
  Model(this.uuid, this.comment, this.name);

  final String uuid;
  final String name;
  final String? comment;

  Map<String, dynamic> toMap();
  Model copyWith();
}
