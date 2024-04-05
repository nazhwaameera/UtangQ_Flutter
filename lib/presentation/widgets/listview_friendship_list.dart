import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:utangq_app/data/providers/friendship_list_provider.dart';
import 'package:utangq_app/domain/entities/friendship_status.dart';
import 'package:utangq_app/domain/entities/users.dart';
import 'package:utangq_app/presentation/functions/users_function.dart';

class FriendshipListView extends StatelessWidget {
  final int userId;
  final List<Users> listUsers;
  final List<FriendshipStatus> listStatuses;

  const FriendshipListView({Key? key, required this.userId, required this.listUsers, required this.listStatuses}) : super(key: key);

  void actionPopUpItemSelected(BuildContext context, value, int billId) {
    String message;
    if (value == 'split_bill') {
      message = 'You selected split bill for $billId';
      // Navigate to split bill page
    } else if (value == 'edit_bill') {
      message = 'You selected edit bill for $billId';
      // Navigate to edit bill page
    } else {
      message = 'You selected delete bill for $billId';
      // Show delete modal dialog
    }
    print(message);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((Duration) {
      Provider.of<FriendshipListProvider>(context, listen: false)
          .updateFriendshipList(userId);
    });
    return Consumer<FriendshipListProvider>(
      builder: (context, friendshipListProvider, _) {
        if (friendshipListProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (friendshipListProvider.errorMessage.isNotEmpty) {
          return Center(
            child: Text(friendshipListProvider.errorMessage),
          );
        } else {
          if (friendshipListProvider.friendshipList.isEmpty) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
              child: Text(
                'There is no friendship yet. Start making friends!',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: friendshipListProvider.friendshipList.length,
              itemBuilder: (context, index) {
                final friendship = friendshipListProvider.friendshipList[index];
                final backgroundColor =
                index.isOdd ? Colors.white : Colors.grey[200];
                return Container(
                  color: backgroundColor,
                  child: ListTile(
                    title: Table(
                      columnWidths: {
                        0: FlexColumnWidth(1), // Index
                        1: FlexColumnWidth(3), // Friend's Name
                        2: FlexColumnWidth(3), // Friendship Status
                      },
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  (index + 1).toString(), // Current Index
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  getUsername(context, friendship.receiverUserID!, listUsers), // Friend's Name
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  getFriendshipStatus(context, friendship.friendshipStatusID!, listStatuses), // Friendship Status
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}
