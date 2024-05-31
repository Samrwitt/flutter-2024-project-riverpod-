class Note {
  final String? id; // MongoDB ObjectId as a String, optional
  final String title;
  final String content; 
  final String userId;
  final int index;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.userId,
    required this.index,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['_id'] as String?, // Ensure this matches MongoDB's ObjectId
      title: json['title'] as String,
      content: json['content'] as String,
      userId: json['userId'] as String,
      index: json['index'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'title': title,
      'content': content,
      'userId': userId,
      'index': index,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
    if (id != null) {
      data['_id'] = id!; // Ensure the field is named _id to match MongoDB's convention
    }
    return data;
  }

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? userId,
    int? index,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      userId: userId ?? this.userId,
      index: index ?? this.index,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}