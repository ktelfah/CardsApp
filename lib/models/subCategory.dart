class SubCategory {
  String subCategoryId;
  String categoryId;
  String name;
  String price;
  String quantity;
  String description;

  SubCategory(
      {this.subCategoryId,
      this.categoryId,
      this.name,
      this.price,
      this.quantity,
      this.description});

  factory SubCategory.fromJson(Map<dynamic, dynamic> json) => new SubCategory(
        subCategoryId: json["subCategoryId"],
        categoryId: json["categoryId"],
        name: json["name"],
        quantity: json["quantity"],
        description: json["description"],
      );

  Map<dynamic, dynamic> toJson() => {
        "subCategoryId": subCategoryId,
        "categoryId": categoryId,
        "name": name,
        "quantity": quantity,
        "description": description,
      };
}
