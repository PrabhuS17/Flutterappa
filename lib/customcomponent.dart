import 'package:flutter/material.dart';
import 'dart:async';

class SpacedTextWidget extends Container {
  SpacedTextWidget(text)
      : super(
            padding: new EdgeInsets.fromLTRB(20.0, 2.0, 5.0, 2.0),
            child: Text(text, textAlign: TextAlign.left),
            alignment: Alignment.topLeft);
}

class Util<T> {
  static Widget getButtonsCard(Widget child) {
    return new Card(
        child: new Container(padding: EdgeInsets.all(15.0), child: child));
  }

  static String inputFieldNameFromCode(String code){
    switch (code) {
      case "DATA":
        return "Cell phone number";
      case "AIRT":
        return "Cell phone number";
      case "SMS":
        return "Cell phone number";
      case "TRAIN":
        return "Gautrain card number";
    }
    return null;
  }
  static Widget getButton(IconData iconData, String name, double inset) {
    return getButtonWithAction(iconData, name, inset,'', null);
  }

  static Widget getButtonWithAction(IconData iconData, String name, double inset,String type,void onPressed(String type)) {

    if(onPressed==null){
      onPressed=(e)=>{};
    }

    List<Widget> content = [
      new RaisedButton(
        padding: EdgeInsets.all(inset),
        textColor: Colors.white,
        color: Colors.blue,
        child: new Icon(iconData),
        onPressed: ()=>onPressed(type),
        shape: new CircleBorder(),
      )
    ];
    if (name.isNotEmpty) {
      content
          .add(new Container(child: Text(name), padding: EdgeInsets.all(2.0)));
    }
    return new Container(
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        child: new Column(children: content));
  }

  static IconData getIconDataFromCode(String code) {
    switch (code) {
      case "DATA":
        return Icons.wifi;
      case "AIRT":
        return Icons.mobile_screen_share;
      case "SMS":
        return Icons.message;
      case "TRAIN":
        return Icons.train;
    }
    return null;
  }

  static String getDescriptionFromCode(String code) {
    switch (code) {
      case "DATA":
        return "Data";
      case "AIRT":
        return "Airtime";
      case "SMS":
        return "SMS";
      case "TRAIN":
        return "Gautrain";
    }
    return null;
  }


}

class WaitAndBuild<T> {
  FutureBuilder getFutureBuilder(Future<T> future, Widget getChild(T data)) {
    return FutureBuilder<T>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return getChild(snapshot.data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
