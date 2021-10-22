class Category {
  String categoryName;
  String categoryId;

  Category({this.categoryName, this.categoryId});

  factory Category.fromJson(Map<dynamic, dynamic> json) => new Category(
        categoryName: json["categoryName"],
        categoryId: json["categoryId"],
      );

  Map<dynamic, dynamic> toJson() => {
        "categoryName": categoryName,
        "categoryId": categoryId,
      };
}
