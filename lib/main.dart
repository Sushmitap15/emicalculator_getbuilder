import 'package:emicalculator_getbuilder/home_loan/home_loan_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:emicalculator_getbuilder/home_personal_logic.dart';

void main() {
  runApp(MyApp());
  // Register EmiController
  Get.put(EmiController());
}

class TabController extends GetxController {
  var selectedIndex = 0;

  void selectTab(int index) {
    selectedIndex = index;
    update();
  }
}

class MyApp extends StatelessWidget {
  final TabController tabController = Get.put(TabController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: CupertinoColors.systemGrey2,
            toolbarHeight: 0,
            shadowColor: CupertinoColors.systemGrey5,
            elevation: 0,
            bottom: TabBar(
              indicatorColor: CupertinoColors.systemGrey5,
              labelColor: Colors.black,

              tabs: [
                Tab(text: 'Home Loan'),
                Tab(text: 'Personal Loan'),
              ],
              indicator: BoxDecoration(
                color: CupertinoColors.systemGrey5, // Change the color of the selected tab
              ),
              onTap: (index) {
                tabController.selectTab(index);
              },
            ),
          ),
          body: GetBuilder<TabController>(
            builder: (controller) {
              return Container(
                color: CupertinoColors.systemGrey5,
                child: TabBarView(
                  children: [

                   HomeloanContent() ,

                    Center(
                      child: Text(
                        'Tab 2 Content',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}