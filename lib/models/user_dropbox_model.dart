import 'package:gastos/utilities/funcion_parser.dart';

class UserDropboxModel {
  String accountId;
  String email;
  int? emailVerified;
  String profilePhotoUrl;

  UserDropboxModel(
      {required this.accountId,
      required this.email,
      required this.emailVerified,
      required this.profilePhotoUrl});

  UserDropboxModel copyWith(
          {String? accountId,
          String? email,
          int? emailVerified,
          String? profilePhotoUrl}) =>
      UserDropboxModel(
          accountId: accountId ?? this.accountId,
          email: email ?? this.email,
          emailVerified: emailVerified ?? this.emailVerified,
          profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl);

  factory UserDropboxModel.fromJson(Map<String, dynamic> json) =>
      UserDropboxModel(
          accountId: json["account_id"],
          email: json["email"],
          emailVerified: Parser.toInt(json["email_verified"]),
          profilePhotoUrl: json["profile_photo_url"]);

  Map<String, dynamic> toJson() => {
        "account_id": accountId,
        "email": email,
        "email_verified": emailVerified,
        "profile_photo_url": profilePhotoUrl
      };
}
