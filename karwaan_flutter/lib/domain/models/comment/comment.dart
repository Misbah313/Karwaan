class Comment {
  final int? id;
  final String content;
  final int? author;

  Comment({required this.id, required this.content, required this.author});

  Comment copyWith({int? id, String? content, int? author}) {
    return Comment(
        id: id ?? this.id,
        content: content ?? this.content,
        author: author ?? this.author);
  }
}
