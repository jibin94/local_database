class Item {
  final int? id;
  final String title;
  final String description;
  final String categoryName;
  final int categoryId;
  final String date;

  const Item(
      {required this.title,
      required this.description,
      this.id,
      required this.categoryName,
      required this.categoryId,
      required this.date});

  factory Item.fromJson(Map<String, dynamic> json) => Item(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      categoryName: json['categoryName'],
      categoryId: json['itemCategoryId'],
      date: json['date']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'categoryName': categoryName,
        'itemCategoryId': categoryId,
        'date': date
      };
}
