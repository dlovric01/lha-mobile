// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'home_page.dart' show LHAEnum;

class ControlSection extends StatelessWidget {
  final Future<void> Function(LHAEnum) onToggle;

  const ControlSection({super.key, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 5, bottom: 8),
            child: Text(
              'Kontrole',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _ControlButton(
                  label: 'Lijeva garaža',
                  icon: Icons.garage,
                  onTap: () async => onToggle(LHAEnum.garageLeft),
                ),
              ),
              Expanded(
                child: _ControlButton(
                  label: 'Desna garaža',
                  icon: Icons.garage,
                  onTap: () async => onToggle(LHAEnum.garageRight),
                ),
              ),
            ],
          ),
          _ControlButton(
            label: 'Kapija',
            icon: Icons.table_rows,
            fullWidth: true,
            onTap: () async => onToggle(LHAEnum.slidingGate),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Future<void> Function() onTap;
  final bool fullWidth;

  const _ControlButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.fullWidth = false,
  });

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: 2,
      margin: EdgeInsets.all(5),
      color: Colors.white.withOpacity(0.1), // Tamna s nijansom plave
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap:
            isLoading == false
                ? () {
                  setState(() {
                    isLoading = true;
                  });
                  widget.onTap().then((value) {
                    setState(() {
                      isLoading = false;
                    });
                  });
                }
                : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: isLoading ? Colors.yellow : Colors.white60,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: isLoading ? Colors.yellow : Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return widget.fullWidth
        ? SizedBox(width: double.infinity, child: card)
        : card;
  }
}
