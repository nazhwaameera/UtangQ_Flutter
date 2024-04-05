class WalletNotFoundException implements Exception {
  final String message;

  WalletNotFoundException({this.message = 'Wallet not found'});

  @override
  String toString() => 'WalletNotFoundException: $message';
}