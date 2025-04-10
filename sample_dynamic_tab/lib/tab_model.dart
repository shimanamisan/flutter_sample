class TabModel {
  final String id;
  final String title;

  TabModel({
    required this.id,
    required this.title,
  });

  TabModel copyWith({
    String? title,
  }) {
    return TabModel(
      id: id,
      title: title ?? this.title,
    );
  }
}
