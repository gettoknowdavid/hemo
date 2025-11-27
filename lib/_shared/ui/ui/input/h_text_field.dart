import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hemo/_shared/ui/theme/h_colors.dart';
import 'package:hemo/_shared/ui/theme/h_text_styles.dart';

class HTextField extends StatefulWidget {
  const HTextField({
    this.label,
    this.hint,
    this.controller,
    this.enabled = true,
    this.validator,
    this.obscureText = false,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    this.keyboardType,
    this.textInputAction,
    this.readOnly = false,
    this.onChanged,
    this.onTap,
    this.inputFormatters,
    super.key,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool enabled;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool isPassword;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? initialValue;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool readOnly;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<HTextField> createState() => _HTextFieldState();
}

class _HTextFieldState extends State<HTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText || widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    var suffixIcon = widget.suffixIcon;
    if (widget.isPassword) {
      suffixIcon = IconButton(
        iconSize: 18.sp,
        color: HColors.gray2,
        onPressed: () => setState(() => _obscure = !_obscure),
        icon: _obscure
            ? const Icon(Icons.visibility)
            : const Icon(Icons.visibility_off),
      );
    }

    return Column(
      crossAxisAlignment: .stretch,
      mainAxisSize: .min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 14.sp,
              height: (20 / 14).h,
              fontFamily: HTextStyles.fontFamily,
              fontWeight: FontWeight.w500,
            ),
          ),
          9.verticalSpace,
        ],
        TextFormField(
          controller: widget.controller,
          cursorHeight: 20.h,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            suffixIcon: suffixIcon,
          ),
          enabled: widget.enabled,
          initialValue: widget.initialValue,
          inputFormatters: widget.inputFormatters,
          keyboardType: widget.keyboardType,
          obscureText: _obscure,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          style: TextStyle(
            fontFamily: HTextStyles.fontFamily,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          textInputAction: widget.textInputAction,
          validator: widget.validator,
        ),
      ],
    );
  }
}
