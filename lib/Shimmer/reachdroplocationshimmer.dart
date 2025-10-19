import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ReachDroplocationShimmer extends StatelessWidget {
  const ReachDroplocationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2.5,
              color: Colors.grey,
            ),
            const SizedBox(height: 10),
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
                    height: MediaQuery.of(context).size.height / 9,
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
                    height: MediaQuery.of(context).size.height / 9,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 40,
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
