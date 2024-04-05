import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utangq_app/data/providers/friendship_list_provider.dart';
import 'package:utangq_app/domain/entities/handle_friend_request.dart';
import 'package:utangq_app/domain/entities/users.dart';
import 'package:utangq_app/domain/usecases/handle_friend_request.dart';
import 'package:utangq_app/presentation/functions/users_function.dart';
class UserIncomingFriendRequestsListView extends StatelessWidget {
  final int userId;
  final List<Users> listUsers;
  final Function() refreshDataCallback;

  const UserIncomingFriendRequestsListView({
    Key? key,
    required this.userId,
    required this.listUsers,
    required this.refreshDataCallback,
  }) : super(key: key);

  Future<void> acceptFriendRequest(int friendshipListid) async {
    HandleFriendRequest entity = HandleFriendRequest(
        friendshipListID: friendshipListid,
        friendshipStatusID: 2);

    try{
      var result = await HandleFriendRequestUC().execute(entity);
      if(result){
        print('Succesfully accepted the friendship request with id ${entity.friendshipListID}');
        refreshDataCallback();
      } else {
        print('Failed to accept the friendship request with id ${entity.friendshipListID}');
      }
    } catch(e) {
      throw e;
    }
  }

  Future<void> rejectFriendRequest(int friendshipListid) async {
    HandleFriendRequest entity = HandleFriendRequest(
        friendshipListID: friendshipListid,
        friendshipStatusID: 3);

    try{
      var result = await HandleFriendRequestUC().execute(entity);
      if(result){
        print('Succesfully accepted the friendship request with id ${entity.friendshipListID}');
        refreshDataCallback();
      } else {
        print('Failed to accept the friendship request with id ${entity.friendshipListID}');
      }
    } catch(e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<FriendshipListProvider>(context, listen: false)
          .getPendingFriendshipList(userId);
    });
    return Consumer<FriendshipListProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (provider.errorMessage.isNotEmpty) {
          return Center(
            child: Text(provider.errorMessage),
          );
        } else {
          if (provider.pendingFriendshipList.isEmpty) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
              child: Text(
                'There is no incoming friendship request.',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView.builder(
              itemCount: provider.pendingFriendshipList.length,
              itemBuilder: (context, index) {
                final request = provider.pendingFriendshipList[index];
                final backgroundColor =
                index.isOdd ? Colors.white : Colors.grey[200];
                return Dismissible(
                  key: Key(request.friendshipListID.toString()),
                  onDismissed: (direction) {
                    // Handle dismiss logic here
                  },
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  secondaryBackground: Container(
                    color: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                    ),
                    alignment: Alignment.centerRight,
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      bool dismiss = false;
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Container(
                                constraints: BoxConstraints(maxHeight: 170),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      25.0, 40.0, 20.0, 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        textAlign: TextAlign.justify,
                                        text: TextSpan(
                                          text:
                                          'Are you sure you want to reject this request?',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Colors.black,
                                            wordSpacing: 1,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 40),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context); // Close the dialog
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                Colors.grey[300]),
                                            child: Text('Close',
                                                style: TextStyle(
                                                    color: Colors.grey[700])),
                                          ),
                                          SizedBox(width: 10),
                                          ElevatedButton(
                                            onPressed: () async{
                                              await rejectFriendRequest(request.friendshipListID);
                                              Navigator.pop(context);
                                              dismiss = true;
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                Colors.red[700]),
                                            child: Text('OK',
                                                style: TextStyle(
                                                    color: Colors.red[100])),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                      return dismiss;
                    } else if (direction == DismissDirection.endToStart) {
                      bool dismiss = false;
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Container(
                                constraints: BoxConstraints(maxHeight: 170),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      25.0, 40.0, 20.0, 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        textAlign: TextAlign.justify,
                                        text: TextSpan(
                                          text:
                                          'Are you sure you want to accept this request?',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Colors.black,
                                            wordSpacing: 1,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 40),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context); // Close the dialog
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                Colors.grey[300]),
                                            child: Text('Close',
                                                style: TextStyle(
                                                    color: Colors.grey[700])),
                                          ),
                                          SizedBox(width: 10),
                                          ElevatedButton(
                                            onPressed: () async {
                                              await acceptFriendRequest(request.friendshipListID);
                                              Navigator.pop(context);
                                              dismiss = true;
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                Colors.green[700]),
                                            child: Text('OK',
                                                style: TextStyle(
                                                    color: Colors.green[100])),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                      return dismiss;
                    }
                  },
                  child: Container(
                    color: backgroundColor,
                    child: ListTile(
                      title: Table(
                        columnWidths: {
                          0: FlexColumnWidth(1), // Index
                          1: FlexColumnWidth(3),
                          2: FlexColumnWidth(3)
                        },
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0),
                                  child: Text(
                                    (index + 1).toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0),
                                  child: Text(
                                    getUsername(context, request.senderUserID!, listUsers),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0),
                                  child: Text(
                                    getPhoneNumber(context, request.senderUserID!, listUsers),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
