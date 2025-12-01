import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hemo/_features/profile/_managers/profile_setup_manager.dart';
import 'package:hemo/_shared/services/models/blood_group.dart';
import 'package:hemo/_shared/ui/theme/theme.dart';
import 'package:hemo/_shared/ui/ui/ui.dart';
import 'package:hemo/_shared/utils/validators.dart';
import 'package:hemo/routing/routes.dart';

class ProfileSetupPage1 extends WatchingStatefulWidget {
  const ProfileSetupPage1({super.key});

  @override
  State<ProfileSetupPage1> createState() => _ProfileSetupPage1();
}

class _ProfileSetupPage1 extends State<ProfileSetupPage1> {
  final ProfileSetupManager _manager = di<ProfileSetupManager>();
  final _formKey = GlobalKey<FormState>();

  final _countryController = TextEditingController();
  final _provinceController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _manager.country.listen((value, _) {
      _countryController.text = value?.name ?? '';
    });

    _manager.province.listen((value, _) {
      _provinceController.text = value?.name ?? '';
    });

    _manager.city.listen((value, _) {
      _cityController.text = value?.name ?? '';
    });
  }

  @override
  void dispose() {
    _countryController.dispose();
    _provinceController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isValid = watchValue((ProfileSetupManager m) => m.isValid);
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
                        '''Almost done :) Now, to setup your profile, please complete the form below with accurate information. It's easy and just three steps.''',
                        style: HTextStyles.subtitle,
                      ),
                      Divider(height: 40.h, color: HColors.gray1),
                      HAvatar(radius: 32.r),
                      8.verticalSpace,
                      Text(
                        'Personal Information',
                        style: HTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      16.verticalSpace,
                      HTextField(
                        label: 'Your Name',
                        hint: 'John Doe',
                        validator: HValidators.name,
                        onChanged: _manager.onNameChanged,
                      ),
                      16.verticalSpace,
                      HPhoneNumberField(
                        label: 'Mobile Number',
                        hint: '01-234-5678',
                        validator: HValidators.phoneNumber,
                        onChanged: _manager.onPhoneNumberChanged,
                      ),
                      16.verticalSpace,
                      Text('Blood Group', style: HTextStyles.label),
                      6.verticalSpace,
                      DropdownMenuFormField(
                        requestFocusOnTap: true,
                        alignmentOffset: Offset(0, 8.h),
                        menuHeight: 0.3.sh,
                        expandedInsets: .zero,
                        hintText: 'Select Blood Group',
                        selectedTrailingIcon: const Icon(
                          Icons.keyboard_arrow_up,
                        ),
                        trailingIcon: const Icon(Icons.keyboard_arrow_down),
                        dropdownMenuEntries: BloodGroup.uiValues.map((group) {
                          return DropdownMenuEntry(
                            value: group,
                            label: group.name,
                          );
                        }).toList(),
                        onSelected: _manager.onBloodChanged,
                        validator: HValidators.bloodGroup,
                      ),
                      16.verticalSpace,
                      HTextField(
                        label: 'Country',
                        hint: 'Select Country',
                        readOnly: true,
                        controller: _countryController,
                        validator: (input) =>
                            HValidators.required(input, 'Country'),
                        onTap: () async {
                          final result = await CountriesModal.show(context);
                          _manager.onCountryChanged(result);
                        },
                      ),
                      16.verticalSpace,
                      HTextField(
                        label: 'State',
                        hint: 'Select State',
                        readOnly: true,
                        controller: _provinceController,
                        validator: (input) =>
                            HValidators.required(input, 'State'),
                        onTap: () async {
                          final countryId = _manager.country.value?.id;
                          if (countryId == null) return;

                          final result = await StatesModal.show(
                            context,
                            countryId,
                          );
                          _manager.onProvinceChanged(result);
                        },
                      ),
                      16.verticalSpace,
                      HTextField(
                        label: 'City',
                        hint: 'Select City',
                        readOnly: true,
                        controller: _cityController,
                        validator: (input) =>
                            HValidators.required(input, 'City'),
                        onTap: () async {
                          final province = _manager.province.value;
                          if (province == null) return;
                          final params = (province.countryId, province.id);

                          final result = await CitiesModal.show(
                            context,
                            params,
                          );
                          _manager.onCityChanged(result);
                        },
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
                await context.push(Routes.profileSetup2);
              },
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}
