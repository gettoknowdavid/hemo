import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hemo/_features/profile/_managers/profile_setup_manager.dart';
import 'package:hemo/_shared/services/models/gender.dart';
import 'package:hemo/_shared/ui/ui.dart';
import 'package:hemo/_shared/utils/validators.dart';
import 'package:hemo/routing/routes.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProfileSetupPage2 extends WatchingStatefulWidget {
  const ProfileSetupPage2({super.key});

  @override
  State<ProfileSetupPage2> createState() => _ProfileSetupPage2State();
}

class _ProfileSetupPage2State extends State<ProfileSetupPage2> {
  final ProfileSetupManager _manager = di<ProfileSetupManager>();
  final _formKey = GlobalKey<FormState>();

  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _manager.dateOfBirth.listen((value, _) {
      if (value == null) return;
      final formattedDate = DateFormat.yMd().format(value);
      _dateController.text = formattedDate;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isValid = watchValue((ProfileSetupManager m) => m.isValid);
    final age = watchValue((ProfileSetupManager m) => m.age);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20).r,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: .stretch,
                    children: [
                      Text('Profile Setup', style: HTextStyles.pageTitle),
                      10.verticalSpace,
                      Text(
                        '''It's optional. You can fill these information later. Go to the next step by tapping the Skip button.''',
                        style: HTextStyles.subtitle,
                      ),
                      Divider(height: 40.h, color: HColors.gray1),
                      HAvatar(
                        radius: 32.r,
                        placeholder: const Icon(
                          PhosphorIconsRegular.eyeglasses,
                        ),
                      ),
                      8.verticalSpace,
                      Text(
                        'Basic Information',
                        style: HTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      16.verticalSpace,
                      HTextField(
                        label: 'Date of Birth',
                        hint: 'Select Date',
                        readOnly: true,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 12).r,
                          child: const Icon(
                            Icons.calendar_month,
                            color: HColors.gray2,
                          ),
                        ),
                        controller: _dateController,
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            initialDate: DateTime.now(),
                          );
                          if (pickedDate == null) return;
                          _manager.onDateOfBirthChanged(pickedDate);
                        },
                      ),
                      if (age != null) ...[
                        2.verticalSpace,
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text('Your age - $age'),
                        ),
                      ],
                      16.verticalSpace,
                      Text('Gender', style: HTextStyles.label),
                      6.verticalSpace,
                      DropdownMenuFormField(
                        requestFocusOnTap: true,
                        alignmentOffset: Offset(0, 8.h),
                        menuHeight: 0.3.sh,
                        enableSearch: false,
                        expandedInsets: .zero,
                        hintText: 'Select Gender',
                        selectedTrailingIcon: const Icon(
                          Icons.keyboard_arrow_up,
                        ),
                        trailingIcon: const Icon(Icons.keyboard_arrow_down),
                        dropdownMenuEntries: Gender.values.map((gender) {
                          return DropdownMenuEntry(
                            value: gender,
                            label: gender.name,
                          );
                        }).toList(),
                        onSelected: _manager.onGenderChanged,
                      ),
                      16.verticalSpace,
                      Text('I want to donate blood', style: HTextStyles.label),
                      6.verticalSpace,
                      DropdownMenuFormField<bool?>(
                        requestFocusOnTap: true,
                        alignmentOffset: Offset(0, 8.h),
                        menuHeight: 0.3.sh,
                        expandedInsets: .zero,
                        enableSearch: false,
                        hintText: 'Yes or No',
                        selectedTrailingIcon: const Icon(
                          Icons.keyboard_arrow_up,
                        ),
                        trailingIcon: const Icon(Icons.keyboard_arrow_down),
                        dropdownMenuEntries: ['Yes', 'No'].map((value) {
                          return DropdownMenuEntry(
                            label: value,
                            value: switch (value) {
                              'Yes' => true,
                              'No' => false,
                              _ => null,
                            },
                          );
                        }).toList(),
                        onSelected: _manager.onIWantToDonateChanged,
                      ),
                      16.verticalSpace,
                      HTextField(
                        label: 'About Yourself',
                        hint: 'Tell us about yourself',
                        validator: HValidators.maxLengthExceeded,
                        maxLines: 6,
                        onChanged: _manager.onBioChanged,
                      ),
                      32.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
            4.verticalSpace,
            HPrimaryButton(
              'Next',
              enabled: isValid,
              onPressed: () async {
                if (_formKey.currentState?.validate() == false) return;
                _manager.printState();
                await context.push(Routes.profileSetup3);
              },
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}
