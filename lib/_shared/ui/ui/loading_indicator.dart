import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({this.size, super.key});

  final Size? size;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size ?? Size(20.r, 20.r);
    return Center(
      child: SizedBox.fromSize(
        size: effectiveSize,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
