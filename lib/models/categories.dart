class Category {
  String categoryId;
  String vendorId;
  String categoryName;

  Category({this.categoryId, this.vendorId, this.categoryName});

  factory Category.fromJson(Map<dynamic, dynamic> json) => new Category(
      categoryId: json["categoryId"],
      vendorId: json["vendorId"],
      categoryName: json["categoryName"]);

  Map<dynamic, dynamic> toJson() => {
        "categoryId": categoryId,
        "vendorId": vendorId,
        "categoryName": categoryName
      };
}
