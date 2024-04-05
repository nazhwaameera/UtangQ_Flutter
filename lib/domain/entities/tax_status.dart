class TaxStatus {
  final int taxStatusID;
  final String taxStatusDescription;

  TaxStatus({
    required this.taxStatusID,
    required this.taxStatusDescription,
  });

  factory TaxStatus.fromJson(Map<String, dynamic> json) {
    return TaxStatus(
      taxStatusID: json['TaxStatusID'],
      taxStatusDescription: json['TaxStatusDescription'],
    );
  }
}
