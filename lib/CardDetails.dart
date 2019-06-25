import 'package:flutter/material.dart';
import 'domain.dart';
import 'services.dart';
import 'package:hackathon/customcomponent.dart';
import 'paymentScreen.dart';
import 'trainPaymentScreen.dart';


class CardDetails extends StatefulWidget
{



  CardDetails();

  @override
  CardDetailsState createState() => new CardDetailsState();
}

class CardDetailsState extends State<CardDetails>{

  BankService service= new BankService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Card Details'),

      ),
      body: new Container(
          color: Colors.transparent,
          child: new Container(
            padding: const EdgeInsets.all(10.0),
            child: new ListView(
              children: <Widget>[
                getAddandRemoveCardButton(),
                new Row(
                  children: <Widget>[
                    new Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('ADDED CARDS',style: new TextStyle(fontWeight: FontWeight.normal),),

                    )
                  ],
                ),
                getListOfAddedCards(),
                new Row(
                  children: <Widget>[
                    new Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('RECENT'))
                  ],
                ),
                getHistoryCard()
              ],
            ),

          ),

      ));
  }

  Widget getAddandRemoveCardButton(){
    return new Container(

          color: Colors.transparent,
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),

          child:  new ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[

            new RawMaterialButton(

                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                      TrainPaymentScreen(transaction: new Transaction(
                          accountNumber: '',
                          topupType: 'TRAIN',
                          topupAmount: 0.0,
                          threshHoldForAlert: 0),cardData: new CardData(expiryDate:'',balance: 0.0,topupItemId:  '',email: '',mobile: '',mailAlert: false,smsAlert: false,geoAlert: true,lbAlert: false,lbLimit: 0.0,accountNumber: '',topupAmount: 0.0,topupType: ''),)),
                  );
                },

                child: Row(
                  children: const <Widget>[
                        Text('ADD A NEW CARD',
                          style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Icon(Icons.add_circle,
                        color: Colors.blue,
                        )

                        ],

                ),
                splashColor: Colors.blue,
            )
          ],

      )
    );
  }

  Widget getListOfAddedCards() {
    return new Container(
        child: new Card(
            child: new WaitAndBuild().getFutureBuilder(
                service.fetchCardData(),
                    (data) => new SingleChildScrollView(
                  child: new Column(children: getCardArray(data)),
                )
            )
        )
    );

  }
  List<Widget> getCardArray(List<CardData> list) {
    List<Widget> listOfCards = [];

    for (CardData card in list) {
      listOfCards.add(getCardData(card, () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TrainPaymentScreen(transaction: new Transaction(
                  accountNumber: '',
                  topupType: 'TRAIN',
                  topupAmount: 0.0,
                  threshHoldForAlert: 0),cardData: card,
              )
          ),
        );
      }));
    }
    return listOfCards;
  }
  Widget getCardData(CardData t, void onPressed()) {
    //IconData icon = Util.getIconDataFromCode(t.);
    //String account = Util.getDescriptionFromCode(t.type);
    String cardNum = t.cardId;
    String reference = t.reference;
    String balance = 'R ' + t.balance.toString();
    String expiryDate = t.expiryDate;

    return new RaisedButton(
        color: Colors.white,
        onPressed: () => {},
        child: new Row(
          children: <Widget>[
            Icon(Icons.credit_card,
              color: Colors.blue,
            ),
            new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new SpacedTextWidget(cardNum),
                    new SpacedTextWidget(reference + ' | ' +expiryDate +' | '+ balance)
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
            Icon(Icons.train,
              color: Colors.blue,
            ),
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
      if(t.topupType=='TRAIN'){
        transactions.add(getTransaction(t, () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TrainPaymentScreen(transaction: t,cardData: new CardData())),
          );
        }));
      }

    }
    return transactions;
  }

}