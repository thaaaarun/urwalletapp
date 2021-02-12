import 'package:http/http.dart' as http;
import 'dart:convert';

String aT = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImpqeE45RERjZ0xwU2FxVXp6Ymw2RSJ9.eyJpc3MiOiJodHRwczovL3Vyd2FsbGV0LnVzLmF1dGgwLmNvbS8iLCJzdWIiOiJsazNOa1czczdBRjJqZllnejc0eEo2U0JXRFBxemFiYkBjbGllbnRzIiwiYXVkIjoiaHR0cHM6Ly91cndhbGxldCIsImlhdCI6MTYwMzU4MTAzOCwiZXhwIjoxNjAzNjY3NDM4LCJhenAiOiJsazNOa1czczdBRjJqZllnejc0eEo2U0JXRFBxemFiYiIsImd0eSI6ImNsaWVudC1jcmVkZW50aWFscyJ9.SGbELjN7WJInvLAdhQz8FoWLBlbegmXLiXOV8z6aPQuu6sFvuut5URuhoG8tmk3F6JM1tEwycSkxkVUpJfvVZcbGDYsIvDuprHy9-Zx6i53Z16WeWLpfgmqsd2hhxUrn7fvGA3iJbypzBbTCz2QorvkAeslL3WsjnWZ8lGmSZWZyQEwLZ9F0TTMTBLhmn-XEIo3bduW8WPGBkI2PovslperlTx-sNnIK1zUBUj4nN7IYD5paJL9-9NcHIvuGzCJretyY8HyKVc5h0SvD4Wqsj3iP6Lj-MgHfh6bW_igEu_LCyuDiyyG4SGpwm8wLirg0XGPbTFRVMBp7ATVAORjdaw';
void main(List<String> arguments) async{
  //var resp = await sendMoney('mgorshko','sbendre', 4.30,'declining',aT);
  String netId = 'mgorshko';
  var resp = await getUserData(aT,netId);
}




Future<http.Response> sendMoney(String senderId, String receiverId, double dAmount, String accountType, String accessToken) async {
  return  await http.post(
    Uri.parse('http://35.196.238.66:3000/sendmoney'),
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $accessToken'},
    body: jsonEncode(<String, dynamic>{
      'sender_id': senderId,
      'receiver_id': receiverId,
      'amount': dAmount,
      'account_type':accountType,
    }),
  );

}



Future<User> getUserData(String accessToken, String netId) async {
  
  var response = await http.get(Uri.parse('http://35.196.238.66:3000/refresh/$netId'),
    headers: <String, String> {
    'Authorization': 'Bearer $accessToken'},
  );

  if (response.statusCode == 200)
  {
    //print(jsonDecode(response.body)['data']);
    return User.fromJson(jsonDecode(response.body)['data']);
  }else
  {
    throw Exception ('Bad request');
  }

  
}

class User {

  final String netId;
  double dDeclining;
  double dPrinting;
  double dUros;
  var last5Transactions;

  // d for double

  User({this.netId, this.dDeclining, this. dUros, this.dPrinting, this.last5Transactions});

  factory User.fromJson(Map<String, dynamic> json){
    //print(json['transaction_history']);
      var transactions = json['transaction_history'];

      var mappedTransactions = [];
  
      transactions.forEach((k,v) => {
        
         mappedTransactions.add(Transaction.fromJson(v))

      });


    
    return User(
      dDeclining: json['account_balances']['declining'],
      dPrinting: json['account_balances']['printing'],
      dUros: json['account_balances']['uros'],
      last5Transactions : mappedTransactions,
    );
  } 
}

class Transaction {
  //String transactionId;
  double amount;
  String currency;
  String comment;
  int timestamp;

  Transaction({this.amount, this. currency, this.comment, this.timestamp});

  factory Transaction.fromJson(Map<String,dynamic> json){
    //transactionId: json[''],
    return Transaction (amount:  json['amnt'].toDouble(), 
    currency: json['currency'],
    comment: json['loc'],
    timestamp: json['unix_epoch_ms']
    );
  }

}

