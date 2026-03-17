class FinacialModel<T> {
  final List<T>? rangelist;
  final List<T>? dayList;
  final double? totalDay;
  final double? totalRange;

  FinacialModel({
    this.rangelist,
    this.dayList,
    this.totalDay,
    this.totalRange,
  });

  FinacialModel copyWith({
    List<T>? rangelist,
    List<T>? dayList,
    double? totalDay,
    double? totalRange,
  }){
    return FinacialModel(
      rangelist: rangelist ?? this.rangelist, 
      dayList: dayList ?? this.dayList,
      totalDay: totalDay ?? this.totalDay,
      totalRange: totalRange ?? this.totalRange,
      );
  }
}