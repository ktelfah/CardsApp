import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  String cardId;
  String customerId;
  String orderId;
  Timestamp transactionDate;

  Orders({this.cardId, this.customerId, this.orderId, this.transactionDate});

  factory Orders.fromJson(Map<dynamic, dynamic> json) => new Orders(
      cardId: json["cardId"],
      customerId: json["customerId"],
      orderId: json["orderId"],
      transactionDate: json["transactionDate"]);

  Map<dynamic, dynamic> toJson() => {
        "cardId": cardId,
        "customerId": customerId,
        "orderId": orderId,
        "transactionDate": transactionDate
      };
}
