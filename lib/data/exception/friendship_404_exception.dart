class FriendshipNotFoundException implements Exception {
  final String message;

  FriendshipNotFoundException({this.message = 'Friendship not found'});

  @override
  String toString() => 'FriendshipNotFoundException: $message';
}