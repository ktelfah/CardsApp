class Admin {
  //static var shared = Admin;
  String adminId;
  String adminName;
  String phoneNo;
  String email;
  String password;

  Admin(
      {required this.adminId,
      required this.adminName,
      required this.phoneNo,
      required this.email,
      required this.password});

  factory Admin.fromJson(Map<dynamic, dynamic> json) => new Admin(
       adminId: json["adminId"],
        adminName: json["name"],
        phoneNo: json["phoneNo"],
        email: json["email"],
        password: json["password"],
      );

  Map<dynamic, dynamic> toJson() => {
        "adminId": adminId,
        "name": adminName,
        "phoneNo": phoneNo,
        "email": email,
        "password": password
      };
}
