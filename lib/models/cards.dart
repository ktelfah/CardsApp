class Cards {
  String adminId;
  String cardId;
  int amount;
  String cardNumber;
  String cardVender;
  String status;
  bool isChecked = false;

  Cards(
      {this.adminId,
      this.cardId,
      this.amount,
      this.cardNumber,
      this.cardVender,
      this.status,
      this.isChecked});

  factory Cards.fromJson(Map<dynamic, dynamic> json) => new Cards(
        adminId: json["adminId"],
        cardId: json["cardId"],
        amount: json["amount"],
        cardNumber: json["cardNumber"],
        cardVender: json["cardVender"],
        status: json["status"],
        isChecked: false,
      );

  Map<dynamic, dynamic> toJson() => {
        "adminId": adminId,
        "cardId": cardId,
        "amount": amount,
        "cardNumber": cardNumber,
        "cardVender": cardVender,
        "status": status,
        "isChecked": isChecked,
      };
}
