import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:utangq_app/data/exception/friendship_404_exception.dart';
import 'package:utangq_app/data/repository/users_repository.dart';
import 'package:utangq_app/domain/entities/friendship.dart';
import 'package:utangq_app/domain/entities/users.dart';
import 'package:utangq_app/domain/usecases/create_user_friendship.dart';
import 'package:utangq_app/domain/usecases/get_user_friends.dart';
import 'package:utangq_app/domain/usecases/get_user_friendship.dart';
import 'package:utangq_app/domain/usecases/get_user_nonfriends.dart';

class GreetingMessageProvider extends ChangeNotifier {
  late String _greetingMessage = '';
  late int _userId = 0;
  late String _username = '';
  late int _friendshipId = 0;
  late List<Users> _friendList = [];
  late List<Users> _nonFriendList = [];

  String get greetingMessage => _greetingMessage;

  int get userId => _userId;

  String get username => _username;

  int get friendshipId => _friendshipId;

  List<Users> get friendList => _friendList;
  List<Users> get nonFriendList => _nonFriendList;

  Future<void> getGreetingMessage(int userId) async {
    if (userId == 0) {
      print('User id invalid');
    } else {
      try {
        final box = await Hive.openBox(UsersRepository.boxName);
        final loginUser = box.values.first;
        final String? username = loginUser.username;
        final int? userId = loginUser.userId;
        // print('This is get greeting message: $userId, $username');
        if (username != null && userId != null) {
          _greetingMessage = 'Good Day, $username';
          _userId = userId;
          _username = username;
        } else {
          _greetingMessage = 'User information not found.';
        }
        // print('$_userId, $_username');
      } catch (e) {
        print('Error retrieving user information from Hive: $e');
        _greetingMessage = 'An error occurred.';
      }
      notifyListeners();
    }
  }

  Future<void> getUserFriendship(int userId) async {
    if (userId == 0) {
      print('User id invalid, get user friendship');
    } else {
      try {
        Friendship userFriendship = await GetUserFriendship().execute(userId);
        _friendshipId = userFriendship.friendshipID;
        notifyListeners();
      } catch (e) {
        print('Error retrieving user friendship :$e');
        if (e is FriendshipNotFoundException) {
          print('Friendship id not found, creating new friendship...');
          await CreateUserFriendship().execute(_userId);
          Friendship userFriendship = await GetUserFriendship().execute(
              _userId);
          if (userFriendship == null) {
            print(
                'Failed to load user friendship: Friendship still not found after creation');
          } else {
            _friendshipId = userFriendship.friendshipID;
            notifyListeners();
          }
        }
      }
    }
  }

  Future<void> getUserFriends(int friendshipId) async {
    if (userId == 0) {
      print('User id invalid, get user friendship');
    } else {
      try {
        List<Users> friendList = await GetUserFriends().execute(friendshipId);
        _friendList = friendList;
        notifyListeners();
      } catch (e) {
        print('Error retrieving user friends :$e');
        throw e;
      }
    }
  }

  Future<void> getUserNonFriends(int friendshipId) async {
    if (userId == 0) {
      print('User id invalid, get user friendship');
    } else {
      try {
        List<Users> nonFriendList = await GetUserNonFriends().execute(friendshipId);
        _nonFriendList = nonFriendList;
        notifyListeners();
      } catch (e) {
        print('Error retrieving user non friends :$e');
        throw e;
      }
    }
  }

  Future<void> refreshFriendsData(int friendshipId) async {
    try {
      _friendList.clear();
      _nonFriendList.clear();
      await getUserFriends(friendshipId);
      await getUserNonFriends(friendshipId);
    } catch (e) {
      print('Error updating friends data: $e');
    }
  }

  void clearData() {
    _greetingMessage = '';
    _userId = 0;
    _friendshipId = 0;
    _username = '';
    _friendList.clear();
    _nonFriendList.clear();
    print('Greeting message provider: Data is cleared');
    notifyListeners();
  }
}
