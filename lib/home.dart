import 'package:flutter/material.dart';
import 'customcomponent.dart';
import 'services.dart';
import 'domain.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State {

  BankService service = new BankService();

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.transparent,
      child: new Container(
          padding: const EdgeInsets.all(10.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[getAccountCard(), getBeneficiaryCard()],
          )),
    );
  }

  Widget getFlatButtonWithText(String text) {
    return new FlatButton(
      child: Text(text),
      onPressed: () {
        /* ... */
      },
    );
  }

  Widget getBeneficiaryCard() {
    
    return new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: const Icon(
              Icons.person,
              color: Colors.blue,
              size: 70.0,
            ),
            title: const Text('8 Beneficiaries'),
          ),
          new ButtonTheme.bar(
            // make buttons use the appropriate styles for cards
            child: new ButtonBar(
              children: <Widget>[
                getFlatButtonWithText('MAKE PAYMENT'),
                getFlatButtonWithText('ADD BENEFICIARY'),
              ],
            ),
          ),
//          new WaitAndBuild().getFutureBuilder(
//              l.decideIfUserNeedsToBeAlerted(), displayDistance)
        ],
      ),
    );
  }

  Widget getLocation(Map<String, double> loc){
      List<Text> texts = [];
      loc.keys.forEach((s) {
        texts.add(Text(s + ':' + loc[s].toString()));
      });
//      texts.add(Text(l.getDistance(-26.143770, 28.040565, -26.107567, 28.056702).toString()));
      return new Column(children: texts);
  }

  Widget displayDistance(var locs){
    List<String> t=locs;
    t.forEach((s){
      print(s);
    });
    List<Text> texts = [];
    t.forEach((s) {
      texts.add(Text(s));
    });
    return new Column(children: texts);
  }

  Widget getAccountCard() {
    return new Card(
      child: new Container(
          padding: const EdgeInsets.all(20.0),
          child: new WaitAndBuild<AccountInfo>()
              .getFutureBuilder(service.fetchAccountInfo(), (data) {
            return new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    Icon(
                      Icons.account_balance_wallet,
                      color: Colors.blue,
                      size: 70.0,
                    ),
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          data.accountType,
                          textAlign: TextAlign.center,
                        ),
                        new Container(child: Text(data.accountNumber))
                      ],
                    )
                  ],
                ),
                new SpacedTextWidget('Available balance'),
                new SpacedTextWidget('R ' + data.currentBalance.toString()),
                new SpacedTextWidget('Latest balance'),
                new SpacedTextWidget('R ' + data.latestBalance.toString()),
              ],
            );
          })),
    );
  }
}
