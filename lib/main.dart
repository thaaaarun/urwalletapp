import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(
        title: 'UR Wallet',
        home: Login(),
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => new Login()
        }));

User currUser;
double userDeclining;
double userUros;
double userPrinting;
String userNetId;
String aT =
    'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImpqeE45RERjZ0xwU2FxVXp6Ymw2RSJ9.eyJpc3MiOiJodHRwczovL3Vyd2FsbGV0LnVzLmF1dGgwLmNvbS8iLCJzdWIiOiJsazNOa1czczdBRjJqZllnejc0eEo2U0JXRFBxemFiYkBjbGllbnRzIiwiYXVkIjoiaHR0cHM6Ly91cndhbGxldCIsImlhdCI6MTYwMzU4MTAzOCwiZXhwIjoxNjAzNjY3NDM4LCJhenAiOiJsazNOa1czczdBRjJqZllnejc0eEo2U0JXRFBxemFiYiIsImd0eSI6ImNsaWVudC1jcmVkZW50aWFscyJ9.SGbELjN7WJInvLAdhQz8FoWLBlbegmXLiXOV8z6aPQuu6sFvuut5URuhoG8tmk3F6JM1tEwycSkxkVUpJfvVZcbGDYsIvDuprHy9-Zx6i53Z16WeWLpfgmqsd2hhxUrn7fvGA3iJbypzBbTCz2QorvkAeslL3WsjnWZ8lGmSZWZyQEwLZ9F0TTMTBLhmn-XEIo3bduW8WPGBkI2PovslperlTx-sNnIK1zUBUj4nN7IYD5paJL9-9NcHIvuGzCJretyY8HyKVc5h0SvD4Wqsj3iP6Lj-MgHfh6bW_igEu_LCyuDiyyG4SGpwm8wLirg0XGPbTFRVMBp7ATVAORjdaw';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final divider = new Divider(
    color: Colors.blueGrey,
    height: 0,
    thickness: 1,
    indent: 20,
    endIndent: 20,
  );

    double decliningState, urosState, printerState;
final GlobalKey<_HomeState> _refreshIndicatorKey = new GlobalKey<_HomeState>();

    updateValues(){
      setState(() {
        decliningState = userDeclining;
        urosState = userUros;
        printerState = userPrinting;
      });
    }

  Widget _buildTransaction(String detail, double amount, String date,
      String accountType, bool isCredit) {
    Color red_or_green = Colors.red.shade500;
    if (isCredit) red_or_green = Colors.green;

    return Container(
        margin: EdgeInsets.fromLTRB(30, 20, 30, 10),
        // padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),

        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.all(Radius.circular(20)),
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.blueGrey.withOpacity(0.5),
        //       spreadRadius: 3,
        //       blurRadius: 7,
        //       offset: Offset(0, 3), // changes position of shadow
        //     ),
        //   ],
        // ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    detail,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ]),
            Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    amount.toStringAsFixed(2) + '\$',
                    style: TextStyle(
                      fontSize: 24,
                      color: red_or_green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    accountType,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                    ),
                  ),
                ]),
          ],
        ));
  }

  
