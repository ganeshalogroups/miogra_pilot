import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NewOrdersBottomSheetShimmer extends StatelessWidget {
  const NewOrdersBottomSheetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60.0,
            height: 10.0,
            color: Colors.white,
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 6, // Dummy count for shimmer effect
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 10.0,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                            ),
                            Container(
                              width: double.infinity,
                              height: 10.0,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                            ),
                            Container(
                              width: 100.0,
                              height: 10.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
