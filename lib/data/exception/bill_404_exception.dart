class BillNotFoundException implements Exception {
  final String message;

  BillNotFoundException({this.message = 'Bill not found'});

  @override
  String toString() => 'BillNotFoundException: $message';
}