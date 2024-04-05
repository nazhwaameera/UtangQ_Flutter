import 'package:http/http.dart' as http;
import 'package:utangq_app/data/exception/friendship_404_exception.dart';
import 'package:utangq_app/domain/entities/bill.dart';
import 'package:utangq_app/domain/entities/bill_create.dart';
import 'package:utangq_app/domain/entities/bill_summary.dart';
import 'package:utangq_app/domain/entities/friend_request.dart';
import 'package:utangq_app/domain/entities/handle_friend_request.dart';
import 'dart:convert';
import 'package:utangq_app/domain/entities/login_user.dart';
import 'package:utangq_app/domain/entities/payment_summary.dart';
import 'package:utangq_app/domain/entities/user_create.dart';
import 'package:utangq_app/domain/entities/wallet_balance.dart';

abstract class UsersDataSource {
  Future<String> getAllUsers();

  Future<bool> createUser(UserCreate entity);

  Future<String> loginUser(String username, String password);

  Future<String> getUserFriendship(int userId);

  Future<String> getUserFriends(int friendshipId);

  Future<String> getUserNonFriends(int friendshipId);

  Future<String> getPendingFriendshipList(int receiverUserId);

  Future<String> getFriendshipListByUserId(int userId);

  Future<bool> createUserFriendship(int userId);

  Future<bool> createFriendRequest(FriendRequest entity);

  Future<bool> handleFriendRequest(HandleFriendRequest entity);

  Future<String> getAllFriendshipStatus();

  Future<Map<String, dynamic>> readUserWallet(int userId);

  Future<bool> createUserWallet(int userId);

  Future<bool> updateWalletBalance(WalletBalance entity);

  Future<bool> createBill(BillCreate entity);

  Future<bool> updateBill(Bill entity);

  Future<bool> deleteBill(int billId);

  Future<String> getBillbyId(int billId);

  Future<String> getUserBills(int userId);

  Future<BillSummary> fetchBillSummary(int userId);

  Future<PaymentSummary> fetchPaymentSummary(int recipientUserId);
}

class RemoteUsersDataSource implements UsersDataSource {
  final String baseUrl = 'https://app.actualsolusi.com/bsi/UtangQ/api';

