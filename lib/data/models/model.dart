abstract class Model {
  Model(this.uuid, this.comment);

  final String uuid;
  final String? comment;

  Map<String, dynamic> toMap();
  Model copyWith();
}
