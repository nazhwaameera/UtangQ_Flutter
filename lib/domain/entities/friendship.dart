class Friendship {
  int friendshipID;
  int? userID;

  Friendship({required this.friendshipID, this.userID});

  factory Friendship.fromJson(Map<String, dynamic> json) {
    return Friendship(
      friendshipID: json['FriendshipID'],
      userID: json['UserID'],
    );
  }
}