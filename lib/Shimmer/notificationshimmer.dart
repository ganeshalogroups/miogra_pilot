import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NotificationShimmer extends StatelessWidget {
  const NotificationShimmer({super.key});

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
              Container(
                width: MediaQuery.of(context).size.width / 4,
                height: MediaQuery.of(context).size.height / 27,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 27,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 27,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 27,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 27,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 27,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width / 4,
                height: MediaQuery.of(context).size.height / 25,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 27,
                color: Colors.grey,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 27,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 27,
                color: Colors.grey,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 27,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 27,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
