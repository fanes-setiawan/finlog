import 'package:finlog/src/commons/constants/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NumericKeyboard extends StatelessWidget {
  final Function(String) onKeyboardTap;
  final VoidCallback onBackspace;

  const NumericKeyboard({
    super.key,
    required this.onKeyboardTap,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundLight,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Fix full screen issue
        children: [
          Row(
            children: [
              _buildButton("1"),
              _buildButton("2"),
              _buildButton("3"),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildButton("4"),
              _buildButton("5"),
              _buildButton("6"),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildButton("7"),
              _buildButton("8"),
              _buildButton("9"),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildButton(","), // Decimal separator for IDR
              _buildButton("0"),
              _buildIcon(Icons.backspace_outlined, onBackspace),
            ],
          ),
          const SizedBox(height: 12),
          // Shortcuts Row
          Row(
            children: [
              _buildButton("00"),
              _buildButton("000"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text) {
    return Expanded(
      child: InkWell(
        onTap: () => onKeyboardTap(text),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 50, // Reduced height for compactness
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.grey800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.grey200, // Different color for functional keys
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: Icon(icon, color: AppColors.grey800, size: 24),
        ),
      ),
    );
  }
}
