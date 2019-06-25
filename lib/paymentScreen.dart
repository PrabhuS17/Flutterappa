import 'package:flutter/material.dart';
import 'domain.dart';
import 'customcomponent.dart';
import 'services.dart';

class PaymentScreen extends StatefulWidget {
  final Transaction transaction;

  PaymentScreen({Key key, @required this.transaction}) : super(key: key);

  PaymentScreenState createState() =>
      new PaymentScreenState(transaction: transaction);
}

class PaymentScreenState extends State<PaymentScreen> {
  final Transaction transaction;

  PaymentScreenState({this.transaction});

  BankService service = new BankService();

  bool checkBoxValue = true;

  final myController = TextEditingController();

  final alertAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Purchase details"),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () {
                print('Alert amount is'+(alertAmountController.text.isEmpty?'0':alertAmountController.text));
                service
                    .submitTransaction(new Transaction(
                    accountNumber: transaction.accountNumber,
                    topupType: transaction.topupType,
                    topupAmount: double.parse(myController.text),
                        threshHoldForAlert:
                            int.parse(alertAmountController.text.isEmpty?'0':alertAmountController.text)))
                    .then((tr) {
                  Navigator.pop(context);
                });
              },
              child: Text('Confirm'),
            )
          ],
        ),
        body: new Container(
            color: Colors.transparent,
            child: new Container(
              padding: const EdgeInsets.all(15.0),
              child: new ListView(children: <Widget>[
                new SpacedTextWidget("FROM"),
                getAccountPanel(),
                new SpacedTextWidget("TO"),
                getToCard(transaction),
                new SpacedTextWidget("NUMBER TO TOP UP"),
                new Container(
                  child: new TextFormField(
                    initialValue: transaction.accountNumber,
                    decoration: new InputDecoration(
                        labelText:
                            Util.inputFieldNameFromCode(transaction.topupType),
                        fillColor: Colors.blue),
                    keyboardType: TextInputType.number,
                  ),
                  padding: EdgeInsets.all(15.0),
                ),
                new SpacedTextWidget("DISCLAIMER")
              ]),
            )));
  }

  Widget getToCard(Transaction t) {
    myController.text = t.topupAmount.toString();

    List<Widget> toCardElements = getToCardElements(t);
    if (t.topupType == 'TRAIN') {
      toCardElements.add(getAlertAmountField(t));
    }
    return new Container(
        child: new Card(
      child: new Column(children: toCardElements),
    ));
  }

  List<Widget> getToCardElements(Transaction t) {
    return [
      new Row(
        children: <Widget>[
          Util.getButton(Util.getIconDataFromCode(t.topupType), '', 1.0),
          new Expanded(
              child: new SpacedTextWidget(Util.getDescriptionFromCode(t.topupType)))
        ],
      ),
      new Row(
        children: <Widget>[
          new Expanded(
              child: new Container(
                  padding: EdgeInsets.all(10.0),
                  child: new TextFormField(
                    controller: myController,
                    decoration: new InputDecoration(labelText: "Amount"),
                    keyboardType: TextInputType.number,

                  ))),
        ],
      )
    ];
  }

  Widget getAlertAmountField(Transaction t) {
    final int threshHoldAmt = t.threshHoldForAlert;
    alertAmountController.text = threshHoldAmt.toString();
    return new Row(
      children: <Widget>[
        new Expanded(
            child: new Container(
                padding: EdgeInsets.all(10.0),
                child: new TextFormField(
                  controller: alertAmountController,
                  decoration: new InputDecoration(labelText: "Alert below"),
                  keyboardType: TextInputType.number,
                ))),
      ],
    );
  }

  Widget getCardDetailCard(Transaction t) {
    return new Container(
        child: new Card(child: new Column(children: <Widget>[])));
  }

  Widget getAccountPanel() {
    return new WaitAndBuild<AccountInfo>()
        .getFutureBuilder(service.fetchAccountInfo(), (data) {
      Widget row = new Row(
        children: <Widget>[
          new Icon(Icons.account_balance),
          new Expanded(
              child: new Column(
            children: <Widget>[
              new SpacedTextWidget(data.accountType),
              new SpacedTextWidget(data.accountNumber),
              new SpacedTextWidget("AVAILABLE BALANCE"),
              new SpacedTextWidget("R " + data.currentBalance.toString())
            ],
          ))
        ],
      );
      return Util.getButtonsCard(row);
    });
  }
}
