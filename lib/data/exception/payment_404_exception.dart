class PaymentNotFoundException implements Exception {
  final String message;

  PaymentNotFoundException({this.message = 'Payment not found'});

  @override
  String toString() => 'PaymentNotFoundException: $message';
}