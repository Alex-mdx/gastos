class CategoriaModel {
  int? id;
  String nombre;
  String descripcion;

  CategoriaModel(
      {this.id, required this.nombre, required this.descripcion});

  CategoriaModel copyWith({int? id, String? nombre, String? descipcion}) =>
      CategoriaModel(
          id: id ?? this.id,
          nombre: nombre ?? this.nombre,
          descripcion: descipcion ?? this.descripcion);

  factory CategoriaModel.fromJson(Map<String, dynamic> json) => CategoriaModel(
      id: json["id"], nombre: json["nombre"], descripcion: json["descripcion"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "nombre": nombre, "descripcion": descripcion};
}
