import 'dart:convert';

class Bill {
  int billID;
  int userID;
  double billAmount;
  DateTime billDate;
  String billDescription;
  double ownerContribution;

  Bill({
    required this.billID,
    required this.userID,
    required this.billAmount,
    required this.billDate,
    required this.billDescription,
    required this.ownerContribution,
  });

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
    billID: json['BillID'],
    userID: json['UserID'],
    billAmount: json['BillAmount'].toDouble(),
    billDate: DateTime.parse(json['BillDate']),
    billDescription: json['BillDescription'],
    ownerContribution: json['OwnerContribution'].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'BillID': billID,
    'UserID': userID,
    'BillAmount': billAmount,
    'BillDate': billDate.toIso8601String(),
    'BillDescription': billDescription,
    'OwnerContribution': ownerContribution,
  };
}
