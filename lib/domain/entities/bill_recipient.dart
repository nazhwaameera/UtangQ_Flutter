import 'dart:convert';

class BillRecipient {
  int billRecipientID;
  int billID;
  int recipientUserID;
  DateTime sentDate;
  int billRecipientStatusID;
  int billRecipientTaxStatusID;
  double billRecipientAmount;

  BillRecipient({
    required this.billRecipientID,
    required this.billID,
    required this.recipientUserID,
    required this.sentDate,
    required this.billRecipientStatusID,
    required this.billRecipientTaxStatusID,
    required this.billRecipientAmount,
  });

  factory BillRecipient.fromJson(Map<String, dynamic> json) {
    return BillRecipient(
      billRecipientID: json['BillRecipientID'],
      billID: json['BillID'],
      recipientUserID: json['RecipientUserID'],
      sentDate: DateTime.parse(json['SentDate']),
      billRecipientStatusID: json['BillRecipientStatusID'],
      billRecipientTaxStatusID: json['BillRecipientTaxStatusID'],
      billRecipientAmount: json['BillRecipientAmount'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BillRecipientID': billRecipientID,
      'BillID': billID,
      'RecipientUserID': recipientUserID,
      'SentDate': sentDate.toIso8601String(),
      'BillRecipientStatusID': billRecipientStatusID,
      'BillRecipientTaxStatusID': billRecipientTaxStatusID,
      'BillRecipientAmount': billRecipientAmount,
    };
  }
}
