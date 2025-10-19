// ignore_for_file: depend_on_referenced_packages

import 'package:miogra_service/Const.dart/const_colors.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/ProfileSubScreens.dart/profile_screen.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/Earnings/earnings_screen.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/homesubscreens.dart/home_screen_multi_trip.dart';
import 'package:miogra_service/DeliveryBottomNavBar.dart/notification_screen.dart';
import 'package:miogra_service/widgets.dart/custom_gradienttext.dart';
import 'package:miogra_service/widgets.dart/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller.dart/ProfileController/lastseenupdate.dart';

class DeliveryBottomNavigation extends StatefulWidget {
  final int initialIndex;
  final bool showBottomSheet;
  final bool? pendingrequest;

  const DeliveryBottomNavigation({
    super.key,
    this.initialIndex = 0,
    required this.showBottomSheet,
    this.pendingrequest,
  });

  @override
  State<DeliveryBottomNavigation> createState() =>
      _DeliveryBottomNavigationState();
}

class _DeliveryBottomNavigationState extends State<DeliveryBottomNavigation> {
  final LastSeenUpdateController _lastSeenUpdatecontroller =
      Get.put(LastSeenUpdateController());
  late int _selectedIndex;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _selectedIndex = widget.initialIndex;
    _screens = <Widget>[
      HomeScreenMultiTrip(
        showBottomSheet: widget.showBottomSheet,
        pendingRequest: widget.pendingrequest ?? false,
      ),
      // HomeScreen(
      //   showBottomSheet: widget.showBottomSheet,
      //   pendingRequest: widget.pendingrequest ?? false,
      // ),

      EarningsScreen(),

      NotificationScreen(),
      ProfileScreen(),
    ];
    _lastSeenUpdatecontroller.updateLastSeen();
  }

  void _onItemTapped(int index) {
    if (widget.pendingrequest == true && index != 0) {
      _showNotification("Your request is under review");
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showNotification(String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => CustomSnackBar(message: message),
    );

    // Insert the overlay entry
    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  Widget _buildBottomNavigationItem({
    required String label,
    required String imagePath,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ?Customcolors.darkPurple : Colors.grey;
    final borderColor =
        isSelected ?Customcolors.darkPurple : Colors.grey.shade200;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: borderColor,
                width: isSelected ? 2.0 : 1.0,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10,
              ),
              isSelected
                  ? ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: const [
                          Customcolors.lightPurple,
                          Customcolors.darkPurple
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcIn,
                      child: Image.asset(
                        imagePath,
                        height: 24,
                      ),
                    )
                  : ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: const [
                            Colors.grey, // Color code for #F98322
                            Colors.grey,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcIn,
                      child: Image.asset(
                        imagePath,
                        height: 24,
                      ),
                    ),
              GradientText(
                gradient: isSelected
                    ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: const [
                                    
   Customcolors.lightPurple,
                 
   
                        Customcolors.darkPurple // End color
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: const [
                          Colors.grey, // Color code for #F98322
                          Colors.grey, // End color
                        ],
                      ),
                text: label,
                style: TextStyle(color: color, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomNavigationItem(
            label: 'Home',
            imagePath: 'assets/images/home.png',
            index: 0,
          ),
          _buildBottomNavigationItem(
            label: 'Earning',
            imagePath: 'assets/images/earnings.png',
            index: 1,
          ),
          _buildBottomNavigationItem(
            label: 'Notification',
            imagePath: 'assets/images/notifications.png',
            index: 2,
          ),
          _buildBottomNavigationItem(
            label: 'Profile',
            imagePath: 'assets/images/profile.png',
            index: 3,
          ),
        ],
      ),
    );
  }
}
