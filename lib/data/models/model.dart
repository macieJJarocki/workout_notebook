abstract class Model {
  Model(this.id);

  final int id;

  Map<String, dynamic> toMap();
  Model copyWith();
}
