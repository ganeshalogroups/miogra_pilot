import 'package:miogra_service/Const.dart/const_colors.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/tripslistscreens/new_trip_screen.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:flutter/material.dart';

class TripTabScreen extends StatefulWidget {
  const TripTabScreen({super.key});

  @override
  State<TripTabScreen> createState() => _TripTabScreenState();
}

late TabController _tabController;

class _TripTabScreenState extends State<TripTabScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
   void goToOngoingTab() {
    _tabController.animateTo(1); // 👈 index 1 = Ongoing tab
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                pinned: true,
                floating: true, // Allows the tab bar to stay visible when scrolling
                bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: Color(0xFF623089),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: 'New Orders'),
                    Tab(text: 'Ongoing'),
                    Tab(text: 'Completed'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              Center(child: Text('New Orders Page')),
              Center(child: Text('Ongoing Orders Page')),
              Center(child: Text('Completed Orders Page')),
            ],
          ),
        ),
      ),
    );
  }
}
