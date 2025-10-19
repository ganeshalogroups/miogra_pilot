import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DepositTransactionShimmer extends StatefulWidget {
  const DepositTransactionShimmer({super.key});

  @override
  State<DepositTransactionShimmer> createState() =>
      _DepositTransactionShimmerState();
}

class _DepositTransactionShimmerState extends State<DepositTransactionShimmer> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height /
                    2.5, // Set a height for the list
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 8, // Dummy count for shimmer effect
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity, // Fills available width
                            height: MediaQuery.of(context).size.height / 20,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
