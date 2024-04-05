class FriendRequest {
  int friendshipID;
  int senderUserID;
  int receiverUserID;

  FriendRequest({
    required this.friendshipID,
    required this.senderUserID,
    required this.receiverUserID,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      friendshipID: json['FriendshipID'] as int,
      senderUserID: json['SenderUserID'] as int,
      receiverUserID: json['ReceiverUserID'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FriendshipID'] = this.friendshipID;
    data['SenderUserID'] = this.senderUserID;
    data['ReceiverUserID'] = this.receiverUserID;
    return data;
  }
}
