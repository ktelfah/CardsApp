class Customer {
  String customerId;
  String adminId;
  num balance;
  String name;
  String password;

  Customer(
      {this.customerId, this.adminId, this.balance, this.name, this.password});

  factory Customer.fromJson(Map<dynamic, dynamic> json) => new Customer(
      customerId: json["customerId"],
      adminId: json["adminId"],
      balance: json["balance"],
      name: json["name"],
      password: json["password"]);

  Map<dynamic, dynamic> toJson() => {
        "customerId": customerId,
        "adminId": adminId,
        "balance": balance,
        "name": name,
        "password": password
      };
}
