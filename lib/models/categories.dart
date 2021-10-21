class Category {
  String categoryName;

  Category({this.categoryName});

  factory Category.fromJson(Map<dynamic, dynamic> json) =>
      new Category(categoryName: json["categoryName"]);

  Map<dynamic, dynamic> toJson() => {"categoryName": categoryName};
}
