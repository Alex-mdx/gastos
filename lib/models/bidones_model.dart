class BidonesModel {
  int id;
  String nombre;
  double monto;
  List<dynamic> metodoPago;
  List<dynamic> categoria;

  BidonesModel(
      {required this.id,
      required this.nombre,
      required this.monto,
      required this.metodoPago,
      required this.categoria});

  BidonesModel copyWith(
          {int? id,
          String? nombre,
          double? monto,
          List<dynamic>? metodoPago,
          List<dynamic>? categoria}) =>
      BidonesModel(
          id: id ?? this.id,
          nombre: nombre ?? this.nombre,
          monto: monto ?? this.monto,
          metodoPago: metodoPago ?? this.metodoPago,
          categoria: categoria ?? this.categoria);

  factory BidonesModel.fromJson(Map<String, dynamic> json) => BidonesModel(
      id: json["id"],
      nombre: json["nombre"],
      monto: json["monto"]?.toDouble(),
      metodoPago: List<dynamic>.from(json["metodo_pago"].map((x) => x)),
      categoria: List<dynamic>.from(json["categoria"].map((x) => x)));

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "monto": monto,
        "metodo_pago": List<dynamic>.from(metodoPago.map((x) => x)),
        "categoria": List<dynamic>.from(categoria.map((x) => x))
      };
}
