import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DropOrderShimmer extends StatelessWidget {
  const DropOrderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 8,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 8,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                width: double.infinity,
                color: Colors.grey,
                height: MediaQuery.of(context).size.height / 15),
            SizedBox(
              height: 20,
            ),
            Container(
                width: double.infinity,
                color: Colors.grey,
                height: MediaQuery.of(context).size.height / 15),
            SizedBox(
              height: 20,
            ),
            Container(
                width: double.infinity,
                color: Colors.grey,
                height: MediaQuery.of(context).size.height / 15),
            SizedBox(
              height: 20,
            ),
            Container(
                width: double.infinity,
                color: Colors.grey,
                height: MediaQuery.of(context).size.height / 15),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 40,
              width: double.infinity,
              color: Colors.grey,
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
