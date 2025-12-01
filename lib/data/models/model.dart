abstract class Model {
  final int id;
  Model(this.id);
  Map<String, dynamic> toMap();
  // TODO ?-> add copyWith method <-?
}