Future<User> _refresh() async {

      print(userDeclining);

  var u =   await getUserData(aT, userNetId);

        userDeclining = u.dDeclining;
        userPrinting = u.dPrinting;
        userUros = u.dUros;
        
        updateValues();
    print(userDeclining);
  return u;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('URWallet: $userNetId'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
        //toolbarHeight: 100,
        elevation: 0,
      ),
      drawer: Container(
        width: 200,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 100.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.brush),
                title: Text('Themes'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Logout'),
                onTap: () {
                  Navigator.pop(context); //exits drawer
                  Navigator.of(context).pushNamedAndRemoveUntil('/login',
                      (Route<dynamic> route) => false); //exits main page.
                },
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: Stack(children: <Widget>[
            Container(
                //background container for background color
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.lightBlueAccent,
                    Colors.blueAccent,
                    Colors.blueAccent.shade700,
                  ],
                ))),
            ListView(
              physics: ClampingScrollPhysics(),
              // padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 120.0),
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Account Balance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 160,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                        child: ListView(
                          //declining & other buttons
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            //horizontal listview widgets
                            Row(children: <Widget>[
                              ButtonTheme(
                                minWidth: 120,
                                child: RaisedButton(
                                  elevation: 8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '\$$userDeclining',
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Declining',
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 16,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Declining()),
                                    );
                                  },
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        // // color: Colors.blue,
                                        // // width: 1,
                                        style: BorderStyle.none,
                                      ),
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              ButtonTheme(
                                minWidth: 120,
                                child: RaisedButton(
                                  elevation: 8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '\$$userUros',
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'UROS',
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 16,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UROS()),
                                    );
                                  },
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        // // color: Colors.blue,
                                        // // width: 1,
                                        style: BorderStyle.none,
                                      ),
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              ButtonTheme(
                                minWidth: 120,
                                child: RaisedButton(
                                  elevation: 8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '\$$userPrinting',
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Printing',
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 16,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Printing()),
                                    );
                                  },
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        // // color: Colors.blue,
                                        // // width: 1,
                                        style: BorderStyle.none,
                                      ),
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                            ]), //Inside this row: Declining, UROS, Printing
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Divider(
                    //   color: Colors.white.withOpacity(0.2),
                    //   height: 20,
                    //   thickness: 1,
                    //   indent: 20,
                    //   endIndent: 20,
                    // ),

                    Container(
                      color: Colors.white,
                      child: Column(
                        //Transaction list here
                        children: <Widget>[
                          SizedBox(height: 10),
                          Text(
                            'Transaction History',
                            style: TextStyle(
                              color: Colors.blueGrey.shade700,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildTransaction(
                              'The Pit', 69.00, 'Today', 'Declining', false),
                          divider,
                          _buildTransaction(
                              'John', 123.45, 'Yesterday', 'UROS', true),
                          divider,
                          _buildTransaction('Hillside', 69.00, 'The Other Day',
                              'Declining', false),
                          divider,
                          _buildTransaction(
                              'Pizza', 15.00, 'Last Week', 'Declining', true),
                          divider,
                          _buildTransaction(
                              'Magic', 13356.00, 'Last Year', 'UROS', true),
                          divider,
                          _buildTransaction('Danforth', 8.00, '100 Years Ago',
                              'Printing', false),
                          divider,
                          _buildTransaction('Danforth', 8.00, '100 Years Ago',
                              'Printing', false),
                          divider,
                          _buildTransaction('Danforth', 8.00, '100 Years Ago',
                              'Printing', false),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ])),
    );
  }
}

class Declining extends StatefulWidget {
  @override
  _DecliningState createState() => _DecliningState();
}

@override
// Widget build(BuildContext context){
//   return MaterialApp(
//     home: DefaultTabController(
//
//     )
//   );
// }

class _DecliningState extends State<Declining> {
  final receiverController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    receiverController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Declining'),
          centerTitle: true,
        ),
        body: Column(children: <Widget>[
          Container(
              alignment: Alignment.centerLeft,
              height: 60.0,
              child: TextField(
                controller: receiverController,
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.account_circle, color: Colors.black),
                  hintText: "Enter receiver's netID",
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    )
                  ])),
          Container(
              alignment: Alignment.centerLeft,
              height: 60.0,
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.monetization_on, color: Colors.black),
                  hintText: "Enter receiver's netID",
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    )
                  ])),
          Center(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                color: Colors.lightBlueAccent,
                child: Text('Send'),
                onPressed: () {
                  sendMoney(
                          userNetId,
                          Text(receiverController.text).data,
                          double.parse(Text(amountController.text).data),
                          'declining',
                          aT)
                      .then((value) => {
                            getUserData(aT, userNetId).then((user) => {
                                  currUser = user,
                                  userDeclining = currUser.dDeclining,
                                  userUros = currUser.dUros,
                                  userNetId = userNetId,
                                  userPrinting = currUser.dPrinting,
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()),
                                  )
                                })
                          });
                },
              ),
              FlatButton(
                color: Colors.lightBlueAccent,
                child: Text('Request'),
                onPressed: () {},
              )
            ],
          ))
        ]));
  }
}

class UROS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('UROS'),
          centerTitle: true,
        ),
        body: Center(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(
              color: Colors.lightBlueAccent,
              child: Text('Send'),
              onPressed: () {},
            ),
            FlatButton(
              color: Colors.lightBlueAccent,
              child: Text('Request'),
              onPressed: () {},
            )
          ],
        )));
  }
}

