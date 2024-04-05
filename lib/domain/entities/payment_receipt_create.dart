class PaymentReceiptCreate {
  int billRecipientID;
  DateTime sentDate;
  DateTime? confirmationDate;
  String paymentReceiptURL;

  PaymentReceiptCreate({
    required this.billRecipientID,
    required this.sentDate,
    this.confirmationDate,
    required this.paymentReceiptURL,
  });

  PaymentReceiptCreate.withCurrentDate({
    required this.billRecipientID,
    this.confirmationDate,
  })
      : sentDate = DateTime.now(),
        paymentReceiptURL = "https://example.com/receipt";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BillRecipientID'] = this.billRecipientID;
    data['SentDate'] = this.sentDate.toIso8601String();
    data['ConfirmationDate'] = this.confirmationDate?.toIso8601String();
    data['PaymentReceiptURL'] = this.paymentReceiptURL;
    return data;
  }
}