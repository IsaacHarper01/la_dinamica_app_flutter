class FinancialModel<T> {
  final List<T> rangelist;
  final List<T> dayList;
  final double totalDay;
  final double totalRange;

  FinancialModel({
    this.rangelist = const [],
    this.dayList = const [],
    this.totalDay = 0.0,
    this.totalRange = 0.0,
  });

  factory FinancialModel.empty() {
    return FinancialModel(
      rangelist: const [],
      dayList: const [],
      totalDay: 0.0,
      totalRange: 0.0,
    );
  }

  FinancialModel<T> copyWith({
    List<T>? rangelist,
    List<T>? dayList,
    double? totalDay,
    double? totalRange,
  }){
    return FinancialModel(
      rangelist: rangelist ?? this.rangelist, 
      dayList: dayList ?? this.dayList,
      totalDay: totalDay ?? this.totalDay,
      totalRange: totalRange ?? this.totalRange,
      );
  }
}