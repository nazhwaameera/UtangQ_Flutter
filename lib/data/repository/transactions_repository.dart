import 'dart:convert';

import 'package:utangq_app/data/datasource/transactions_remote_ds.dart';
import 'package:utangq_app/domain/entities/bill.dart';
import 'package:utangq_app/domain/entities/bill_receipient_create.dart';
import 'package:utangq_app/domain/entities/bill_receipient_desc.dart';
import 'package:utangq_app/domain/entities/bill_receipient_request.dart';
import 'package:utangq_app/domain/entities/bill_recipient.dart';
import 'package:utangq_app/domain/entities/bill_status.dart';
import 'package:utangq_app/domain/entities/payment_receipt_create.dart';
import 'package:utangq_app/domain/entities/tax_status.dart';

class TransactionsRepository{
  var remoteTransactionsDataSource = RemoteTransactionsDataSource();

  Future<List<BillStatus>> getAllBillStatuses() async{
    var jsonArray = jsonDecode(await remoteTransactionsDataSource.getAllBillStatuses());
    var listBillStatuses = <BillStatus>[];

    listBillStatuses = jsonArray.map<BillStatus>((jsonObject) => BillStatus.fromJson(jsonObject)).toList();
    return listBillStatuses;
  }

  Future<List<TaxStatus>> getAllTaxStatuses() async{
    var jsonArray = jsonDecode(await remoteTransactionsDataSource.getAllTaxStatuses());
    var listTaxStatuses = <TaxStatus>[];

    listTaxStatuses = jsonArray.map<TaxStatus>((jsonObject) => TaxStatus.fromJson(jsonObject)).toList();
    return listTaxStatuses;
  }

  Future<double> getBillRecipientAmountbyBillId(int billId) async{
    final response = await remoteTransactionsDataSource.getBillRecipientAmountbyBillId(billId);
    final result = double.parse(response);
    return result;
  }

  Future<List<BillRecipient>> getBillRecipientbyBillId(int billId) async{
    var jsonArray = jsonDecode(await remoteTransactionsDataSource.getBillRecipientbyBillId(billId));
    var listBillRecipients = <BillRecipient>[];

    listBillRecipients = jsonArray.map<BillRecipient>((jsonObject) => BillRecipient.fromJson(jsonObject)).toList();
    return listBillRecipients;
  }

  Future<bool> createBillReceipient(BillReceipientCreate entity) async {
    var result = await remoteTransactionsDataSource.createBillReceipient(entity);
    return result;
  }

  Future<List<BillRecipientWithDesc>> getUserPayment(int recipientUserId) async{
    var jsonArray = jsonDecode(await remoteTransactionsDataSource.getUsersPayment(recipientUserId));
    var listPayments = <BillRecipientWithDesc>[];

    listPayments = jsonArray.map<BillRecipientWithDesc>((jsonObject) => BillRecipientWithDesc.fromJson(jsonObject)).toList();
    return listPayments;
  }

  Future<bool> handleIncomingBillReceipient(BillRecipientRequest entity) async{
    var result = await remoteTransactionsDataSource.handleIncomingBillReceipient(entity);
    return result;
  }

  Future<bool> makePayment(PaymentReceiptCreate entity) async{
    var result = await remoteTransactionsDataSource.makePayment(entity);
    return result;
  }

  Future<bool> confirmPayment(BillRecipientRequest entity) async{
    var result = await remoteTransactionsDataSource.confirmPayment(entity);
    return result;
  }
}