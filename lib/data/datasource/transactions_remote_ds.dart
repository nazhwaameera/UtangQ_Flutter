import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:utangq_app/domain/entities/bill_receipient_create.dart';
import 'package:utangq_app/domain/entities/bill_receipient_request.dart';
import 'package:utangq_app/domain/entities/payment_receipt_create.dart';

abstract class TransactionsDataSource {
  Future<String> getAllBillStatuses();
  Future<String> getAllTaxStatuses();
  Future<String> getBillRecipientAmountbyBillId(int billId);
  Future<String> getBillRecipientbyBillId(int billId);

  Future<bool> createBillReceipient(BillReceipientCreate entity);
  Future<String> getUsersPayment(int recipientUserId);
  Future<bool> handleIncomingBillReceipient(BillRecipientRequest entity);
  Future<bool> makePayment(PaymentReceiptCreate entity);
  Future<bool> confirmPayment(BillRecipientRequest entity);
}

class RemoteTransactionsDataSource implements TransactionsDataSource {
  final String baseUrl = 'https://app.actualsolusi.com/bsi/UtangQ/api';

  @override
  Future<String> getAllBillStatuses() async{
    final url = Uri.parse('$baseUrl/BillStatuses');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load bill statuses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load bill statuses: $e');
    }
  }

  @override
  Future<String> getAllTaxStatuses() async{
    final url = Uri.parse('$baseUrl/TaxStatuses');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load bill statuses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load bill statuses: $e');
    }
  }

  @override
  Future<String> getBillRecipientAmountbyBillId(int billId) async {
    final url = Uri.parse('$baseUrl/BillRecipients/total-bill-recipient-amount/$billId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to retrieve bill recipient amount by bill id: $billId. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to retrieve bill recipient amount by bill id: $billId, $e');
    }
  }

  @override
  Future<String> getBillRecipientbyBillId(int billId) async {
    final url = Uri.parse('$baseUrl/BillRecipients/bill/$billId/recipients');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to retrieve bill recipient bill id: $billId. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to retrieve bill recipient bill id: $billId, $e');
    }
  }

  @override
  Future<bool> createBillReceipient(BillReceipientCreate entity) async {
    String jsonBody = jsonEncode(entity.toJson());
    final url = Uri.parse('$baseUrl/BillRecipients');

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
            'Request failed with status code ${response.statusCode}: ${response
                .body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  @override
  Future<String> getUsersPayment(int recipientUserId) async{
    final url = Uri.parse('$baseUrl/BillRecipients/bill/recipients-desc/user/$recipientUserId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load user bills: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load user bills: $e');
    }
  }

  @override
  Future<bool> handleIncomingBillReceipient(BillRecipientRequest entity) async {
    String jsonBody = jsonEncode(entity.toJson());
    final url = Uri.parse('$baseUrl/BillRecipients/bill/recipients/handle');

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
            'Request failed with status code ${response.statusCode}: ${response
                .body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  @override
  Future<bool> makePayment(PaymentReceiptCreate entity) async{
    String jsonBody = jsonEncode(entity.toJson());
    final url = Uri.parse('$baseUrl/PaymentReceipts');

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
            'Request failed with status code ${response.statusCode}: ${response
                .body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  @override
  Future<bool> confirmPayment(BillRecipientRequest entity) async{
    String jsonBody = jsonEncode(entity.toJson());
    final url = Uri.parse('$baseUrl/PaymentReceipts/update-status');

    try {
      var response = await http.put(
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
            'Request failed with status code ${response.statusCode}: ${response
                .body}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}