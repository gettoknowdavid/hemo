import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hemo/_shared/ui/theme/h_colors.dart';
import 'package:hemo/_shared/ui/theme/h_text_styles.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class HPhoneNumberField extends StatefulWidget {
  const HPhoneNumberField({
    this.label,
    this.hint,
    this.controller,
    this.enabled = true,
    this.validator,
    this.initialValue,
    this.onChanged,
    super.key,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool enabled;
  final String? Function(String?)? validator;
  final PhoneNumber? initialValue;
  final void Function(PhoneNumber)? onChanged;

  @override
  State<HPhoneNumberField> createState() => _HPhoneNumberFieldState();
}

class _HPhoneNumberFieldState extends State<HPhoneNumberField> {
  bool _isValidNumber = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        InternationalPhoneNumberInput(
          textFieldController: widget.controller,
          onInputValidated: (value) => setState(() => _isValidNumber = value),
          inputDecoration: InputDecoration(
            hintText: widget.hint,
            filled: true,
            fillColor: WidgetStateColor.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) return HColors.gray3;
              return Colors.white;
            }),
            contentPadding: const EdgeInsets.fromLTRB(12, 10, 12, 10).r,
            hintStyle: TextStyle(
              color: HColors.gray2,
              fontFamily: HTextStyles.fontFamily,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              height: (18 / 13).h,
              letterSpacing: -0.02.w,
            ),
          ),
          isEnabled: widget.enabled,
          initialValue: widget.initialValue,
          onInputChanged: widget.onChanged,
          textStyle: TextStyle(
            fontFamily: HTextStyles.fontFamily,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          validator: (String? i) {
            if (i == null || i.isEmpty) return 'Mobile Number is required';
            if (!_isValidNumber) return 'Please enter a valid mobile number';
            return null;
          },
          autoValidateMode: AutovalidateMode.onUserInteraction,
          selectorTextStyle: TextStyle(
            fontFamily: HTextStyles.fontFamily,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          selectorConfig: const SelectorConfig(
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            setSelectorButtonAsPrefixIcon: true,
            showFlags: false,
            leadingPadding: 0,
            trailingSpace: false,
          ),
          inputBorder: WidgetStateInputBorder.resolveWith(
            (states) {
              final defaultBorder = OutlineInputBorder(
                borderRadius: const BorderRadius.all(.circular(6)).r,
                borderSide: BorderSide(color: HColors.gray3, width: 1.w),
              );

              if (states.contains(WidgetState.focused)) {
                return defaultBorder.copyWith(
                  borderSide: BorderSide(color: HColors.primary, width: 2.w),
                );
              }

              return defaultBorder;
            },
          ),
        ),
      ],
    );
  }
}
