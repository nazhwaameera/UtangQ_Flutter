class BillRecipientWithDesc {
  final int billRecipientID;
  final int billID;
  final double billRecipientAmount;
  final String billDescription;
  final String username;
  final int recipientUserID;
  final DateTime sentDate;
  final String billRecipientStatus;
  final String billRecipientTax;

  BillRecipientWithDesc({
    required this.billRecipientID,
    required this.billID,
    required this.billRecipientAmount,
    required this.billDescription,
    required this.username,
    required this.recipientUserID,
    required this.sentDate,
    required this.billRecipientStatus,
    required this.billRecipientTax,
  });

  factory BillRecipientWithDesc.fromJson(Map<String, dynamic> json) {
    return BillRecipientWithDesc(
      billRecipientID: json['BillRecipientID'],
      billID: json['BillID'],
      billRecipientAmount: json['BillRecipientAmount'].toDouble(),
      billDescription: json['BillDescription'],
      username: json['Username'],
      recipientUserID: json['RecipientUserID'],
      sentDate: DateTime.parse(json['SentDate']),
      billRecipientStatus: json['BillRecipientStatus'],
      billRecipientTax: json['BillRecipientTax'],
    );
  }
}
