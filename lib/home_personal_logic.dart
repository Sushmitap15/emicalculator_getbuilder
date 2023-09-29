import 'dart:math';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Import the intl package

class EmiController extends GetxController {

  double loanAmount = 0.0;
  double interestRate = 0.0;
  double loanTenure = 0.0;
  double emi = 0.0;
  double totalPayment = 0.0;
  double totalInterestPayable = 0.0;
  double interestPercentage = 0.0;
  double paymentPercentage = 0.0;
  List<EmiScheduleItem> emiSchedule = [];

  void calculateEmi() {
    double principal = loanAmount;
    double rate = interestRate / 1200; // Monthly interest rate
    double time = loanTenure; // Loan tenure in months

    if (principal > 0 && rate > 0 && time > 0) {
      emi = (principal * rate * pow(1 + rate, time)) / (pow(1 + rate, time) - 1);
      totalPayment = emi * time;
      totalInterestPayable = totalPayment - principal;
    } else {
      emi = 0;
      totalPayment = 0;
      totalInterestPayable = 0;
    }
    interestPercentage = (totalInterestPayable * 100) / totalPayment;
    paymentPercentage = 100 - interestPercentage;

    // Generate the EMI schedule
    emiSchedule = _generateEmiSchedule(principal, rate, time);

    update();
  }

  List<EmiScheduleItem> _generateEmiSchedule(
      double principal, double rate, double time) {
    List<EmiScheduleItem> schedule = [];
    double balance = principal;
    double loanPaidToDate = 0;

    DateTime currentDate = DateTime.now();
    int currentYear = currentDate.year;

    for (int month = 1; month <= time; month++) {
      double interest = balance * rate;
      double principalPaid = emi - interest;
      loanPaidToDate += principalPaid;

      balance -= principalPaid;

      double loanPercentagePaid = (loanPaidToDate / principal) * 100; // Calculate percentage paid

      int year = currentYear + ((currentDate.month + month - 1) ~/ 12);
      int monthInYear = (currentDate.month + month - 1) % 12;

      schedule.add(EmiScheduleItem(
        year: year,
        month: monthInYear,
        principal: principalPaid,
        loan: emi,
        totalPayment: emi,
        interest: interest,
        balance: balance,
        loanPaidToDate: loanPercentagePaid,
      ));
    }

    return schedule;
  }
}

class EmiScheduleItem {
  final int year;
  final int month;
  final double principal;
  final double loan;
  final double interest;
  final double totalPayment;
  final double balance;
  final double loanPaidToDate;

  EmiScheduleItem({
    required this.year,
    required this.month,
    required this.principal,
    required this.loan,
    required this.totalPayment,
    required this.interest,
    required this.balance,
    required this.loanPaidToDate,
  });
}
