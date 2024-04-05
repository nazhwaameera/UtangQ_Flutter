class PaymentSummary {
  final double totalPendingAmountOwed;
  final double totalBillAmountPaid;
  final double totalBillAmountAccepted;
  final double totalBillAmountAwaiting;

  PaymentSummary({
    required this.totalPendingAmountOwed,
    required this.totalBillAmountPaid,
    required this.totalBillAmountAccepted,
    required this.totalBillAmountAwaiting,
  });
}
