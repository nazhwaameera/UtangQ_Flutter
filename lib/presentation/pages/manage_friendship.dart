import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utangq_app/data/providers/friendship_list_provider.dart';
import 'package:utangq_app/data/providers/greeting_message_provider.dart';
import 'package:utangq_app/data/providers/payment_summary_provider.dart';
import 'package:utangq_app/data/providers/user_bills_provider.dart';
import 'package:utangq_app/data/providers/user_payments_provider.dart';
import 'package:utangq_app/domain/entities/friend_request.dart';
import 'package:utangq_app/domain/entities/friendship_status.dart';
import 'package:utangq_app/domain/entities/users.dart';
import 'package:utangq_app/domain/usecases/create_friend_request.dart';
import 'package:utangq_app/domain/usecases/get_all_friendship_status.dart';
import 'package:utangq_app/domain/usecases/get_all_users.dart';
import 'package:utangq_app/domain/usecases/get_user_friends.dart';
import 'package:utangq_app/domain/usecases/get_user_nonfriends.dart';
import 'package:utangq_app/presentation/functions/users_function.dart';
import 'package:utangq_app/presentation/widgets/listview_friendship_list.dart';
import 'package:utangq_app/presentation/widgets/listview_incoming_bill_recipients.dart';
import 'package:utangq_app/presentation/widgets/listview_incoming_friend_request.dart';
import 'package:utangq_app/presentation/widgets/listview_user_friends.dart';
import 'package:utangq_app/presentation/widgets/listview_user_payments.dart';

class ManageFriendshipPage extends StatefulWidget {
  final int userId;

  const ManageFriendshipPage({Key? key, required this.userId})
      : super(key: key);

  @override
  _ManageFriendshipPageState createState() =>
      _ManageFriendshipPageState(userId);
}

class _ManageFriendshipPageState extends State<ManageFriendshipPage> {
  final int userId;
  late String selectedValue = 'Choose username';
  late List<Users> _userList = [];
  late List<FriendshipStatus> _friendshipStatusesList = [];

  bool _isLoading = false;
  String _errorMessage = '';

  late GreetingMessageProvider _greetingMessageProvider;
  late int _friendshipId = 0;
  late List<Users> _friendList = [];
  late List<Users> _nonFriendList = [];

  _ManageFriendshipPageState(this.userId);

  @override
  void initState() {
    super.initState();
    _greetingMessageProvider = GreetingMessageProvider();
    _initializeData();
    getAllUsers();
    getAllFriendshipStatus();
    _refreshData();
  }

  Future<void> getAllUsers() async{
    try{
      var listUsers = await GetAllUsers().execute();
      setState(() {
        _userList = listUsers;
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> getAllFriendshipStatus() async{
    try{
      var listStatuses = await GetAllFriendshipStatus().execute();
      setState(() {
        _friendshipStatusesList = listStatuses;
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> _initializeData() async {
    await _greetingMessageProvider.getUserFriendship(userId);
    setState(() {
      _friendshipId = _greetingMessageProvider.friendshipId;
    });
    await getUserNonFriends(_friendshipId);
    await getUserFriends(_friendshipId);
  }

  Future<void> getUserNonFriends(int friendshipId) async {
    try {
      var listUserNonFriends = await GetUserNonFriends().execute(friendshipId);
      setState(() {
        _nonFriendList = listUserNonFriends;
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> getUserFriends(int friendshipId) async {
    try {
      var listUserFriends = await GetUserFriends().execute(friendshipId);
      setState(() {
        _friendList = listUserFriends;
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> _refreshData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      getUserFriends(_friendshipId);
      getUserNonFriends(_friendshipId);
      await Provider.of<FriendshipListProvider>(context, listen: false)
          .updatePendindFriendshipList(userId);
      await Provider.of<FriendshipListProvider>(context, listen: false)
          .updateFriendshipList(userId);

      setState(() {
        _isLoading = false;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  void refreshData() {
    setState(() {
      _isLoading = true;
    });
    _refreshData();
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
        child: Text('Choose username'),
        value: 'Choose username',
      ),
    ];

    // Add friends from _friendList to dropdownItems
    _nonFriendList.forEach((friend) {
      menuItems.add(
        DropdownMenuItem(
          child: Text(friend.username),
          value: friend.userID.toString(), // Assuming userId is of type int
        ),
      );
    });

    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFB99CFF),
                Color(0xFFA88FE8),
                Color(0xFFD0B3FF),
                Color(0xFFFFE57F),
              ],
            ),
          ),
        ),
        title: Text(
          'Manage Friendship',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView(
                padding: EdgeInsets.all(20.0),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Send Friendship Request',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 16),
                          DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Username',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              dropdownColor: Colors.white,
                              value: selectedValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedValue = newValue!;
                                  print(
                                      'You choose user with id $selectedValue');
                                });
                              },
                              items: dropdownItems),
                          SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
                              ),
                              onPressed: () async {
                                // Create an instance of FriendRequest
                                FriendRequest request = FriendRequest(
                                  friendshipID: _friendshipId,
                                  senderUserID: userId,
                                  receiverUserID: int.parse(selectedValue),
                                  // Add other necessary fields
                                );
                                bool success = await CreateFriendRequest().execute(request);

                                // Handle the result
                                if (success) {
                                  print('Friend request sent successfully');
                                  showSuccessAlert(context);
                                  setState(() {
                                    selectedValue = 'Choose username';
                                  });
                                  _refreshData();
                                } else {
                                  print('Failed to send friend request');
                                  showWarningAlert(context);

                                }
                              },
                              child: Text(
                                'Send Friend Request',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Incoming Friend Request', // Title text
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 75,
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                    child: // Add spacing between title and content
                        Consumer<UserBillsProvider>(
                      builder: (context, userBillsProvider, _) {
                        return UserIncomingFriendRequestsListView(
                          userId: userId,
                          listUsers: _userList,
                          refreshDataCallback: refreshData,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Friend Lists', // Title text
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 100,
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                    child: // Add spacing between title and content
                        Consumer<FriendshipListProvider>(
                      builder: (context, userBillsProvider, _) {
                        return FriendshipListView(
                          userId: userId,
                          listUsers: _userList,
                          listStatuses: _friendshipStatusesList,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'User Friends', // Title text
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 400,
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                    child: // Add spacing between title and content
                    Consumer<UserBillsProvider>(
                      builder: (context, userBillsProvider, _) {
                        return UserFriendsListView(
                          userId: userId,
                          friendList: _friendList,
                          refreshDataCallback: refreshData,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
