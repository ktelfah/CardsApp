import 'package:cloud_firestore/cloud_firestore.dart';

class Cards {
  String adminId;
  String cardId;
  num amount;
  String cardNumber;
  String cardVender;
  String status;
  String category;
  String subCategory;
  Timestamp addingnDate;
  bool isChecked = false;

  Cards(
      {this.adminId,
      this.cardId,
      this.amount,
      this.cardNumber,
      this.cardVender,
      this.status,
      this.category,
      this.subCategory,
      this.addingnDate,
      this.isChecked});

  factory Cards.fromJson(Map<dynamic, dynamic> json) => new Cards(
        adminId: json["adminId"],
        cardId: json["cardId"],
        amount: json["amount"],
        cardNumber: json["cardNumber"],
        cardVender: json["cardVender"],
        category: json["category"],
        subCategory: json["subCategory"],
        status: json["status"],
        addingnDate: json["addingnDate"],
        isChecked: false,
      );

  Map<dynamic, dynamic> toJson() => {
        "adminId": adminId,
        "cardId": cardId,
        "amount": amount,
        "cardNumber": cardNumber,
        "cardVender": cardVender,
        "status": status,
        "category": category,
        "subCategory": subCategory,
        "isChecked": isChecked,
        "addingnDate": addingnDate,
      };
}
