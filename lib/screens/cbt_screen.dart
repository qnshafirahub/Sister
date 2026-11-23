import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class CbtScreen extends StatelessWidget {
  const CbtScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
          width: double.infinity,
          height: 82,
          color: AppColors.bg,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 20),
          child: const Text('CBT',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.dark)),
        ),
        Expanded(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              'assets/images/cbt.png',
              width: 335,
              errorBuilder: (_, __, ___) => const Icon(Icons.content_paste,
                  size: 120, color: AppColors.green),
            ),
            const SizedBox(height: 10),
            const Text('CBT Segera Hadir!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            const Text('Fitur CBT sedang kami siapkan, Tunggu sebentar, ya!',
                style: TextStyle(fontSize: 14, color: Colors.black54)),
          ]),
        ),
      ]),
    );
  }
}