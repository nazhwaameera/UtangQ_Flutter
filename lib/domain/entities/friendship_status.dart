class FriendshipStatus {
  final int friendshipStatusID;
  final String friendshipStatusDescription;

  FriendshipStatus({
    required this.friendshipStatusID,
    required this.friendshipStatusDescription,
  });

  factory FriendshipStatus.fromJson(Map<String, dynamic> json) {
    return FriendshipStatus(
      friendshipStatusID: json['FriendshipStatusID'] as int,
      friendshipStatusDescription: json['FriendshipStatusDescription'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FriendshipStatusID': friendshipStatusID,
      'FriendshipStatusDescription': friendshipStatusDescription,
    };
  }
}
