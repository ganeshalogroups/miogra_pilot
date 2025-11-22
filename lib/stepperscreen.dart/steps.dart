import 'package:flutter/material.dart';
import 'package:miogra_service/Validators.dart/exit.dart';
import 'package:miogra_service/widgets.dart/custom_space.dart';
import 'package:miogra_service/widgets.dart/custom_text.dart';
import 'package:miogra_service/widgets.dart/custom_textstyle.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class StepperScreen extends StatefulWidget {
  final List<bool> completedSteps;
  final Function(int) onStepComplete;
  final TabController tabController;
  final Function(int) navigateToTab;

  const StepperScreen({
    super.key,
    required this.completedSteps,
    required this.onStepComplete,
    required this.tabController,
    required this.navigateToTab,
  });

  @override
  State<StepperScreen> createState() => _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen> {
  final List<String> steps = [
    'Step 1',
    'Step 2',
    'Step 3',
    'Step 4',
  ];

  final List<String> stepsDesc = [
    'Personal Information',
    'Vehicle Information & Documents',
    'Bank Details',
    'Work Setup',
  ];

  void _navigateToStep(int index) {
    widget.navigateToTab(index);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
       
        if (didPop) return;
        
            await ExitApp.handlePop();
         return;
        
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: steps.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: InkWell(
                          onTap: () => _navigateToStep(index),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height / 10,
                              width: MediaQuery.of(context).size.width / 1.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Center(
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            text: steps[index],
                                            style: CustomTextStyle.bigBlackText,
                                          ),
                                          CustomText(
                                            text: stepsDesc[index],
                                            style: CustomTextStyle.stepTitlText,
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      widget.completedSteps[index]
                                          ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: Image.asset(
                                                  'assets/images/stepsuccess.png'),
                                            )
                                          : Icon(
                                              MdiIcons.chevronRight,
                                              color: Colors.grey,
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                CustomSizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
