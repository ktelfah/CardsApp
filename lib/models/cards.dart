class Cards {
  //static var shared = Admin;
  String adminId;
  String cardId;
  String amount;
  String cardNumber;
  String cardVender;
  String status;

  Cards(
      {required this.adminId,
        required this.cardId,
        required this.amount,
        required this.cardNumber,
        required this.cardVender,
        required this.status,});

  factory Cards.fromJson(Map<dynamic, dynamic> json) => new Cards(
    adminId: json["adminId"],
    cardId: json["cardId"],
    amount: json["amount"],
    cardNumber: json["cardNumber"],
    cardVender: json["cardVender"],
    status: json["status"],
  );

  Map<dynamic, dynamic> toJson() => {
    "adminId": adminId,
    "cardId": cardId,
    "amount": amount,
    "cardNumber": cardNumber,
    "cardVender": cardVender,
    "status": status,
  };
}
