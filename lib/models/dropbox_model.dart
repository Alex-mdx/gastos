class DropboxModel {
  String? pathDisplay;
  String? name;
  String? clientModified;
  String? serverModified;
  String? filesize;
  String? pathLower;

  DropboxModel(
      {required this.pathDisplay,
      required this.name,
      required this.clientModified,
      required this.serverModified,
      required this.filesize,
      required this.pathLower});

  DropboxModel copyWith(
          {String? pathDisplay,
          String? name,
          String? clientModified,
          String? serverModified,
          String? filesize,
          String? pathLower}) =>
      DropboxModel(
          pathDisplay: pathDisplay ?? this.pathDisplay,
          name: name ?? this.name,
          clientModified: clientModified ?? this.clientModified,
          serverModified: serverModified ?? this.serverModified,
          filesize: filesize ?? this.filesize,
          pathLower: pathLower ?? this.pathLower);

  factory DropboxModel.fromJson(Map<String, dynamic> json) => DropboxModel(
      pathDisplay: json["pathDisplay"].toString(),
      name: json["name"].toString(),
      clientModified: json["clientModified"].toString(),
      serverModified: json["serverModified"].toString(),
      filesize: json["filesize"].toString(),
      pathLower: json["pathLower"].toString());

  Map<String, dynamic> toJson() => {
        "pathDisplay": pathDisplay,
        "name": name,
        "clientModified": clientModified,
        "serverModified": serverModified,
        "filesize": filesize,
        "pathLower": pathLower
      };
}
