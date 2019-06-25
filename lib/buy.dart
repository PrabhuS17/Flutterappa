import 'package:flutter/material.dart';
import 'customcomponent.dart';
import 'domain.dart';
import 'services.dart';
import 'paymentScreen.dart';
import 'package:hackathon/CardDetails.dart';

class BuyScreenWidget extends StatefulWidget {
  final BankService service;

  BuyScreenWidget({@required this.service});

  @override
  State<StatefulWidget> createState() => new BuyScreenState(service: service);
}

class BuyScreenState extends State {
  BankService service;

  BuyScreenState({@required this.service});

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.transparent,
      child: new Container(
          padding: const EdgeInsets.all(10.0),
          child: new ListView(
            children: <Widget>[
              getButtonsCard(),
              new Row(
                children: <Widget>[
                  new Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('RECENT'))
                ],
              ),
              getHistoryCard()
            ],
          )),
    );
  }

  Widget getButtonsCard() {
    var action = (type) {
      if(type=='TRAIN') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CardDetails()),
        );
      }
      else{
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PaymentScreen(
            transaction: new Transaction(
                accountNumber: '',
                topupType: type,
                topupAmount: 0.0,
          threshHoldForAlert: 0))),
        );
      }
    };

    //PaymentScreen(
      //  transaction: new Transaction(
        //    account: '',
          //  type: type,
            //amount: 0.0,
            //threshHoldForAlert: 0))

    return new Card(
      child: new Column(
        children: <Widget>[
          new SpacedTextWidget("Choose your prepaid"),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Util.getButtonWithAction(
                  Icons.mobile_screen_share, 'Airtime', 1.0, 'AIRT',action),
              Util.getButtonWithAction(Icons.sms, 'SMS', 1.0, 'SMS',action),
              Util.getButtonWithAction(Icons.wifi, 'Data', 1.0, 'DATA',action),
              Util.getButtonWithAction(
                  Icons.train, 'Gautrain', 1.0, 'TRAIN',action),
            ],
          )
        ],
      ),
    );
  }

  Widget getTransaction(Transaction t, void onPressed()) {
    IconData icon = Util.getIconDataFromCode(t.topupType);
    String account = Util.getDescriptionFromCode(t.topupType);
    String desc = t.topupItemId;
    String amount = 'R ' + t.topupAmount.toString();

    return new RaisedButton(
        color: Colors.white,
        onPressed: () => {},
        child: new Row(
          children: <Widget>[
            Util.getButton(icon, '', 1.0),
            new Expanded(
                child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new SpacedTextWidget(account),
                new SpacedTextWidget(desc + ' | ' + amount)
              ],
            )),
            new IconButton(
                onPressed: onPressed,
                icon: new Icon(
                  Icons.arrow_right,
                  color: Colors.red,
                ))
          ],
        ));
  }

  Widget getHistoryCard() {
    return new Container(
        child: new Card(
            child: new WaitAndBuild().getFutureBuilder(
                service.fetchTransaction(),
                (data) => new SingleChildScrollView(
                      child: new Column(children: getTransactionArray(data)),
                    ))));
  }

  List<Widget> getTransactionArray(List<Transaction> tranList) {
    List<Widget> transactions = [];

    for (Transaction t in tranList) {
      transactions.add(getTransaction(t, () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PaymentScreen(transaction: t)),
        );
      }));
    }
    return transactions;
  }
}
