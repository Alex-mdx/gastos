class PresupuestoModel {
  int? activo;
  double? presupuesto;
  double? lunes;
  double? martes;
  double? miercoles;
  double? jueves;
  double? viernes;
  double? sabado;
  double? domingo;
  int? periodo;

  PresupuestoModel(
      {required this.activo,
      required this.presupuesto,
      required this.lunes,
      required this.martes,
      required this.miercoles,
      required this.jueves,
      required this.viernes,
      required this.sabado,
      required this.domingo,
      required this.periodo});

  PresupuestoModel copyWith(
          {int? activo,
          double? presupuesto,
          double? lunes,
          double? martes,
          double? miercoles,
          double? jueves,
          double? viernes,
          double? sabado,
          double? domingo,
          int? periodo}) =>
      PresupuestoModel(
          activo: activo ?? this.activo,
          presupuesto: presupuesto ?? this.presupuesto,
          lunes: lunes ?? this.lunes,
          martes: martes ?? this.martes,
          miercoles: miercoles ?? this.miercoles,
          jueves: jueves ?? this.jueves,
          viernes: viernes ?? this.viernes,
          sabado: sabado ?? this.sabado,
          domingo: domingo ?? this.domingo,
          periodo: periodo ?? this.periodo);

  factory PresupuestoModel.fromJson(Map<String, dynamic> json) =>
      PresupuestoModel(
          activo: json["activo"] ?? 0,
          presupuesto: json["presupuesto"]?.toDouble() ?? -1,
          lunes: json["lunes"]?.toDouble() ?? -1,
          martes: json["martes"]?.toDouble() ?? -1,
          miercoles: json["miercoles"]?.toDouble() ?? -1,
          jueves: json["jueves"]?.toDouble() ?? -1,
          viernes: json["viernes"]?.toDouble() ?? -1,
          sabado: json["sabado"]?.toDouble() ?? -1,
          domingo: json["domingo"]?.toDouble() ?? -1,
          periodo: json["periodo"]);

  Map<String, dynamic> toJson() => {
        "activo": activo,
        "presupuesto": presupuesto,
        "lunes": lunes,
        "martes": martes,
        "miercoles": miercoles,
        "jueves": jueves,
        "viernes": viernes,
        "sabado": sabado,
        "domingo": domingo,
        "periodo": periodo
      };
}
