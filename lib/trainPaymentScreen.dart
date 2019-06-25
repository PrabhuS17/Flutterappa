import 'package:flutter/material.dart';
import 'domain.dart';
import 'customcomponent.dart';
import 'services.dart';

class TrainPaymentScreen extends StatefulWidget {
  final Transaction transaction;
  final CardData cardData;
  TrainPaymentScreen({Key key, @required this.transaction,@required this.cardData}) : super(key: key);

  PaymentScreenState createState() =>
      new PaymentScreenState(transaction: transaction,cardData: cardData);
}

class PaymentScreenState extends State<TrainPaymentScreen> {
  final Transaction transaction;
  final CardData cardData;
  PaymentScreenState({this.transaction,this.cardData});

  BankService service = new BankService();

  bool _mailCheckBoxValue = true;

  bool _smsCheckBoxValue = true;



  var myController ;

  var alertAmountController ;

  var cardNumberController ;

  var smsNumberController; // = TextEditingController.fromValue(new TextEditingValue(text: '+27 | '));

  var mailTextController;

  bool _switchValue = false;

  bool _geoSwitchValue = true;

  var referenceTextController;

  @override
  void initState() {
    super.initState();
    cardNumberController = new TextEditingController(text: cardData.cardId==null?transaction.topupItemId:cardData.cardId );
    mailTextController = new TextEditingController(text: cardData.email==null?transaction.email:cardData.email);
    myController = new TextEditingController(text: transaction.topupAmount.toString());
    alertAmountController = new TextEditingController(text: cardData.lbLimit==null?transaction.lbLimit.toString():cardData.lbLimit.toString());
    //smsNumberController = TextEditingController.fromValue(new TextEditingValue(text: '+27 | '));
    smsNumberController = new TextEditingController(text: cardData.mobile==null?transaction.mobile:cardData.mobile);
    referenceTextController = new TextEditingController(text: cardData.reference==null?transaction.reference:cardData.reference);
    _switchValue = cardData.lbAlert==null?transaction.lbAlert:cardData.lbAlert;
    //_mailCheckBoxValue = cardData.mailAlert;
    //_smsCheckBoxValue = cardData.smsAlert;
    _geoSwitchValue = cardData.geoAlert==null?transaction.geoAlert:cardData.geoAlert;
  }

  void onChanged(bool value){
    setState(() {
      _switchValue = value;
      _smsCheckBoxValue = value;
      _mailCheckBoxValue = value;
    });

  }

  void onMailCheckBoxChanged(bool value){
    setState(() {
      _mailCheckBoxValue = value;
    });
  }

