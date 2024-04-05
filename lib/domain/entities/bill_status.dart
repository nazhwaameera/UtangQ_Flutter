class BillStatus {
  final int billStatusID;
  final String billStatusDescription;

  BillStatus({
    required this.billStatusID,
    required this.billStatusDescription,
  });

  factory BillStatus.fromJson(Map<String, dynamic> json) {
    return BillStatus(
      billStatusID: json['BillStatusID'],
      billStatusDescription: json['BillStatusDescription'],
    );
  }
}