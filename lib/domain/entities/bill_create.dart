class BillCreate {
  final int userID;
  final double billAmount;
  final DateTime billDate;
  final String billDescription;
  final double ownerContribution;

  BillCreate({
    required this.userID,
    required this.billAmount,
    required this.billDate,
    required this.billDescription,
    required this.ownerContribution,
  });

  Map<String, dynamic> toJson() {
    return {
      'UserID': userID,
      'BillAmount': billAmount,
      'BillDate': billDate.toIso8601String(),
      'BillDescription': billDescription,
      'OwnerContribution': ownerContribution,
    };
  }
}
