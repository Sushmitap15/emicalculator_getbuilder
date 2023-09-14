import 'package:emicalculator_getbuilder/home_personal_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:intl/intl.dart';

class HomeloanContent extends StatelessWidget {
  const HomeloanContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emiController = Get.find<EmiController>();
    final TextEditingController loanAmountController = TextEditingController();
    final TextEditingController interestController = TextEditingController();
    final TextEditingController tenureController = TextEditingController();


    bool isYearSliderVisible = false;
    bool isMonthSliderVisible = false;
    double selectedTenure = 0.0;

    void updateEmiController() {
      final double homeLoanAmount =
          double.tryParse(loanAmountController.text) ?? 0.0;
      final double interestRate =
          double.tryParse(interestController.text) ?? 0.0;
      final double loanTenure =
          double.tryParse(tenureController.text) ?? 0.0;

      // Update the values in EmiController
      emiController.loanAmount = homeLoanAmount;
      emiController.interestRate = interestRate;
      emiController.loanTenure = loanTenure;

      // Calculate EMI using EmiController
      emiController.calculateEmi();
    }


    return GetBuilder<EmiController>(
      builder: (emiController) {
        return Column(
          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('HomeLoan Amount'),
                Expanded(
                  child: TextField(
                    controller: loanAmountController, // Bind the controller
                    onChanged: (newValue) {

                      double parsedValue = double.tryParse(newValue) ?? 0.0;
                      emiController.loanAmount = parsedValue;
                      updateEmiController();
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter Amount',
                      suffixIcon: Container(
                        height: 58,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border(left: BorderSide(color: Colors.black, width: 0.5)),
                        ),
                        child: Icon(Icons.currency_rupee, color: Colors.black),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            SfSlider(
              activeColor: Colors.orange,
              inactiveColor: Colors.grey,
              min: 0,
              max: 20000000,
              showLabels: true,
              interval: 10000000,
              showTicks: true,
              value: emiController.loanAmount,
              onChanged: (newValue) {
                // Update the EmiController and the input field when the slider changes
         loanAmountController.text = newValue.toStringAsFixed(0);
                emiController.loanAmount = newValue;
                updateEmiController();
              },
              numberFormat: NumberFormat('#.##L'),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Interest Rate'),
                Expanded(
                  child: TextField(
                    controller: interestController, // Bind the controller
                    onChanged: (newValue) {
                      double parsedValue = double.tryParse(newValue) ?? 0.0;
                      emiController.interestRate = parsedValue;
                      updateEmiController();
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter Interest Rate',
                      suffixIcon: Container(
                        height: 58,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border(left: BorderSide(color: Colors.black, width: 0.5)),
                        ),
                        child: Icon(Icons.percent, color: Colors.black),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            SfSlider(
              activeColor: Colors.orange,
              inactiveColor: Colors.grey,
              min: 0,
              max: 20,
              showLabels: true,
              interval: 2.5,
              showTicks: true,
              value: emiController.interestRate,
              onChanged: (newValue) {
                // Update the EmiController and the input field when the slider changes
             interestController.text = newValue.toStringAsFixed(0);
                emiController.interestRate = newValue;
                updateEmiController();
              },
              numberFormat: NumberFormat('#.##'),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Loan Tenure'),
                Expanded(
                  child: TextField(
                    controller: tenureController, // Bind the controller
                    onChanged: (newValue) {
                      double parsedValue = double.tryParse(newValue) ?? 0.0;
                      selectedTenure = parsedValue;
                      updateEmiController();
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter Loan Tenure',
                      suffixIcon: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 58,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              border: Border(
                                left: BorderSide(color: Colors.black, width: 0.5),
                              ),
                            ),
                            child: TextButton(
        onPressed: () {
          // Toggle the visibility of the years slider
          isYearSliderVisible = true;
          isMonthSliderVisible = false;
          selectedTenure = emiController.loanTenure / 12; // Convert to years
          updateEmiController();
        },
        child: Row(
        children: [

        SizedBox(width: 10), // Add some spacing between the icon and text
        Text('Y',style: TextStyle(color: Colors.black),),
        ],
        ),
                            ),
                          ),
                          Container(
                            height: 58,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              border: Border(
                                left: BorderSide(color: Colors.black, width: 0.5),
                              ),
                            ),
                            child:  TextButton(
                              onPressed: () {
                                // Toggle the visibility of the months slider
                                isMonthSliderVisible = true;
                                isYearSliderVisible = false;
                                selectedTenure = emiController.loanTenure; // Convert to months
                                updateEmiController();
                                },
                              child: Row(
                                children: [

                                  SizedBox(width: 10), // Add some spacing between the icon and text
                                  Text('M',style: TextStyle(color: Colors.black),),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Visibility(
              visible: isYearSliderVisible,
                child:   SfSlider(
                  activeColor: Colors.orange,
                  inactiveColor: Colors.grey,
                  min: 0,
                  max: 30,
                  showLabels: true,
                  interval: 15,
                  showTicks: true,
                  value: selectedTenure, // Use selectedTenure to set the initial value
                  onChanged: (newValue) {

                    // Update the selectedTenure
                    selectedTenure = newValue;
                    // Update the input field based on the selectedTenure
                    tenureController.text = newValue.toStringAsFixed(0);
                    // Convert years back to months for EmiController
                    emiController.loanTenure = newValue * 12;
                    updateEmiController();
                  },
                  numberFormat: NumberFormat('#.##'),
                )
            ),
            Visibility(
              visible: isMonthSliderVisible,
                child:  SfSlider(
                  activeColor: Colors.orange,
                  inactiveColor: Colors.grey,
                  min: 0,
                  max: 360,
                  showLabels: true,
                  interval: 120,
                  showTicks: true,
                  value:selectedTenure, // Use selectedTenure to set the initial value
                  onChanged: (newValue) {
                    // Update the EmiController and the input field when the slider changes
                    tenureController.text = (newValue * 2).toStringAsFixed(0);
                    emiController.loanTenure = newValue * 2;
                    updateEmiController();
                  },
                  numberFormat: NumberFormat('#.##'),
                ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.black, width: 0.5))),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.black, width: 0.5,))),
                    padding: EdgeInsets.all(40),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Text('Loan EMI'),
                              Text('EMI Amount: ${emiController.emi.toStringAsFixed(2)}'),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 0.5,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text('Total Interest Payable'),
                              Text('EMI Amount: ${emiController.totalInterestPayable.toStringAsFixed(2)}'),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 0.5,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text('Total Payment'),
                              Text('(Principal+Interest'),
                              Text('EMI Amount: ${emiController.totalPayment.toStringAsFixed(2)}'),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );

  }

}
