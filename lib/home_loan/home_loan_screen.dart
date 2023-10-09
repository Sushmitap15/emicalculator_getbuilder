import 'package:emicalculator_getbuilder/home_personal_logic.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:intl/intl.dart';



class HomeloanContent extends StatelessWidget {
  const HomeloanContent({Key? key}) : super(key: key);

  String formatAsRupees(double value) {
    final formatter = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0, // Set to 2 decimal places
      locale: 'en_IN', // Use the Indian locale
    );
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final emiController = Get.find<EmiController>();
    final TextEditingController loanAmountController = TextEditingController();
    final TextEditingController interestController = TextEditingController();
    final TextEditingController tenureController = TextEditingController();

    bool isYearSliderVisible = false;
    bool isMonthSliderVisible = false;
    double selectedTenure = 0.0;
    String selectedTenureUnit = 'Y'; // Default to years

    void updateControllerValues() {
      double homeLoanAmount =
          double.tryParse(loanAmountController.text) ?? 0.0;
      double interestRate =
          double.tryParse(interestController.text) ?? 0.0;
      double loanTenure =
          double.tryParse(tenureController.text) ?? 0.0;

      // Update the values in EmiController
      emiController.loanAmount = homeLoanAmount;
      emiController.interestRate = interestRate;

      if (selectedTenureUnit == 'Y') {
        emiController.loanTenure = loanTenure * 12; // Convert years to months
      } else {
        emiController.loanTenure = loanTenure; // Tenure is already in months
      }

      // Calculate EMI using EmiController
      emiController.calculateEmi();
    }
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child:SingleChildScrollView(
            child: GetBuilder<EmiController>(
              builder: (emiController) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('HomeLoan Amount'),
                          Expanded(
                            child: TextField(
                              controller: loanAmountController,
                              onChanged: (newValue) {
                                double parsedValue = double.tryParse(newValue) ?? 0.0;
                                emiController.loanAmount = parsedValue;
                                updateControllerValues();
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
                          loanAmountController.text = newValue.toStringAsFixed(0);
                          emiController.loanAmount = newValue;
                          updateControllerValues();
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
                                updateControllerValues();
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
                          updateControllerValues();
                        },
                        numberFormat: NumberFormat('#.##'),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Loan Tenure'),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: tenureController,
                                    onChanged: (newValue) {
                                      double parsedValue = double.tryParse(newValue) ?? 0.0;
                                      selectedTenure = parsedValue;
                                      updateControllerValues();
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Enter Loan Tenure',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10), // Add spacing between years and months inputs
                                Container(
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
                                      selectedTenureUnit = 'Y';
                                      selectedTenure = emiController.loanTenure / 12; // Convert to years
                                      tenureController.text = selectedTenure.toStringAsFixed(0);
                                      updateControllerValues();
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Text('Y', style: TextStyle(color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    border: Border(
                                      left: BorderSide(color: Colors.black, width: 0.5),
                                    ),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      // Toggle the visibility of the months slider
                                      isMonthSliderVisible = true;
                                      isYearSliderVisible = false;
                                      selectedTenureUnit = 'M';
                                      selectedTenure = emiController.loanTenure; // Convert to months
                                      tenureController.text = selectedTenure.toStringAsFixed(0);
                                      updateControllerValues();
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Text('M', style: TextStyle(color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Visibility(
                        visible: isYearSliderVisible,
                        child: SfSlider(
                          activeColor: Colors.orange,
                          inactiveColor: Colors.grey,
                          min: 0,
                          max: 30,
                          showLabels: true,
                          interval: 10,
                          showTicks: true,
                          value: selectedTenure, // In years
                          onChanged: (newValue) {
                            selectedTenure = newValue;
                            emiController.loanTenure = newValue * 12; // Convert years to months
                            tenureController.text = newValue.toStringAsFixed(0);

                            updateControllerValues();
                          },
                          numberFormat: NumberFormat('#.##'),
                        ),
                      ),
                      Visibility(
                        visible: isMonthSliderVisible,
                        child: SfSlider(
                          activeColor: Colors.orange,
                          inactiveColor: Colors.grey,
                          min: 0,
                          max: 360,
                          showLabels: true,
                          interval: 90,
                          showTicks: true,
                          value: selectedTenure, // In months
                          onChanged: (newValue) {
                            selectedTenure = newValue;
                            emiController.loanTenure = newValue; // Tenure is already in months
                            tenureController.text = newValue.toStringAsFixed(0);

                            updateControllerValues();
                          },
                          numberFormat: NumberFormat('#.##'),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(

                        decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.black, width: 0.5))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.black, width: 0.5,))),
                              width: 200,
                              padding: EdgeInsets.all(40),
                              //alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        Text('Loan EMI'),
                                        Text('${formatAsRupees(emiController.emi)}'),
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
                                        Text('${formatAsRupees(emiController.totalInterestPayable)}'),
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
                                        Text('Total Payment(Principal+Interest)'),
                                        Text('${formatAsRupees(emiController.totalPayment)}'),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // Container(
                            //  width: MediaQuery.of(context).size.width / 2.1,
                            //   height: 200,
                            //
                            //   child:  PieChart(
                            //
                            //       PieChartData(
                            //
                            //         sections: [
                            //
                            //           PieChartSectionData(
                            //
                            //               value: emiController.interestPercentage.isNaN ? 0 : emiController.interestPercentage,
                            //               color: Colors.orange,
                            //               title: '${emiController.interestPercentage.isNaN ? 0 :emiController.interestPercentage.toStringAsFixed(1)}%',
                            //               titleStyle: TextStyle(fontSize: 16, color:Colors.black),
                            //               borderSide: BorderSide(color: Color.fromARGB(255, 243, 215, 184),width: 5)
                            //           ),
                            //           PieChartSectionData(
                            //               value: emiController.paymentPercentage.isNaN ? 0 : emiController.paymentPercentage,
                            //               color: Colors.green,
                            //               title: '${emiController.paymentPercentage.isNaN ? 0 : emiController.paymentPercentage.toStringAsFixed(1)}%',
                            //               titleStyle: TextStyle(fontSize: 16, color:Colors.black),
                            //               borderSide: BorderSide(color:Color.fromARGB(255, 192, 240, 194),width: 5)
                            //           ),
                            //         ],
                            //         sectionsSpace: 5, // No gap between sections
                            //         centerSpaceRadius: 0, // No center space
                            //       ),
                            //     ),
                            // )
                            Column(
                              children: [
                                Text(
                                  'Break-Up of total Payment',

                                  style: TextStyle(
                                    fontSize: 14,

                                  ),
                                ),

                                Container(
                                  width:  MediaQuery.of(context).size.width / 2.1,
                                  height: 200,
                                  child: PieChart(
                                    PieChartData(
                                      // Your PieChart data configuration here
                                      sections: [

                                        PieChartSectionData(

                                            value: emiController.interestPercentage.isNaN ? 0 : emiController.interestPercentage,
                                            color: Colors.orange,
                                            title: '${emiController.interestPercentage.isNaN ? 0 :emiController.interestPercentage.toStringAsFixed(1)}%',
                                            titleStyle: TextStyle(fontSize: 16, color:Colors.black),
                                            borderSide: BorderSide(color: Color.fromARGB(255, 243, 215, 184),width: 5)
                                        ),
                                        PieChartSectionData(
                                            value: emiController.paymentPercentage.isNaN ? 0 : emiController.paymentPercentage,
                                            color: Colors.green,
                                            title: '${emiController.paymentPercentage.isNaN ? 0 : emiController.paymentPercentage.toStringAsFixed(1)}%',
                                            titleStyle: TextStyle(fontSize: 16, color:Colors.black),
                                            borderSide: BorderSide(color:Color.fromARGB(255, 192, 240, 194),width: 5)
                                        ),
                                      ],
                                      sectionsSpace: 5, // No gap between sections
                                      centerSpaceRadius: 0, // No center space

                                    ),
                                  ),

                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [


                                    Text('Principal Loan Amount:${emiController.interestPercentage.toStringAsFixed(1)}', style: TextStyle(fontSize: 14,color: Colors.orange)),




                                    Text('Total Interest:${emiController.paymentPercentage.toStringAsFixed(1)}', style: TextStyle(fontSize: 14,color: Colors.green)),



                                  ],
                                ),
                              ],
                            )

                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        width: 900,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                          child: DataTable(
                            headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey),
                            border: TableBorder.all(),
                            columns: [
                              DataColumn(
                                label: Container(

                                  color: Colors.blue, // Set the background color for the 'Year' column header
                                  child: Center(
                                    child: Text(
                                      'Year',
                                      style: TextStyle(color: Colors.white), // Set text color
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Container(
                                  color: Colors.green, // Set the background color for the 'Month' column header
                                  child: Center(
                                    child: Text(
                                      'Month',
                                      style: TextStyle(color: Colors.white), // Set text color
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Container(
                                  color: Colors.red, // Set the background color for the 'Principal' column header
                                  child: Center(
                                    child: Text(
                                      'Principal',
                                      style: TextStyle(color: Colors.white), // Set text color
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Container(
                                  color: Colors.orange, // Set the background color for the 'Interest' column header
                                  child: Center(
                                    child: Text(
                                      'Interest',
                                      style: TextStyle(color: Colors.white), // Set text color
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Container(
                                  color: Colors.purple, // Set the background color for the 'Total Payment' column header
                                  child: Center(
                                    child: Text(
                                      'Total Payment',
                                      style: TextStyle(color: Colors.white), // Set text color
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Container(
                                  color: Colors.teal, // Set the background color for the 'Balance' column header
                                  child: Center(
                                    child: Text(
                                      'Balance',
                                      style: TextStyle(color: Colors.white), // Set text color
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Container(
                                  color: Colors.brown, // Set the background color for the 'Loan Paid to Date' column header
                                  child: Center(
                                    child: Text(
                                      'Loan Paid to Date',
                                      style: TextStyle(color: Colors.white), // Set text color
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            rows: emiController.emiSchedule
                                .map(
                                  (item) => DataRow(
                                cells: [
                                  DataCell(
                                    SizedBox(
                                      width: 50, // Set the width for the data cell
                                      child: Text(item.year.toString()),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 40, // Set the width for the data cell
                                      child: Text(item.month.toString()),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 60, // Set the width for the data cell
                                      child: Text(formatAsRupees(item.principal.toDouble())),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 60, // Set the width for the data cell
                                      child: Text(formatAsRupees(item.interest.toDouble())),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 100, // Set the width for the data cell
                                      child: Text(formatAsRupees(item.totalPayment.toDouble())),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 100, // Set the width for the data cell
                                      child: Text(formatAsRupees(item.balance.toDouble())),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 150, // Set the width for the data cell
                                      child: Text('${item.loanPaidToDate.toStringAsFixed(2)}%'),
                                    ),
                                  ),
                                ],
                              ),
                            )
                                .toList(),
                          ),
                        ),
                      ),



                    ],
                  ),
                );
              },
            )
        )
    );
  }
}