import 'package:flutter/material.dart';

class UpdatePaymentStatusScreen extends StatelessWidget {
  const UpdatePaymentStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDialog(
        title: const Text("Pago pendiente"),
        content: const Text(
          "Tu suscripción no está activa. Realiza el pago correspondiente y notifica a tu proveedor",
        ),
      ),
    );
  }
}