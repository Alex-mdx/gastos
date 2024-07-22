class PeriodoModelo {
  String year;
  String mes;
  String dia;
  int modificable;

  PeriodoModelo(
      {required this.year,
      required this.mes,
      required this.dia,
      required this.modificable});

  PeriodoModelo copyWith(
          {String? year, String? mes, String? dia, int? modificable}) =>
      PeriodoModelo(
          year: year ?? this.year,
          mes: mes ?? this.mes,
          dia: dia ?? this.dia,
          modificable: modificable ?? this.modificable);

  factory PeriodoModelo.fromJson(Map<String, dynamic> json) => PeriodoModelo(
      year: json["year"],
      mes: json["mes"],
      dia: json["dia"],
      modificable: json["modificable"]);

  Map<String, dynamic> toJson() =>
      {"year": year, "mes": mes, "dia": dia, "modificable": modificable};
}
