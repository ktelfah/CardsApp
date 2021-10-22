class SubCategory {
  String categoryId;
  String name;
  String price;
  String quantity;
  String uniqid;
  String description;

  SubCategory(
      {this.categoryId,
      this.name,
      this.price,
      this.quantity,
      this.uniqid,
      this.description});

  factory SubCategory.fromJson(Map<dynamic, dynamic> json) => new SubCategory(
        categoryId: json["categoryId"],
        name: json["name"],
        price: json["price"],
        quantity: json["quantity"],
        uniqid: json["uniqid"],
        description: json["description"],
      );

  Map<dynamic, dynamic> toJson() => {
        "categoryId": categoryId,
        "name": name,
        "price": price,
        "quantity": quantity,
        "uniqid": uniqid,
        "description": description,
      };
}
