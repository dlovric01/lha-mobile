// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'home_page.dart' show LHAEnum;

class ControlSection extends StatelessWidget {
  final Future<void> Function(LHAEnum) onToggle;

  const ControlSection({super.key, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ControlButton(
                label: 'Lijeva garaža',
                icon: Icons.garage,
                onTap: () => onToggle(LHAEnum.garageLeft),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ControlButton(
                label: 'Desna garaža',
                icon: Icons.garage,
                onTap: () => onToggle(LHAEnum.garageRight),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _ControlButton(
          label: 'Kapija',
          icon: Icons.table_rows,
          fullWidth: true,
          onTap: () => onToggle(LHAEnum.slidingGate),
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool fullWidth;

  const _ControlButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: 2,
      color:Colors.white.withOpacity(0.1), // Tamna s nijansom plave
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white60, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return fullWidth
        ? SizedBox(width: double.infinity, child: card)
        : card;
  }
}
