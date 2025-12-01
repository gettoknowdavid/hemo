import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_it/flutter_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hemo/_features/profile/_managers/profile_setup_manager.dart';
import 'package:hemo/_shared/services/image_picker_service.dart';
import 'package:hemo/_shared/ui/ui.dart';
import 'package:hemo/_shared/utils/validators.dart';
import 'package:hemo/routing/routes.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProfileSetupPage3 extends WatchingStatefulWidget {
  const ProfileSetupPage3({super.key});

  @override
  State<ProfileSetupPage3> createState() => _ProfileSetupPage3State();
}

class _ProfileSetupPage3State extends State<ProfileSetupPage3> {
  final ProfileSetupManager _manager = di<ProfileSetupManager>();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _manager.submit.errors.listen((error, _) {
      if (error == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.error.toString())),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isValid = watchValue((ProfileSetupManager m) => m.isValid);
    final isSubmitting = watchValue(
      (ProfileSetupManager m) => m.submit.isRunning,
    );

    registerHandler(
      select: (ProfileSetupManager m) => m.submit,
      handler: (context, value, cancel) {
        if (!value) {
          log('QWERTYUIOPQWERTYUIOPQWERTYUIOPQWERTYUIOP');
        } else {
          context.go(Routes.home);
        }
      },
    );

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
                        placeholder: const Icon(PhosphorIconsRegular.user),
                      ),
                      8.verticalSpace,
                      Text(
                        'Upload Your Image',
                        style: HTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      32.verticalSpace,
                      const _ImageField(),
                      32.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
            4.verticalSpace,
            HPrimaryButton(
              'Submit',
              enabled: isValid,
              isLoading: isSubmitting,
              onPressed: () async {
                if (_formKey.currentState?.validate() == false) return;
                _manager.submit.run();
              },
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}

class _ImageField extends WatchingStatefulWidget {
  const _ImageField();

  @override
  State<_ImageField> createState() => _ImageFieldState();
}

class _ImageFieldState extends State<_ImageField> {
  File? _selectedFile;

  @override
  Widget build(BuildContext context) {
    final hasFile = _selectedFile != null;

    return FormField<File>(
      validator: HValidators.imageFile,
      builder: (state) => Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        children: [
          InkWell(
            onTap: () async {
              final source = await ImageSourceModal.show(context);
              if (source == null) return;

              final image = await di<ImagePickerService>().getImage(
                source,
              );
              if (image == null) return;

              final file = File(image.path);
              state.didChange(file);
              setState(() => _selectedFile = file);
              di<ProfileSetupManager>().onImageChanged(file);
            },
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: hasFile
                      ? Border.all(color: HColors.gray2, width: 2.w)
                      : Border.all(color: HColors.gray1, width: 2.w),
                  image: hasFile
                      ? DecorationImage(
                          image: FileImage(_selectedFile!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: hasFile
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: 32.r,
                          width: 32.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white24,
                          ),
                          margin: const EdgeInsets.all(8).r,
                          child: Icon(
                            PhosphorIconsFill.image,
                            size: 18.sp,
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: .center,
                        children: [
                          Icon(
                            PhosphorIconsFill.image,
                            size: 32.sp,
                            color: HColors.gray2,
                          ),
                          8.verticalSpace,
                          const Text('Upload your profile image'),
                        ],
                      ),
              ),
            ),
          ),
          4.verticalSpace,
          if (state.hasError && state.errorText != null)
            Text(
              state.errorText!,
              style: HTextStyles.bodyMedium.copyWith(color: Colors.red),
            )
          else
            Row(
              children: [
                Text('Upload up to 5 MB', style: HTextStyles.label),
                if (hasFile) ...[
                  const Spacer(),
                  HTextButton(
                    'Remove image',
                    style: TextButton.styleFrom(
                      foregroundColor: HColors.primary,
                    ),
                    onPressed: () {
                      state.didChange(null);
                      setState(() => _selectedFile = null);
                      di<ProfileSetupManager>().onImageChanged(null);
                    },
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}
