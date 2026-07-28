class CategoriaModel {
  int? id;
  String nombre;
  String descripcion;
  int usoTotal;

  CategoriaModel(
      {required this.id,
      required this.nombre,
      required this.descripcion,
      required this.usoTotal});

  CategoriaModel copyWith(
          {int? id, String? nombre, String? descripcion, int? usoTotal}) =>
      CategoriaModel(
          id: id ?? this.id,
          nombre: nombre ?? this.nombre,
          descripcion: descripcion ?? this.descripcion,
          usoTotal: usoTotal ?? this.usoTotal);

  factory CategoriaModel.fromJson(Map<String, dynamic> json) => CategoriaModel(
      id: json["id"],
      nombre: json["nombre"],
      descripcion: json["descripcion"],
      usoTotal: json["uso_total"] ?? 0);

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "uso_total": usoTotal
      };
}
