import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final inputTheme = Theme.of(context).inputDecorationTheme;
    final inputDecoration = InputDecoration(
      hintText: widget.hint,
      filled: inputTheme.filled,
      fillColor: inputTheme.fillColor,
      contentPadding: inputTheme.contentPadding,
      isDense: inputTheme.isDense,
      hintStyle: inputTheme.hintStyle,
      prefixIconConstraints: inputTheme.prefixIconConstraints,
      suffixIconConstraints: inputTheme.suffixIconConstraints,
      visualDensity: VisualDensity.compact,
    );

    return Column(
      crossAxisAlignment: .stretch,
      mainAxisSize: .min,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: HTextStyles.label),
          6.verticalSpace,
        ],
        InternationalPhoneNumberInput(
          textFieldController: widget.controller,
          onInputValidated: (value) => setState(() => _isValidNumber = value),
          inputDecoration: inputDecoration,
          searchBoxDecoration: inputDecoration.copyWith(
            hintText: 'Search by country name or dial code',
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
          inputBorder: inputTheme.border,
        ),
      ],
    );
  }
}
