import 'package:flutter/material.dart';
import '../core/app_colors.dart';

Future<T?> showAppModal<T>(BuildContext context,
    {required Widget child, bool dismissible = true}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: dismissible,
    barrierColor: Colors.black54,
    builder: (_) => Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    ),
  );
}

class PillButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool outline;
  final bool solid;
  const PillButton(this.label, this.onTap,
      {super.key, this.outline = false, this.solid = false});

  @override
  Widget build(BuildContext context) {
    final bg = solid
        ? AppColors.green
        : outline
            ? Colors.transparent
            : const Color(0xFFD9F3D3);
    final fg = solid ? Colors.white : AppColors.dark;
    return SizedBox(
      height: 36,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          shape: StadiumBorder(
              side: outline
                  ? const BorderSide(color: AppColors.dark)
                  : BorderSide.none),
        ),
        child: Text(label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
      ),
    );
  }
}

/// Dialog sukses: ikon centang, judul, pesan, dan tombol "Tutup".
class StatusModal extends StatelessWidget {
  final String title, message;
  final IconData icon;
  final Color iconColor;
  const StatusModal({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.check_circle,
    this.iconColor = AppColors.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 90, color: iconColor),
      const SizedBox(height: 10),
      Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      Text(message, textAlign: TextAlign.center),
      const SizedBox(height: 16),
      SizedBox(
          width: double.infinity,
          child: PillButton('Tutup', () => Navigator.pop(context), solid: true)),
    ]);
  }
}