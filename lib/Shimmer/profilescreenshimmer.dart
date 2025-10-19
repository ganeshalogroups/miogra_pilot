import 'package:miogra_service/widgets.dart/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreenShimmer extends StatelessWidget {
  const ProfileScreenShimmer({super.key});

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
            children: [
              CustomContainer(
                height: MediaQuery.of(context).size.height / 7,
                decoration: BoxDecoration(color: Colors.grey,
                borderRadius: BorderRadius.circular(25)),
                borderRadius: BorderRadius.circular(25),
                width: MediaQuery.of(context).size.width / 1,
              ),
              // Center(
              //   child: Container(
              //     height: 70,
              //     width: 70,
              //     decoration:
              //         BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
              //   ),
              // ),
              SizedBox(
                height: 10,
              ),
              // Center(
              //   child: Container(
              //     width: MediaQuery.of(context).size.width / 4,
              //     height: MediaQuery.of(context).size.height / 25,
              //     color: Colors.grey,
              //   ),
              // ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 25,
                color: Colors.grey,
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width / 2.5,
                height: MediaQuery.of(context).size.height / 25,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.height / 30,
                color: Colors.grey,
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.height / 28,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.height /
                    2.5, // Set a height for the list
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 6, // Dummy count for shimmer effect
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  width:
                                      double.infinity, // Fills available width
                                  height:
                                      MediaQuery.of(context).size.height / 20,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
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
