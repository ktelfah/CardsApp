class Vendors {
  String vendorId;
  String adminId;
  String name;
  String icon;
  String address1;
  String address2;
  String zipcode;
  String county;

  Vendors(
      {this.vendorId,
      this.adminId,
      this.name,
      this.icon,
      this.address1,
      this.address2,
      this.zipcode,
      this.county});

  factory Vendors.fromJson(Map<dynamic, dynamic> json) => new Vendors(
        vendorId: json["vendorId"],
        adminId: json["adminId"],
        name: json["name"],
        icon: json["icon"],
        address1: json["address1"],
        address2: json["address2"],
        zipcode: json["zipcode"],
        county: json["county"],
      );

  Map<dynamic, dynamic> toJson() => {
        "vendorId": vendorId,
        "adminId": adminId,
        "name": name,
        "icon": icon,
        "address1": address1,
        "address2": address2,
        "zipcode": zipcode,
        "county": county,
      };
}
