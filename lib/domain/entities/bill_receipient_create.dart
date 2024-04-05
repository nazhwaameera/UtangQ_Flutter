class BillReceipientCreate {
  final int billID;
  final int recipientUserID;
  final int totalUsers;
  final bool isSplitEvenly;
  final String taxStatusDescription;
  final double taxCharged;

  BillReceipientCreate({
    required this.billID,
    required this.recipientUserID,
    required this.totalUsers,
    required this.isSplitEvenly,
    required this.taxStatusDescription,
    required this.taxCharged,
  });

  // Method to convert BillRecipientCreateDTO object to JSON
  Map<String, dynamic> toJson() {
    return {
      'BillID': billID,
      'RecipientUserID': recipientUserID,
      'TotalUsers': totalUsers,
      'IsSplitEvenly': isSplitEvenly,
      'TaxStatusDescription': taxStatusDescription,
      'TaxCharged': taxCharged,
    };
  }
}
