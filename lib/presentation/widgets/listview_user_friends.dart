import 'package:flutter/material.dart';
import 'package:utangq_app/domain/entities/users.dart';

class UserFriendsListView extends StatelessWidget {
  final int userId;
  final Function() refreshDataCallback;
  final List<Users> friendList;

  const UserFriendsListView({
    Key? key,
    required this.userId,
    required this.refreshDataCallback,
    required this.friendList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: friendList.isEmpty
          ? Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
        child: Text(
          'There is no friend yet. Start sending or accepting friend request.',
          style: TextStyle(fontSize: 16.0, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      )
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Username')),
            DataColumn(label: Text('Full Name')),
            DataColumn(label: Text('Phone Number')),
            DataColumn(label: Text('Email')),
          ],
          rows: friendList.map((user) {
            final index = friendList.indexOf(user);
            final backgroundColor =
            index.isOdd ? Colors.white : Colors.grey[200];
            return DataRow(
                color: MaterialStateColor.resolveWith((states) => backgroundColor!),cells: [
              DataCell(Text(user.username)),
              DataCell(Text(user.userFullName)),
              DataCell(Text(user.userPhoneNumber)),
              DataCell(Text(user.userEmail)),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}

