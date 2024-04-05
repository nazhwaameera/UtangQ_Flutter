class HandleFriendRequest {
  int friendshipListID;
  int friendshipStatusID;

  HandleFriendRequest({
    required this.friendshipListID,
    required this.friendshipStatusID,
  });

  factory HandleFriendRequest.fromJson(Map<String, dynamic> json) =>
      HandleFriendRequest(
        friendshipListID: json['FriendshipListID'],
        friendshipStatusID: json['FriendshipStatusID'],
      );

  Map<String, dynamic> toJson() => {
    'FriendshipListID': friendshipListID,
    'FriendshipStatusID': friendshipStatusID,
  };
}
