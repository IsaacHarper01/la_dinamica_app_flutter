import 'package:flutter/material.dart';

class UpdatePaymentStatusDialog extends StatelessWidget {
  const UpdatePaymentStatusDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Pago pendiente"),
      content: const Text(
        "Tu suscripción no está activa. Realiza el pago correspondiente y notifica a tu proveedor",
      ),
    );
  }
}