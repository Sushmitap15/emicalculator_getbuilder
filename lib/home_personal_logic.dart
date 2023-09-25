import 'dart:math';
import 'package:get/get.dart';


class EmiController extends GetxController {
  double loanAmount = 0.0;
  double interestRate = 0.0;
  double loanTenure = 0.0;
  double emi = 0.0;
  double totalPayment = 0.0;
  double totalInterestPayable = 0.0;



  void calculateEmi() {
    double principal = loanAmount;
    double rate = (interestRate /100)/12; // Monthly interest rate
    double time = loanTenure * 12; // Loan tenure in months

    if (principal > 0 && rate > 0 && time > 0) {
      emi = (principal * rate * pow(1 + rate, time)) / (pow(1 + rate, time) - 1);
      totalPayment = emi* time;
      totalInterestPayable = totalPayment - principal;

    } else {
      emi = 0;
      totalPayment = 0;
      totalInterestPayable = 0;
    }

    update();
  }
//P x R x (1+R)^N / [(1+R)^N-1]


}