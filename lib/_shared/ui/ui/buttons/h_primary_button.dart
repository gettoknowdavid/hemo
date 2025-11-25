import 'package:flutter/material.dart';
import 'package:hemo/_shared/ui/ui/loading_indicator.dart';

class HPrimaryButton extends StatelessWidget {
  const HPrimaryButton(
    this.label, {
    this.icon,
    this.onPressed,
    this.enabled = true,
    this.isLoading = false,
    this.iconAlignment,
    super.key,
  });

  final String label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final IconAlignment? iconAlignment;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: isLoading || !enabled ? null : onPressed,
      label: isLoading ? const LoadingIndicator() : Text(label),
      icon: isLoading ? null : icon,
      iconAlignment: iconAlignment,
    );
  }
}
