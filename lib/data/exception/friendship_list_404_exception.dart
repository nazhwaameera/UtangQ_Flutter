class FriendshipListNotFoundException implements Exception {
  final String message;

  FriendshipListNotFoundException({this.message = 'Friendship not found'});

  @override
  String toString() => 'FriendshipListNotFoundException: $message';
}