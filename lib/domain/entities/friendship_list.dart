class FriendshipList {
  final int friendshipListID;
  final int? friendshipID;
  final int? senderUserID;
  final int? receiverUserID;
  final int? friendshipStatusID;

  FriendshipList({
    required this.friendshipListID,
    this.friendshipID,
    this.senderUserID,
    this.receiverUserID,
    this.friendshipStatusID,
  });

  factory FriendshipList.fromJson(Map<String, dynamic> json) {
    return FriendshipList(
      friendshipListID: json['FriendshipListID'],
      friendshipID: json['FriendshipID'],
      senderUserID: json['SenderUserID'],
      receiverUserID: json['ReceiverUserID'],
      friendshipStatusID: json['FriendshipStatusID'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'FriendshipListID': friendshipListID,
      'FriendshipID': friendshipID,
      'SenderUserID': senderUserID,
      'ReceiverUserID': receiverUserID,
      'FriendshipStatusID': friendshipStatusID,
    };
    return data;
  }
}
