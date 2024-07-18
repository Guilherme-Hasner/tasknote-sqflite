class Task {
  final int id;
  final String title;
  final String? description;
  final String dueTime;
  final String? lastAltered;
  final bool status;

  const Task(
      {required this.id,
      required this.title,
      this.description,
      required this.dueTime,
      this.lastAltered,
      required this.status});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        id: json['id'] as int,
        title: json['title'] as String,
        description: json['description'] ?? 'N/A',
        dueTime: json['dueTime'] as String,
        lastAltered: json['lastAltered'] as String,
        status: json['status'] == 0 ? false : true);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueTime': dueTime,
      'status': status == false ? 0 : 1,
    };
  }
}
