import 'package:la_dinamica_app/models/ModelProvider.dart';

class IncomeState {
  final List<Payment> listPlanIncome;
  final List<Sale> listProductIncome;
  final double? dayPlanIncome;
  final double? dayProductIncome;
  final double? planIncome;
  final double? productIncome;

  IncomeState({
    required this.listPlanIncome,
    required this.listProductIncome,
    this.dayPlanIncome,
    this.dayProductIncome,
    this.planIncome,
    this.productIncome
  });

  IncomeState copyWith({
    List<Payment>? listPlanIncome,
    List<Sale>? listProductIncome,
    double? dayPlanIncome,
    double? dayProductIncome,
    double? planIncome,
    double? productIncome,
  }){
    return IncomeState(
      listPlanIncome: listPlanIncome ?? this.listPlanIncome, 
      listProductIncome: listProductIncome ?? this.listProductIncome, 
      dayPlanIncome: dayPlanIncome ?? this.dayPlanIncome,
      dayProductIncome: dayProductIncome ?? this.dayProductIncome,
      planIncome: planIncome ?? this.planIncome, 
      productIncome: productIncome?? this.productIncome);
  }
}

