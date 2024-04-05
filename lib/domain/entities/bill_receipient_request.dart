class BillRecipientRequest {
  final int billRecipientID;
  final int newStatusID;

  BillRecipientRequest({
    required this.billRecipientID,
    required this.newStatusID,
  });

  Map<String, dynamic> toJson() {
    return {
      'BillRecipientID': billRecipientID,
      'NewStatusID': newStatusID,
    };
  }
}
