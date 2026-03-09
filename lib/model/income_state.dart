import 'package:la_dinamica_app/models/ModelProvider.dart';

class IncomeState {
  final List<Payment> listPlanIncome;
  final List<Sale> listProductIncome;
  final double? planIncome;
  final double? productIncome;

  IncomeState({
    required this.listPlanIncome,
    required this.listProductIncome,
    this.planIncome,
    this.productIncome
  });

  IncomeState copyWith({
    List<Payment>? listPlanIncome,
    List<Sale>? listProductIncome,
    double? planIncome,
    double? productIncome,
  }){
    return IncomeState(
      listPlanIncome: listPlanIncome ?? this.listPlanIncome, 
      listProductIncome: listProductIncome ?? this.listProductIncome, 
      planIncome: planIncome ?? this.planIncome, 
      productIncome: productIncome?? this.productIncome);
  }
}

