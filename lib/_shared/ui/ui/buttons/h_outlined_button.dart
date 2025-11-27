import 'package:flutter/material.dart';
import 'package:hemo/_shared/ui/theme/h_colors.dart';
import 'package:hemo/_shared/ui/ui/loading_indicator.dart';

class HOutlinedButton extends StatelessWidget {
  const HOutlinedButton(
    this.label, {
    this.icon,
    this.onPressed,
    this.enabled = true,
    this.isLoading = false,
    this.iconAlignment,
    this.backgroundColor,
    this.foregroundColor = HColors.primary,
    this.iconColor,
    super.key,
  });

  final String label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final IconAlignment? iconAlignment;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        iconColor: iconColor ?? foregroundColor,
      ),
      onPressed: isLoading || !enabled ? null : onPressed,
      label: isLoading ? const LoadingIndicator() : Text(label),
      icon: isLoading ? null : icon,
      iconAlignment: iconAlignment,
    );
  }
}
