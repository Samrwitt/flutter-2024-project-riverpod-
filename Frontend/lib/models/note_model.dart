// class Note{
//   int index;
//   String title;
//   String body;

//   Note({required this.title, required this.body, required this.index});
// }
class Note {
  final int index;
  final String title;
  final String body;

  Note({
    required this.title,
    required this.body,
    required this.index,
  });

  Note copyWith({
    String? title,
    String? body,
    int? index,
  }) {
    return Note(
      title: title ?? this.title,
      body: body ?? this.body,
      index: index ?? this.index
    );
  }
}
