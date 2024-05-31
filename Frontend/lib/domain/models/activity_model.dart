class Activity {
  final String user;
  final String name;
  final String date;
  final String time;
  final List<String> logs;
  final String? id; // Make id optional

  Activity({
    required this.user,
    required this.name,
    required this.date,
    required this.time,
    required this.logs,
    this.id, // id is optional
  });

  Activity copyWith({
    String? user,
    String? name,
    String? date,
    String? time,
    List<String>? logs,
    String? id,
  }) {
    return Activity(
      user: user ?? this.user,
      name: name ?? this.name,
      date: date ?? this.date,
      time: time ?? this.time,
      logs: logs ?? this.logs,
      id: id ?? this.id,
    );
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      user: json['user'],
      name: json['name'],
      date: json['date'],
      time: json['time'],
      logs: List<String>.from(json['logs']),
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'user': user,
      'name': name,
      'date': date,
      'time': time,
      'logs': logs,
    };
    if (id != null) {
      data['_id'] = id!;
    }
    return data;
  }
}