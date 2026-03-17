class DateModel {
  final String today;
  final DateTime start;
  final DateTime end;

  DateModel({
    required this.today,
    required this.start,
    required this.end,
  });

  DateModel copyWith({
    String? today,
    DateTime? start,
    DateTime? end,
  }){
    return DateModel(
      today: today ?? this.today,
      start: start ?? this.start, 
      end: end ?? this.end,
      );
  }
}