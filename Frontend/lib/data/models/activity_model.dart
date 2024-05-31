class Activity {
  final String user;
  final String name;
  final String date;
  final String time;
  final List<String> logs;

  Activity({
    required this.user,
    required this.name,
    required this.date,
    required this.time,
    this.logs = const [],
  });

  Activity copyWith({
    String? user,
    String? name,
    String? date,
    String? time,
    List<String>? logs,
  }) {
    return Activity(
      user: user ?? this.user,
      name: name ?? this.name,
      date: date ?? this.date,
      time: time ?? this.time,
      logs: logs ?? this.logs,
    );
  }
}
