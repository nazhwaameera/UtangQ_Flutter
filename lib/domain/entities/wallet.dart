class Wallet {
  int walletID;
  int userID;
  double walletBalance;

  Wallet({
    required this.walletID,
    required this.userID,
    required this.walletBalance,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      walletID: json['WalletID'],
      userID: json['UserID'],
      walletBalance: json['WalletBalance'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['WalletID'] = this.walletID;
    data['UserID'] = this.userID;
    data['WalletBalance'] = this.walletBalance;
    return data;
  }
}
