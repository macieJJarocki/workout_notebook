abstract class Model {
  Model(this.id, this.isCompleted);

  final int id;
  final bool isCompleted;

  Map<String, dynamic> toMap();
  Model copyWith();
}
