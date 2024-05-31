// class Note{
//   int index;
//   String title;
//   String body;

//   Note({required this.title, required this.body, required this.index});
// }
class Note {
  final int index;
   String title;
   String body;
   final String userId;

  Note({
    required this.title,
    required this.body,
    required this.index,
    required this.userId,
  });

  Note copyWith({
    String? title,
    String? body,
    int? index,
    String? userId,
  }) {
    return Note(
      title: title ?? this.title,
      body: body ?? this.body,
      index: index ?? this.index,
      userId: userId ?? this.userId
    );
  }
}
