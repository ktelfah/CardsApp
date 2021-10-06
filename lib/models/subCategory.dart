class SubCategory {
  String subCategoryId;
  String categoryId;
  String name;
  String price;
  String quantity;
  String uniqid;
  String description;

  SubCategory(
      {this.subCategoryId,
      this.categoryId,
      this.name,
      this.price,
      this.quantity,
      this.uniqid,
      this.description});

  factory SubCategory.fromJson(Map<dynamic, dynamic> json) => new SubCategory(
        subCategoryId: json["subCategoryId"],
        categoryId: json["categoryId"],
        uniqid: json["uniqid"],
        name: json["name"],
        price: json["price"],
        quantity: json["quantity"],
        description: json["description"],
      );

  Map<dynamic, dynamic> toJson() => {
        "subCategoryId": subCategoryId,
        "categoryId": categoryId,
        "name": name,
        "uniqid": uniqid,
        "price": price,
        "quantity": quantity,
        "description": description,
      };
}
