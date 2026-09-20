import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/model/finacial_model.dart';
import 'package:la_dinamica_app/providers/create_queries_aws.dart';
import 'package:la_dinamica_app/providers/date_provider_new.dart';
import 'package:la_dinamica_app/providers/read_queries_aws.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';

final extraPayProvider = StateNotifierProvider<
  ExtraPayNotifier,
  AsyncValue<FinancialModel<ExtraPay>>
>((ref) => ExtraPayNotifier(ref));

class ExtraPayNotifier
    extends StateNotifier<AsyncValue<FinancialModel<ExtraPay>>> {
  final Ref ref;
  final DataStoreReadService aws = DataStoreReadService();
  final DataStoreService awsSave = DataStoreService();

  ExtraPayNotifier(this.ref) : super(const AsyncValue.loading()) {
    setAllExtraPays();
  }

  Future<void> setAllExtraPays() async {
    try {
      await setTodayExtraPays();
      await setRangeExtraPays();
    } catch (error, stackTrace) {
      if (mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  Future<void> setTodayExtraPays() async {
    try {
      final pays = await aws.getTodayExtraPays(ref.read(dateProvider).today);
      final current = state.value ?? FinancialModel<ExtraPay>();
      state = AsyncData(
        current.copyWith(
          dayList: pays,
          totalDay: pays.fold<double>(0, (sum, pay) => sum + (pay.amount ?? 0)),
        ),
      );
    } catch (error, stackTrace) {
      if (mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  Future<void> setRangeExtraPays() async {
    try {
      final date = ref.read(dateProvider);
      final pays = await aws.getExtraPaysRange(date.start, date.end);
      final current = state.value ?? FinancialModel<ExtraPay>();
      state = AsyncData(
        current.copyWith(
          rangelist: pays,
          totalRange: pays.fold<double>(
            0,
            (sum, pay) => sum + (pay.amount ?? 0),
          ),
        ),
      );
    } catch (error, stackTrace) {
      if (mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  Future<void> addExtraPay({
    required double amount,
    required String category,
    required String profId,
  }) async {
    try {
      final savedPay = await awsSave.saveExtraPay(
        amount: amount,
        category: category,
        date: ref.read(dateProvider).today,
        profId: profId,
      );
      final current = state.value ?? FinancialModel<ExtraPay>();
      state = AsyncData(
        current.copyWith(
          dayList: [...current.dayList, savedPay],
          totalDay: current.totalDay + (savedPay.amount ?? 0),
        ),
      );
    } catch (error, stackTrace) {
      if (mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
      rethrow;
    }
  }

  Future<void> updateExtraPay({
    required ExtraPay extraPay,
    required double amount,
    required String category,
  }) async {
    try {
      final updatedPay = await awsSave.updateExtraPay(
        extraPay: extraPay,
        amount: amount,
        category: category,
      );
      final current = state.value ?? FinancialModel<ExtraPay>();
      final updatedDayList =
          current.dayList
              .map((pay) => pay.id == updatedPay.id ? updatedPay : pay)
              .toList();
      final updatedRangeList =
          current.rangelist
              .map((pay) => pay.id == updatedPay.id ? updatedPay : pay)
              .toList();
      state = AsyncData(
        current.copyWith(
          dayList: updatedDayList,
          rangelist: updatedRangeList,
          totalRange: updatedRangeList.fold<double>(
            0,
            (sum, pay) => sum + (pay.amount ?? 0),
          ),
          totalDay: updatedDayList.fold<double>(
            0,
            (sum, pay) => sum + (pay.amount ?? 0),
          ),
        ),
      );
    } catch (error, stackTrace) {
      if (mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
      rethrow;
    }
  }
}
