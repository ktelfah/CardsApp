class Admin {
  //static var shared = Admin;
  String adminId;
  String adminName;
  String phoneNo;
  String email;
  String password;
  String isSuperAdmin;

  Admin({
    this.adminId,
    this.adminName,
    this.phoneNo,
    this.email,
    this.password,
    this.isSuperAdmin,
  });

  factory Admin.fromJson(Map<dynamic, dynamic> json) => new Admin(
        adminId: json["adminID"] ?? "",
        adminName: json["name"] ?? "",
        phoneNo: json["phoneNo"] ?? "",
        email: json["email"] ?? "",
        password: json["password"] ?? "",
        isSuperAdmin: json["isSuperAdmin"] ?? "",
      );

  Map<dynamic, dynamic> toJson() => {
        "adminID": adminId,
        "name": adminName,
        "phoneNo": phoneNo,
        "email": email,
        "password": password,
        "isSuperAdmin": isSuperAdmin,
      };
}
