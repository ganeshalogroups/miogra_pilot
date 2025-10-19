
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';

class EmptyOrderDesign extends StatelessWidget {
  final String title;
  final String description;
  final String img;
  const EmptyOrderDesign(
      {super.key, required this.title, required this.description, required this.img});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomSizedBox(
              height: 80,
            ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(img))),
            ),
            CustomSizedBox(
              height: 40,
            ),
            Text(title, style: CustomTextStyle.googlebuttontext),
            Text(description,
                style: CustomTextStyle.blacktext)
          ],
        ),
      ),
    );
  }
}