  @override
  Future<String> getAllUsers() async {
    final url = Uri.parse('$baseUrl/Users');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, return the response body
        return response.body;
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      // If an error occurs during the HTTP request, throw an exception
      throw Exception('Failed to load users: $e');
    }
  }

  @override
  Future<String> getAllFriendshipStatus() async{
    final url = Uri.parse('$baseUrl/FriendshipStatus');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  @override
  Future<bool> createUser(UserCreate entity) async {
    String jsonBody = jsonEncode(entity.toJson());
    final url = Uri.parse('$baseUrl/Users');

    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );
      // Check the status code of the response
      if (response.statusCode == 200) {
        // User created successfully
        return true;
      } else if (response.statusCode == 400) {
        // Bad request, handle error (e.g., display error message)
        print('Bad request: ${response.body}');
        return false;
      } else {
        // Other status codes, handle error (e.g., display error message)
        print(
            'Request failed with status code ${response.statusCode}: ${response.body}');
        return false;
      }
    } catch (e) {
      // Exception occurred during HTTP request
      print('Exception: $e');
      return false;
    }
  }

  @override
  Future<String> loginUser(String username, String password) async {
    final url = Uri.parse('$baseUrl/Users/login');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'Username': username,
          'UserPassword': password,
        }),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Login failed, return null
        throw Exception('Failed to login. Wrong username and/or password.');
      }
    } catch (e) {
      // Error occurred during HTTP request
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<String> getUserFriendship(int userId) async {
    print('get user friendship for id : $userId');
    final url = Uri.parse('$baseUrl/Friendships/user/$userId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 404) {
        throw FriendshipNotFoundException();
      } else {
        throw Exception(
            'Failed to load user friendship: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load user friendship: $e');
    }
  }

  @override
  Future<String> getUserFriends(int friendshipId) async {
    final url = Uri.parse('$baseUrl/Users/friends/$friendshipId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load user friends: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load user friends: $e');
    }
  }

  @override
  Future<String> getUserNonFriends(int friendshipId) async {
    final url = Uri.parse('$baseUrl/Users/nonfriends/$friendshipId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load user non friends: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load user non friends: $e');
    }
  }

  @override
  Future<bool> createUserFriendship(int userId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/Friendships?userId=$userId'));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to create friendship.');
      }
    } catch (e) {
      throw Exception('Failed to create friendship: $e');
    }
  }

  @override
  Future<bool> createFriendRequest(FriendRequest entity) async{
    String jsonBody = jsonEncode(entity.toJson());
    final url = Uri.parse('$baseUrl/FriendshipLists');

    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        print('Bad request: ${response.body}');
        return false;
      } else {
        print(
            'Request failed with status code ${response.statusCode}: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  @override
  Future<bool> handleFriendRequest(HandleFriendRequest entity) async{
    String jsonBody = jsonEncode(entity.toJson());
    final url = Uri.parse('$baseUrl/FriendshipLists/handle-friend-request');

    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        print('Bad request: ${response.body}');
        return false;
      } else {
        print(
            'Request failed with status code ${response.statusCode}: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  @override
  Future<String> getPendingFriendshipList(int receiverUserId) async {
    final url = Uri.parse('$baseUrl/FriendshipLists/pending-friend-requests/$receiverUserId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(
            'Failed to load pending friendship list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load pending friendship list: $e');
    }
  }

  @override
  Future<String> getFriendshipListByUserId(int userId) async{
    final url = Uri.parse('$baseUrl/FriendshipLists/userId/$userId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(
            'Failed to load friendship list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load friendship list: $e');
    }
  }


  @override
  Future<Map<String, dynamic>> readUserWallet(int userId) async {
    final url = Uri.parse('$baseUrl/Wallets/user/$userId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return {
          'statusCode': response.statusCode,
          'body': response.body,
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'body': '',
        };
      }
    } catch (e) {
      return {
        'statusCode': -1, // Some default value to indicate error
        'body': e.toString(),
      };
    }
  }

  @override
  Future<bool> createUserWallet(int userId) async {
    final url = Uri.parse('$baseUrl/Wallets');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'UserID': userId,
          'WalletBalance': 0.00,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to create wallet.');
      }
    } catch (e) {
      throw Exception('Failed to create wallet: $e');
    }
  }

  @override
  Future<bool> updateWalletBalance(WalletBalance entity) async {
    final url = Uri.parse('$baseUrl/Wallets/balance');
    String jsonBody = jsonEncode(entity.toJson());
    try {
      var response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );
      // Check the status code of the response
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        print('Bad request: ${response.body}');
        return false;
      } else {
        print(
            'Request failed with status code ${response.statusCode}: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  @override
  Future<bool> createBill(BillCreate entity) async {
    String jsonBody = jsonEncode(entity.toJson());
    final url = Uri.parse('$baseUrl/Bills');

    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );
      // Check the status code of the response
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        print('Bad request: ${response.body}');
        return false;
      } else {
        print(
            'Request failed with status code ${response.statusCode}: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  @override
  Future<bool> updateBill(Bill entity) async {
    String jsonBody = jsonEncode(entity.toJson());
    final url = Uri.parse('$baseUrl/Bills/update');

    try {
      var response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );
      // Check the status code of the response
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        print('Bad request: ${response.body}');
        return false;
      } else {
        print(
            'Request failed with status code ${response.statusCode}: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  @override
  Future<bool> deleteBill(int billId) async {
    final url = Uri.parse('$baseUrl/Bills/$billId');
    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete bill: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete bill: $e');
    }
  }

  @override
  Future<String> getBillbyId(int billId) async {
    final url = Uri.parse('$baseUrl/Bills/$billId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, return the response body
        return response.body;
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to load bill: ${response.statusCode}');
      }
    } catch (e) {
      // If an error occurs during the HTTP request, throw an exception
      throw Exception('Failed to load bill: $e');
    }
  }

  @override
  Future<String> getUserBills(int userId) async {
    final url = Uri.parse('$baseUrl/Bills/bills/$userId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, return the response body
        return response.body;
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to load user bills: ${response.statusCode}');
      }
    } catch (e) {
      // If an error occurs during the HTTP request, throw an exception
      throw Exception('Failed to load user bills: $e');
    }
  }

  @override
  Future<BillSummary> fetchBillSummary(int userId) async {
    final url = '$baseUrl/Bills';
    final acceptedUrl = '$url/totalBillAmountCreatedAccepted/$userId';
    final awaitingUrl = '$url/totalBillAmountCreatedAwaiting/$userId';
    final paidUrl = '$url/totalBillAmountCreatedPaid/$userId';
    final pendingUrl = '$url/totalBillAmountCreatedPending/$userId';
    final createdUrl = '$url/totalBillAmountCreated/$userId';
    final rejectedUrl = '$url/totalBillAmountCreatedRejected/$userId';
    final unassignedUrl = '$url/totalUnassignedBillAmount/$userId';

    final acceptedResponse = await http.get(Uri.parse(acceptedUrl));
    final awaitingResponse = await http.get(Uri.parse(awaitingUrl));
    final paidResponse = await http.get(Uri.parse(paidUrl));
    final pendingResponse = await http.get(Uri.parse(pendingUrl));
    final createdResponse = await http.get(Uri.parse(createdUrl));
    final rejectedResponse = await http.get(Uri.parse(rejectedUrl));
    final unassignedResponse = await http.get(Uri.parse(unassignedUrl));

    // Log the responses
    // print('Accepted Response: ${acceptedResponse.body}');
    // print('Awaiting Response: ${awaitingResponse.body}');
    // print('Paid Response: ${paidResponse.body}');
    // print('Pending Response: ${pendingResponse.body}');
    // print('Created Response: ${createdResponse.body}');
    // print('Rejected Response: ${rejectedResponse.body}');
    // print('Unassigned Response: ${unassignedResponse.body}');

    if (acceptedResponse.statusCode == 200 &&
        awaitingResponse.statusCode == 200 &&
        paidResponse.statusCode == 200 &&
        pendingResponse.statusCode == 200 &&
        createdResponse.statusCode == 200 &&
        rejectedResponse.statusCode == 200 &&
        unassignedResponse.statusCode == 200) {
      // Extract specific values and parse them into doubles
      final totalBillAmountCreatedAccepted =
          double.parse(acceptedResponse.body);
      final totalBillAmountCreatedAwaiting =
          double.parse(awaitingResponse.body);
      final totalBillAmountCreatedPaid = double.parse(paidResponse.body);
      final totalBillAmountCreatedPending = double.parse(pendingResponse.body);
      final totalBillAmountCreated = double.parse(createdResponse.body);
      final totalBillAmountCreatedRejected =
          double.parse(rejectedResponse.body);
      final totalBillUnassigned = double.parse(unassignedResponse.body);

      return BillSummary(
        totalBillAmountCreatedAccepted: totalBillAmountCreatedAccepted,
        totalBillAmountCreatedAwaiting: totalBillAmountCreatedAwaiting,
        totalBillAmountCreatedPaid: totalBillAmountCreatedPaid,
        totalBillAmountCreatedPending: totalBillAmountCreatedPending,
        totalBillAmountCreated: totalBillAmountCreated,
        totalBillAmountCreatedRejected: totalBillAmountCreatedRejected,
        totalBillUnassigned: totalBillUnassigned,
      );
    } else {
      throw Exception('Failed to load bill summary');
    }
  }

  @override
  Future<PaymentSummary> fetchPaymentSummary(int recipientUserId) async {
    final url = '$baseUrl/Bills';
    final acceptedUrl = '$url/totalBillAmountAccepted/$recipientUserId';
    final awaitingUrl = '$url/totalBillAmountAwaiting/$recipientUserId';
    final paidUrl = '$url/totalBillAmountPaid/$recipientUserId';
    final pendingUrl = '$url/totalBillAmountPending/$recipientUserId';

    final acceptedResponse = await http.get(Uri.parse(acceptedUrl));
    final awaitingResponse = await http.get(Uri.parse(awaitingUrl));
    final paidResponse = await http.get(Uri.parse(paidUrl));
    final pendingResponse = await http.get(Uri.parse(pendingUrl));

    if (acceptedResponse.statusCode == 200 &&
        awaitingResponse.statusCode == 200 &&
        paidResponse.statusCode == 200 &&
        pendingResponse.statusCode == 200) {
      // Extract specific values and parse them into doubles
      final totalBillAmountAccepted = double.parse(acceptedResponse.body);
      final totalBillAmountAwaiting = double.parse(awaitingResponse.body);
      final totalBillAmountPaid = double.parse(paidResponse.body);
      final totalBillAmountPending = double.parse(pendingResponse.body);

      return PaymentSummary(
        totalBillAmountAccepted: totalBillAmountAccepted,
        totalBillAmountAwaiting: totalBillAmountAwaiting,
        totalBillAmountPaid: totalBillAmountPaid,
        totalPendingAmountOwed: totalBillAmountPending,
      );
    } else {
      throw Exception('Failed to load payment summary');
    }
  }
}
