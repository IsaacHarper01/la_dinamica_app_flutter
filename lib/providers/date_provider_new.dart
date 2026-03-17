import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/date_model.dart';

final dateProviderNew = StateNotifierProvider<DateRangeNotifier, DateModel>(
    (ref) => DateRangeNotifier(ref),
);

class DateRangeNotifier extends StateNotifier<DateModel>{
  final Ref ref;

  DateRangeNotifier(this.ref) : super(
    DateModel(
      today: DateTime.now().toString().split(' ')[0], 
      start: DateTime.now().subtract(Duration(days: DateTime.now().day)), 
      end: DateTime.now())
    );

  void setToday(String newDate){
    final current = state;
    state = current.copyWith(today: newDate);
    safePrint("TEST: ${state.today}");
  }

  void setStart(DateTime newStart){
    state = state.copyWith(start: newStart);
    safePrint("TEST START: ${state.start}");
  }

  void setEnd(DateTime newEnd){
    final current = state;
    state = current.copyWith(end: newEnd);
    safePrint("TEST END: ${state.end}");
  } 
}