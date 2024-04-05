class WalletBalance {
  final int userID;
  final double amount;
  final String operationFlag;

  WalletBalance({
    required this.userID,
    required this.amount,
    required this.operationFlag,
  });

  factory WalletBalance.fromJson(Map<String, dynamic> json) {
    return WalletBalance(
      userID: json['UserID'],
      amount: json['Amount'].toDouble(),
      operationFlag: json['OperationFlag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserID': userID,
      'Amount': amount,
      'OperationFlag': operationFlag,
    };
  }
}
