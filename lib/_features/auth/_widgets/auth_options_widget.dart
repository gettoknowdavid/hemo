import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hemo/_shared/ui/ui/buttons/h_secondary_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AuthOptionsWidget extends StatelessWidget {
  const AuthOptionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16.w,
      children: [
        Expanded(
          child: HSecondaryButton(
            'Facebook',
            icon: const Icon(PhosphorIconsFill.facebookLogo),
            onPressed: () {},
            foregroundColor: const Color(0xFF1778F2),
          ),
        ),
        Expanded(
          child: HSecondaryButton(
            'Google',
            icon: const Icon(PhosphorIconsFill.googleLogo),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
