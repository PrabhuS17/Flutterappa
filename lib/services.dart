import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'domain.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'dart:math' as Math;
import 'package:vector_math/vector_math.dart' as vector;




final String url0 = "http://10.0.2.2:8080";

final String url = "http://www.mocky.io";

final String url2 = "https://mttg65bzj1.execute-api.us-east-2.amazonaws.com/api/sbt";

class BankService {
  Future<List<Transaction>> fetchTransaction() async {
    final response = await http.get("https://mttg65bzj1.execute-api.us-east-2.amazonaws.com/api/sbt");
    //final response = await http.get(url0 + '/sb/transactions');
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return Transaction.getTransactionFromJson(json.decode(response.body));
    } else {
      print(response.statusCode);
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Map getJsonFromTransaction(Transaction t) {
    Map map = {
      'accountNumber': t.accountNumber,
      'topupType': t.topupType,
      'topupAmount': t.topupAmount.toString(),
      'threshHoldForAlert': t.threshHoldForAlert.toString()
    };
    return map;
  }

  getJsonFromCardData(CardData data){
    Map map = {

      'topupItemId' : data.topupItemId,
      'balance' : data.balance.toString(),
      'topupAmount' : data.topupAmount,
      'expiryDate' : data.expiryDate,
      'mailAlert' : data.mailAlert==true?"Y":"N",
      'smsAlert' : data.smsAlert==true?"Y":"N",
      'email' : data.email,
      'mobile' : data.mobile,
      'topupType' : data.topupType,
      'geoAlert' : data.geoAlert==true?"Y":"N",
      'lbAlert' :data.lbAlert==true?"Y":"N",
      'lbLimit' : data.lbLimit,
      'accountNumber' : data.accountNumber,
      'reference' : data.reference


    };
    return map;
  }

  Future<Transaction> submitTransaction(Transaction t) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request =
        await httpClient.postUrl(Uri.parse(url0 + '/sb/pay'));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(getJsonFromTransaction(t))));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return Transaction.getFromJson(json.decode(reply));
  }

  Future<AccountInfo> fetchAccountInfo() async {
    //final response = await http.get(url + '/v2/5b75ca8f2e0000720053621c');
    final response = await http.get("https://mttg65bzj1.execute-api.us-east-2.amazonaws.com/api/sbad/10095686620");
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return AccountInfo.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
  Future<List<CardData>> fetchCardData() async {

    print("Inside fetch card");
    final response = await http.get("https://mttg65bzj1.execute-api.us-east-2.amazonaws.com/api/sbgcmall/10095686620");
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return CardData.getCardDataFromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }


  Future<CardData> submitCardTransaction(Transaction t,CardData card) async {
    print('InsideSubmitCard');
    print("Request JSON   "+json.encode(getJsonFromCardData(card)));
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request =
    //await httpClient.postUrl(Uri.parse(url0 + '/sb/createCard'));
    await httpClient.postUrl(Uri.parse(url2));
    request.headers.set('content-type', 'application/json');
    print("Request JSON   "+json.encode(getJsonFromCardData(card)));
    request.add(utf8.encode(json.encode(getJsonFromCardData(card))));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    print("Respons eJSON "+CardData.getFromJson(json.decode(reply)).toString());
    return CardData.getFromJson(json.decode(reply));
  }
}