  void onSMSCheckBoxChanged(bool value){
    setState(() {
      _smsCheckBoxValue = value;
    });
  }
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
                if(_switchValue==false){
                  _mailCheckBoxValue=false;
                  _smsCheckBoxValue=false;
                  mailTextController.text = '';
                  smsNumberController.text = '';
                  alertAmountController.text = '0';
                }
                service
                    .submitCardTransaction(new Transaction(
                    accountNumber: transaction.accountNumber,
                    topupType: transaction.topupType,
                    topupAmount: double.parse(myController.text),
                    threshHoldForAlert:
                    int.parse(alertAmountController.text.isEmpty?'0':alertAmountController.text)),
                    new CardData(
                      expiryDate: '',
                      topupItemId: cardNumberController.text,
                      balance: double.parse(myController.text),
                      email: mailTextController.text,
                      mobile: smsNumberController.text,
                      mailAlert: _mailCheckBoxValue,
                      smsAlert: _smsCheckBoxValue,
                      geoAlert: _geoSwitchValue,
                      lbAlert: _switchValue,
                      lbLimit: double.parse(alertAmountController.text),
                      accountNumber: '10095686620',
                      topupAmount:  double.parse(myController.text),
                      topupType: 'TRAIN',
                      reference: 'My Card'
                    )
                )
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
              padding: const EdgeInsets.all(10.0),
              child: new ListView(children: <Widget>[
                new SpacedTextWidget("FROM: (ACCOUNT)"),
                getAccountPanel(),
                new SpacedTextWidget("TO: (CARD DETAILS)"),

                getToCard(transaction,cardData),
                new Container(
                    child: new SwitchListTile(
                    title: new Text("Alert me for low balance...."),
                    secondary: const Icon(Icons.notifications),
                    value: _switchValue, 
                    onChanged: (bool value){onChanged(value);},
                    activeColor: Colors.blue,
                    )),

                getAlertDetailsPanel(_switchValue,transaction),
                new Container(
                    child: new SwitchListTile(
                      title: new Text("GEO Alert"),
                      secondary: const Icon(Icons.notifications_active),
                      value: _geoSwitchValue,
                      onChanged: (bool value){onGeoSwitch(value);},
                      activeColor: Colors.blue,
                    )),

              ]),
            )));
  }

  Widget getToCard(Transaction t,CardData cardData) {
    //myController.text = t.amount.toString();

    List<Widget> toCardElements = getToCardElements(t,cardData);

    return new Container(
        child: new Card(
          child: new Column(children: toCardElements),
        ));
  }

  List<Widget> getToCardElements(Transaction t,CardData data) {
    //  cardNumberController.text = data.cardId;
    return [
      new Row(
        children: <Widget>[
          new Expanded(
            child: new Container(
                padding: EdgeInsets.all(10.0),
                child: new TextFormField(

                  decoration: new InputDecoration(
                      labelText: "Reference",
                      fillColor: Colors.blue),
                  keyboardType: TextInputType.number,

                  controller: referenceTextController,
                )
            ),
          )
        ],
      ),
      new Row(
        children: <Widget>[
          new Expanded(
            child: new Container(
                padding: EdgeInsets.all(10.0),
                child: new TextFormField(

                  decoration: new InputDecoration(
                      labelText:
                      Util.inputFieldNameFromCode(transaction.topupType),
                      fillColor: Colors.blue),
                  keyboardType: TextInputType.number,

                  controller: cardNumberController,
                )
            ),
          )
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
      ),

    ];
  }

  List<Widget> getAlertAmountField(Transaction t) {
    //final int threshHoldAmt = t.threshHoldForAlert;
   // alertAmountController.text = threshHoldAmt.toString();

    return [
      new Container(

       child: new Column(
         children: <Widget>[
           new Row(
                mainAxisSize: MainAxisSize.min,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 new Expanded(child: getMailCheckBox()),
                 new Expanded(child: getSMSCheckBox()),

               ]
           ),
           getAlertAmountTextField(),
           getMailTextFeild(_mailCheckBoxValue),
           getSMSTextFeild(_smsCheckBoxValue),
         ],
       ),
      ),

    ];
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

  Widget getAlertDetailsPanel(bool value,Transaction t){
    print(value);
    List<Widget> toAlertElements = new List();
    if(value) {
      toAlertElements = getAlertAmountField(t);
    }
    return new Container(child: new Card(child: new Column(children: toAlertElements),));



  }

  Widget getMailCheckBox(){

    return new CheckboxListTile(
        title: new Text('Email Alert'),
        value: _mailCheckBoxValue,
        onChanged: (bool value){},

    );
  }

  Widget getSMSCheckBox(){
    return new CheckboxListTile(
      title: new Text('SMS Alert'),
      value: _smsCheckBoxValue,
      onChanged: (bool value){},

    );
  }
  Widget getMailTextFeild(bool value){

    if(value){
      return new Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          new Expanded(child: new Container(
              padding: EdgeInsets.all(10.0),
              child: new TextFormField(
                decoration: new InputDecoration(labelText: "Enter your mail id..."),
                keyboardType: TextInputType.emailAddress,
                controller: mailTextController,
              )

          ))

        ],
      );
    }

    return new Row(

    );

  }
  Widget getSMSTextFeild(bool value){
    if(value){
      return new Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Expanded(child: new Container(
            padding: EdgeInsets.all(10.0),
            child: new TextFormField(

              controller: smsNumberController,
              decoration: new InputDecoration(labelText: "Enter your mobile number..."),
              keyboardType: TextInputType.number,
            ),
          ))

        ],
      );
    }
    return new Row(

    );
  }

  Widget getAlertAmountTextField(){
    return  new Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Expanded(
            child: new Container(
                padding: EdgeInsets.all(10.0),
                child: new TextFormField(
                  decoration: new InputDecoration(labelText: "Alert below"),
                  keyboardType: TextInputType.number,
                  controller: alertAmountController,



                ))),
      ],
    );
  }

  void onGeoSwitch(bool value) {
    setState(() {
      _geoSwitchValue = value;
    });
  }
}
