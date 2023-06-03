class Post {
  final String id;
  final String title;
  final String description;

  Post({
    required this.id,
    required this.title,
    required this.description,
  });

  Post copyWith({
    String? id,
    String? title,
    String? description,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}