import 'package:flutter/material.dart';

class CustomSizedBox extends StatelessWidget {
 final double? width;
 final double? height;
 final Widget? child;

  const CustomSizedBox({super.key,
   this.height,
   this.child,
   this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: child,
    );
  }
}
