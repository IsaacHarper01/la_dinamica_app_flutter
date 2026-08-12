import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:la_dinamica_app/model/UserLocal.dart';
import 'package:la_dinamica_app/models/ModelProvider.dart';
import 'package:la_dinamica_app/screens/daily_ledger_screen.dart';

void main() {
  testWidgets('daily ledger screen shows the daily ledger title', (tester) async {
    final user = UserLocal(
      user: User(user_id: '1', name: 'Admin'),
      name: 'Admin',
      tenant: Tenant(tenant_id: 'tenant-1', name: 'Gym', plan: 'standard', status: true),
      permissions: const {'deletePayments': true},
      userAccess: const [],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: DailyLedgerScreen(user: user),
        ),
      ),
    );

    expect(find.text('Resumen del día'), findsOneWidget);
  });
}
