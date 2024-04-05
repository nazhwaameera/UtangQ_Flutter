import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:utangq_app/data/datasource/users_remote_ds.dart';
import 'package:utangq_app/data/exception/friendship_404_exception.dart';
import 'package:utangq_app/data/exception/wallet_404_exception.dart';
import 'package:utangq_app/domain/entities/bill.dart';
import 'package:utangq_app/domain/entities/bill_create.dart';
import 'package:utangq_app/domain/entities/bill_summary.dart';
import 'package:utangq_app/domain/entities/friend_request.dart';
import 'package:utangq_app/domain/entities/friendship.dart';
import 'package:utangq_app/domain/entities/friendship_list.dart';
import 'package:utangq_app/domain/entities/friendship_status.dart';
import 'package:utangq_app/domain/entities/handle_friend_request.dart';
import 'package:utangq_app/domain/entities/login_user.dart';
import 'package:utangq_app/domain/entities/payment_summary.dart';
import 'package:utangq_app/domain/entities/user_create.dart';
import 'package:utangq_app/domain/entities/users.dart';
import 'package:utangq_app/domain/entities/wallet.dart';
import 'package:utangq_app/domain/entities/wallet_balance.dart';

class UsersRepository {
  var remoteUsersDataSource = RemoteUsersDataSource();
  static const String boxName = 'userBox';
  static const String userKey = 'user';
  late var box = Hive.box(boxName);

  Future<List<Users>> getAllUsers() async{
    var jsonArray = jsonDecode(await remoteUsersDataSource.getAllUsers());
    var listUsers = <Users>[];

    listUsers = jsonArray.map<Users>((jsonObject) => Users.fromJson(jsonObject)).toList();
    return listUsers;
  }

  Future<List<FriendshipStatus>> getAllFriendshipStatus() async{
    var jsonArray = jsonDecode(await remoteUsersDataSource.getAllFriendshipStatus());
    var listStatuses = <FriendshipStatus>[];

    listStatuses = jsonArray.map<FriendshipStatus>((jsonObject) => FriendshipStatus.fromJson(jsonObject)).toList();
    return listStatuses;
  }

  Future<bool> createUser(UserCreate entity) async {
    var result = await remoteUsersDataSource.createUser(entity);
    return result;
  }

  Future<LoginUser> loginUser(String usernameLogin, String passwordLogin) async {
    box = await Hive.openBox(boxName);
    var responseData = jsonDecode(await remoteUsersDataSource.loginUser(usernameLogin, passwordLogin));
    await box.put(userKey, LoginUser.fromJson(responseData));
    return LoginUser.fromJson(responseData);
  }

  Future<Friendship> getUserFriendship(int userId) async{
    final response = await remoteUsersDataSource.getUserFriendship(userId);
    final statusCode = response['statusCode'] as int;
    final responseBody = response['body'] as String;

    if (statusCode == 200) {
      return Friendship.fromJson(jsonDecode(responseBody));
    } else if(statusCode == 404){
      throw FriendshipNotFoundException();
    } else {
      throw Exception('Failed to load friendship: $statusCode - $responseBody');
    }
  }

  Future<List<Users>> getUserFriends(int friendshipId) async{
    var jsonArray = jsonDecode(await remoteUsersDataSource.getUserFriends(friendshipId));
    var listUserFriends = <Users>[];

    listUserFriends = jsonArray.map<Users>((jsonObject) => Users.fromJson(jsonObject)).toList();
    return listUserFriends;
  }

  Future<List<Users>> getUserNonFriends(int friendshipId) async{
    var jsonArray = jsonDecode(await remoteUsersDataSource.getUserNonFriends(friendshipId));
    var listUserNonFriends = <Users>[];

    listUserNonFriends = jsonArray.map<Users>((jsonObject) => Users.fromJson(jsonObject)).toList();
    return listUserNonFriends;
  }

  Future<List<FriendshipList>> getPendingFriendshipList(int receiverUserId) async{
    var jsonArray = jsonDecode(await remoteUsersDataSource.getPendingFriendshipList(receiverUserId));
    var listPendingFriendshipList = <FriendshipList>[];

    listPendingFriendshipList = jsonArray.map<FriendshipList>((jsonObject) => FriendshipList.fromJson(jsonObject)).toList();
    return listPendingFriendshipList;
  }

  Future<List<FriendshipList>> getFriendshipListByUserId(int userId) async{
    var jsonArray = jsonDecode(await remoteUsersDataSource.getFriendshipListByUserId(userId));
    var listFriendshipList = <FriendshipList>[];

    listFriendshipList = jsonArray.map<FriendshipList>((jsonObject) => FriendshipList.fromJson(jsonObject)).toList();
    return listFriendshipList;
  }

  Future<bool> createUserFriendship(int userId) async {
    print('Entering repository create friendship.');
    var response = await remoteUsersDataSource.createUserFriendship(userId);
    return response;
  }

  Future<bool> createFriendRequest(FriendRequest entity) async {
    var response = await remoteUsersDataSource.createFriendRequest(entity);
    return response;
  }

  Future<bool> handleFriendRequest(HandleFriendRequest entity) async {
    var response = await remoteUsersDataSource.handleFriendRequest(entity);
    return response;
  }

  Future<Wallet> readUserWallet(int userId) async {
    final result = await remoteUsersDataSource.readUserWallet(userId);

    final statusCode = result['statusCode'] as int;
    final responseBody = result['body'] as String;

    if (statusCode == 200) {
      return Wallet.fromJson(jsonDecode(responseBody));
    } else if(statusCode == 404){
      throw WalletNotFoundException();
    } else {
      throw Exception('Failed to load wallet: $statusCode - $responseBody');
    }
  }

  Future<bool> createUserWallet(int userId) async {
    var response = await remoteUsersDataSource.createUserWallet(userId);
    return response;
  }

  Future<bool> updateWalletBalance(WalletBalance entity) async {
    var result = await remoteUsersDataSource.updateWalletBalance(entity);
    return result;
  }

  Future<bool> createBill(BillCreate entity) async {
    var response = await remoteUsersDataSource.createBill(entity);
    return response;
  }

  Future<bool> updateBill(Bill entity) async{
    var response = await remoteUsersDataSource.updateBill(entity);
    return response;
  }

  Future<bool> deleteBill(int billId) async{
    var response = await remoteUsersDataSource.deleteBill(billId);
    return response;
  }

  Future<Bill> getBillbyId(int billId) async{
    var response = jsonDecode(await remoteUsersDataSource.getBillbyId(billId));
    var result = Bill.fromJson(response);
    print('This is bill data ${result.billID}, ${result.userID}, ${result.billAmount}, ${result.billDate}, ${result.billDescription}');
    return result;
  }

  Future<List<Bill>> getUserBills(int userId) async{
    var jsonArray = jsonDecode(await remoteUsersDataSource.getUserBills(userId));
    var listBills = <Bill>[];

    listBills = jsonArray.map<Bill>((jsonObject) => Bill.fromJson(jsonObject)).toList();
    return listBills;
  }

  Future<BillSummary> fetchBillSummary(int userId) async{
    var result = await remoteUsersDataSource.fetchBillSummary(userId);
    return result;
  }

  Future<PaymentSummary> fetchPaymentSummary(int recipientUserId) async{
    var result = await remoteUsersDataSource.fetchPaymentSummary(recipientUserId);
    return result;
  }
}