class Printing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Printing'),
          centerTitle: true,
        ),
        body: Center(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(
              color: Colors.lightBlueAccent,
              child: Text('Send'),
              onPressed: () {},
            ),
            FlatButton(
              color: Colors.lightBlueAccent,
              child: Text('Request'),
              onPressed: () {},
            )
          ],
        )));
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final netIdController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    netIdController.dispose();
    super.dispose();
  }

  Widget _buildNetID() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //input fields
        Text('NetID',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            )),
        SizedBox(height: 10.0),
        Container(
            alignment: Alignment.centerLeft,
            height: 60.0,
            child: TextField(
              controller: netIdController,
              keyboardType: TextInputType.text,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.account_circle, color: Colors.white),
                hintText: 'Enter your NetID',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  )
                ]))
      ],
    );
  }

  Widget _buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //input fields
        Text('Password',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            )),
        SizedBox(height: 10.0),
        Container(
            alignment: Alignment.centerLeft,
            height: 60.0,
            child: TextField(
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.vpn_key, color: Colors.white),
                hintText: 'Enter your Password',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  )
                ]))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
            //background container for background color
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.lightBlueAccent,
                Colors.lightBlue,
                Colors.blueAccent,
              ],
            ))),
        Container(
          //contains everything else
          height: double.infinity,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 120.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: 50,
                        ),
                        Text(
                          '  UR Wallet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                          ),
                        )
                      ]),
                  SizedBox(height: 60.0),
                  Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  _buildNetID(),
                  SizedBox(height: 10.0),
                  _buildPassword(),
                  SizedBox(height: 10.0),
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 25.0),
                      width: double.infinity,
                      // child: RaisedButton(
                      //   elevation: 5,
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(30.0),
                      //   ),
                      //   color: Colors.white,
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(builder: (context) => Home()),
                      //     );
                      //   },
                      //   child: Text('LOGIN',
                      //       style: TextStyle(
                      //         color: Colors.lightBlue,
                      //         fontSize: 20,
                      //         letterSpacing: 1.5,
                      //       )),
                      // ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_forward,
                            size: 40, color: Colors.white),
                        onPressed: () {
                          //login auth here?

                          getUserData(aT, Text(netIdController.text).data)
                              .then((user) => {
                                    currUser = user,
                                    userDeclining = currUser.dDeclining,
                                    userUros = currUser.dUros,
                                    userNetId = Text(netIdController.text).data,
                                    userPrinting = currUser.dPrinting,
                                    if(user!=null){Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home()),
                                    )}
                                    //print(currUser.dDeclining)
                                  });
                        },
                      )),
                ]),
          ),
        ),
      ]),
    );
  }
}

Future<http.Response> sendMoney(String senderId, String receiverId,
    double dAmount, String accountType, String accessToken) async {
  return await http.post(
    Uri.parse('http://35.196.238.66:3000/sendmoney'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken'
    },
    body: jsonEncode(<String, dynamic>{
      'sender_id': senderId,
      'receiver_id': receiverId,
      'amount': dAmount,
      'account_type': accountType,
    }),
  );
}

Future<User> getUserData(String accessToken, String netId) async {
  var response = await http.get(
    Uri.parse('http://35.196.238.66:3000/refresh/$netId'),
    headers: <String, String>{'Authorization': 'Bearer $accessToken'},
  );

  if (response.statusCode == 200) {
    //print(jsonDecode(response.body)['data']);
    return User.fromJson(jsonDecode(response.body)['data']);
  } else {
    throw Exception('Bad request');
  }
}


// Future<void> _refresh() {
//   print(userDeclining);

//   getUserData(aT, userNetId).then((user) => {
//         userDeclining = currUser.dDeclining,
//         userUros = currUser.dUros,
//         userPrinting = currUser.dPrinting,
//       });
//   print(userDeclining);
// }

class User {
  final String netId;
  double dDeclining;
  double dPrinting;
  double dUros;
  var last5Transactions;

  // d for double

  User(
      {this.netId,
      this.dDeclining,
      this.dUros,
      this.dPrinting,
      this.last5Transactions});

  factory User.fromJson(Map<String, dynamic> json) {
    //print(json['transaction_history']);
    var transactions = json['transaction_history'];

    var mappedTransactions = [];

    transactions
        .forEach((k, v) => {mappedTransactions.add(Transaction.fromJson(v))});

    return User(
      dDeclining: json['account_balances']['declining'].toDouble(),
      dPrinting: json['account_balances']['printer'].toDouble(),
      dUros: json['account_balances']['uros'].toDouble(),
      last5Transactions: mappedTransactions,
    );
  }
}

class Transaction {
  //String transactionId;
  double amount;
  String currency;
  String comment;
  int timestamp;

  Transaction({this.amount, this.currency, this.comment, this.timestamp});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    //transactionId: json[''],
    return Transaction(
        amount: json['amnt'].toDouble(),
        currency: json['currency'],
        comment: json['loc'],
        timestamp: json['unix_epoch_ms']);
  }
}
