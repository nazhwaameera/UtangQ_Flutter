import 'package:flutter/material.dart';
import 'package:utangq_app/data/exception/friendship_list_404_exception.dart';
import 'package:utangq_app/domain/entities/friendship_list.dart';
import 'package:utangq_app/domain/usecases/get_friendship_list_by_user_id.dart';
import 'package:utangq_app/domain/usecases/get_pending_friendship_list.dart';

class FriendshipListProvider extends ChangeNotifier {
  final GetPendingFriendshipList _getPendingFriendshipList = GetPendingFriendshipList();
  final GetFriendshipListByUserId _getFriendshipList = GetFriendshipListByUserId();
  List<FriendshipList> _pendingFriendshipList = [];
  List<FriendshipList> _friendshipList = [];

  bool _isLoading = false;
  String _errorMessage = '';

  List<FriendshipList> get pendingFriendshipList => _pendingFriendshipList;
  List<FriendshipList> get friendshipList => _friendshipList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> getPendingFriendshipList(int receiverUserId) async {
    try {
      _isLoading = true;

      _pendingFriendshipList = await _getPendingFriendshipList.execute(receiverUserId);

      _isLoading = false;
      _errorMessage = '';

      notifyListeners();
    } catch (e) {
      if(e is FriendshipListNotFoundException) {
        _isLoading = false;
        _pendingFriendshipList = [];
        notifyListeners();
      } else {
        _isLoading = false;
        _errorMessage = e.toString();
        notifyListeners();
      }
    }
  }

  Future<void> updatePendindFriendshipList(int receiverUserId) async{
    try{
      _pendingFriendshipList.clear();
      _isLoading = false;
      _errorMessage = '';
      await getPendingFriendshipList(receiverUserId);
    } catch(e) {
      throw e;
    }
  }

  Future<void> getFriendshipList(int userId) async {
    try {
      _isLoading = true;

      _friendshipList = await _getFriendshipList.execute(userId);

      _isLoading = false;
      _errorMessage = '';

      notifyListeners();
    } catch (e) {
      if(e is FriendshipListNotFoundException) {
        _isLoading = false;
        _friendshipList = [];
        notifyListeners();
      } else {
        _isLoading = false;
        _errorMessage = e.toString();
        notifyListeners();
      }
    }
  }

  Future<void> updateFriendshipList(int userId) async{
    try{
      _friendshipList.clear();
      _isLoading = false;
      _errorMessage = '';
      await getFriendshipList(userId);
    } catch(e) {
      throw e;
    }
  }
}
