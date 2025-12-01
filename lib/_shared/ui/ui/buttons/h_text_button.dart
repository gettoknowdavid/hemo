import 'package:flutter/material.dart';
import 'package:hemo/_shared/ui/ui/loading_indicator.dart';

class HTextButton extends StatelessWidget {
  const HTextButton(
    this.label, {
    this.icon,
    this.onPressed,
    this.enabled = true,
    this.isLoading = false,
    this.iconAlignment,
    this.style,
    super.key,
  });

  final String label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final IconAlignment? iconAlignment;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: isLoading || !enabled ? null : onPressed,
      label: isLoading ? const LoadingIndicator() : Text(label),
      icon: isLoading ? null : icon,
      iconAlignment: iconAlignment,
      style: style,
    );
  }
}
