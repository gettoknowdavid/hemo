import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hemo/_shared/ui/theme/theme.dart';
import 'package:pinput/pinput.dart';

class HPinField extends StatefulWidget {
  const HPinField({
    this.enabled = true,
    this.length = 6,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    super.key,
    this.controller,
    this.onChanged,
    this.onCompleted,
    this.smsRetriever,
    this.validator,
    this.autofocus = false,
  });

  final int length;
  final TextEditingController? controller;
  final bool enabled;
  final void Function(String)? onCompleted;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final SmsRetriever? smsRetriever;
  final bool obscureText;
  final String obscuringCharacter;
  final bool autofocus;

  @override
  State<HPinField> createState() => _HPinFieldState();
}

class _HPinFieldState extends State<HPinField> {
  @override
  Widget build(BuildContext context) {
    final defaultDecoration = BoxDecoration(
      borderRadius: const BorderRadius.all(.circular(8)).r,
      border: Border.all(width: 1.w, color: HColors.gray3),
      color: HColors.surface,
    );

    final defaultPinTheme = PinTheme(
      decoration: defaultDecoration,
      height: 46.r,
      width: 46.r,
      textStyle: HTextStyles.title.copyWith(fontWeight: FontWeight.w600),
    );

    return Pinput(
      autofocus: widget.autofocus,
      length: widget.length,
      smsRetriever: widget.smsRetriever,
      enabled: widget.enabled,
      controller: widget.controller,
      onCompleted: widget.onCompleted,
      onChanged: widget.onChanged,
      validator: widget.validator,
      obscureText: widget.obscureText,
      obscuringCharacter: widget.obscuringCharacter,
      cursor: Container(height: 18.h, width: 2.w, color: HColors.primary),
      defaultPinTheme: defaultPinTheme,
      disabledPinTheme: defaultPinTheme.copyWith(
        decoration: defaultDecoration.copyWith(color: HColors.gray3),
      ),
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultDecoration.copyWith(
          border: Border.all(width: 2.w, color: HColors.primary),
        ),
      ),
      errorTextStyle: HTextStyles.bodyMedium.copyWith(
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
