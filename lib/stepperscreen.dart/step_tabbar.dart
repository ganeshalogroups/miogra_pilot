import 'package:miogra_service/Validators.dart/exit.dart';
import 'package:miogra_service/stepperscreen.dart/vehicle%20_information.dart';
import 'package:flutter/material.dart';
import 'package:miogra_service/stepperscreen.dart/steps.dart';
import 'package:miogra_service/stepperscreen.dart/personal_information.dart';
import 'package:miogra_service/stepperscreen.dart/bank_details.dart';
import 'package:miogra_service/stepperscreen.dart/work_setup.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';

class StepTabBar extends StatefulWidget {
  final String? loginMobileNumb;
  const StepTabBar({super.key, this.loginMobileNumb});

  @override
  State<StepTabBar> createState() => _StepTabBarState();
}

class _StepTabBarState extends State<StepTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<bool> _completedSteps = [false, false, false, false];
  int _currentTabIndex = 0;
  bool _isStepperScreen = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _navigateToScreens(int index) {
    setState(() {
      _currentTabIndex = index;
      _isStepperScreen = false;
    });
  }

  void _markStepComplete(int index) {
    setState(() {
      _completedSteps[index] = true;
    });
  }

  void navigateToTab(int index) {
    setState(() {
      _currentTabIndex = index;
      _isStepperScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        setState(() {
          _isStepperScreen = true;
        });
       
         return;
        
      },
      
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 25),
                child: CustomText(
                  text: 'Be a Miogra Delivery Partner in 4 steps!',
                  style: CustomTextStyle.stepTitleText,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: List.generate(4, (index) {
                    return Expanded(
                      child: InkWell(
                        onTap: () => _navigateToScreens(index),
                        child: Container(
                          width: double.infinity,
                          height: 9,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _isStepperScreen
                                ? (_completedSteps[index]
                                    ? Colors.green
                                    : Colors.grey)
                                : (_currentTabIndex == index
                                    ? Color(0xFF623089)
                                    : (_completedSteps[index]
                                        ? Colors.green
                                        : Colors.grey)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Expanded(
                child: _isStepperScreen
                    ? StepperScreen(
                        completedSteps: _completedSteps,
                        onStepComplete: _markStepComplete,
                        tabController: _tabController,
                        navigateToTab: navigateToTab,
                      )
                    : _buildTabView(_currentTabIndex),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabView(int index) {
    switch (index) {
      case 0:
        return KeepAliveWrapper(
          child: PersonalInformation(
            loginMobileNumb: widget.loginMobileNumb ?? '',
            onStepComplete: (index) {
              _markStepComplete(index);
              navigateToTab(1);
            },
            tabController: _tabController,
          ),
        );
      case 1:
        return KeepAliveWrapper(
          child: VehicleInformation(
            onStepComplete: (index) {
              _markStepComplete(index);
              navigateToTab(2);
            },
            tabController: _tabController,
          ),
        );
      case 2:
        return KeepAliveWrapper(
          child: BankDetailScreen(
            onStepComplete: (index) {
              _markStepComplete(index);
              navigateToTab(3);
            },
            tabController: _tabController,
          ),
        );
      case 3:
        return KeepAliveWrapper(
          child: WorkSetup(
            onStepComplete: _markStepComplete,
          ),
        );
      default:
        return Container();
    }
  }
}

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({required this.child, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _KeepAliveWrapperState createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
