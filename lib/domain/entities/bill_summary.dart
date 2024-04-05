import 'dart:convert';
class BillSummary {
  final double totalBillAmountCreated;
  final double totalBillUnassigned;
  final double totalBillAmountCreatedAccepted;
  final double totalBillAmountCreatedAwaiting;
  final double totalBillAmountCreatedPaid;
  final double totalBillAmountCreatedPending;
  final double totalBillAmountCreatedRejected;

  BillSummary({
    required this.totalBillAmountCreatedAccepted,
    required this.totalBillAmountCreatedAwaiting,
    required this.totalBillAmountCreatedPaid,
    required this.totalBillAmountCreatedPending,
    required this.totalBillAmountCreated,
    required this.totalBillUnassigned,
    required this.totalBillAmountCreatedRejected,
  });
  factory BillSummary.fromJson(Map<String, dynamic> json) {
    return BillSummary(
      totalBillAmountCreatedAccepted: json['totalBillAmountCreatedAccepted'],
      totalBillAmountCreatedAwaiting: json['totalBillAmountCreatedAwaiting'],
      totalBillAmountCreatedPaid: json['totalBillAmountCreatedPaid'],
      totalBillAmountCreatedPending: json['totalBillAmountCreatedPending'],
      totalBillAmountCreated: json['totalBillAmountCreated'],
      totalBillUnassigned : json['totalBillUnassigned'],
      totalBillAmountCreatedRejected: json['totalBillAmountCreatedRejected'],
    );
  }
}