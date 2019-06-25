class Domain {}

class Transaction implements Domain {
  final String accountNumber;
  final String topupType;
  final double topupAmount;
  final String topupItemId;
  final int id;
  final int threshHoldForAlert;
  final String email;

  final String mobile;

  final bool geoAlert;

  final bool lbAlert;

  final double lbLimit;
  final String reference;

  final bool mailAlert;

  Transaction(
      {this.accountNumber, this.topupAmount, this.topupType, this.id, this.threshHoldForAlert,this.topupItemId,this.email,this.mobile,this.lbLimit,this.geoAlert,this.lbAlert,this.reference,this.mailAlert});

  static List<Transaction> getTransactionFromJson(List<dynamic> json) {
    List<Transaction> list = [];
    for (dynamic data in json) {
      print(data);
      list.add(Transaction(
          accountNumber: data['accountNumber'],
          topupType: data['topupType'],
          topupAmount: data['topupAmount'],
          id: data['id'],
          threshHoldForAlert: data['threshHoldForAlert'],
      topupItemId: data['topupItemId'],
      email: data['email'],
      mobile: data['mobile'],
      lbLimit: data['lbLimit'],
      geoAlert: data['geoAlert']=="Y"?true:false,
      lbAlert: data['lbAlert']=="Y"?true:false,
      reference: data['reference'],
      mailAlert: data['mailAlert']=="Y"?true:false)

      );
    }
    return list;
  }

  factory Transaction.getFromJson(Map<String, dynamic> data) {
    return Transaction(
        accountNumber: data['accountNumber'],
        topupType: data['topupType'],
        topupAmount: data['topupAmount'],
        id: data['id'],
        threshHoldForAlert: data['threshHoldForAlert'],
        topupItemId: data['topupItemId'],
        email: data['email'],
        mobile: data['mobile'],
        lbLimit: data['lbLimit'],
        geoAlert: data['geoAlert']=="Y"?true:false,
        lbAlert: data['lbAlert']=="Y"?true:false,
        reference: data['reference'],
        mailAlert: data['mailAlert']=="Y"?true:false);
  }
}

class AccountInfo implements Domain {
  final String accountNumber;

  final double latestBalance;

  final double currentBalance;

  final double beneficiaryCount;

  final String accountKey;

  final String accountType;

  AccountInfo(
      {this.accountKey,
      this.accountNumber,
      this.accountType,
      this.latestBalance,
      this.currentBalance,
      this.beneficiaryCount});

  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    return new AccountInfo(
        accountNumber: json['accountNumber'],
        accountKey: json['accountKey'],
        accountType: json['accountType'],
        latestBalance: json['latestBalance'],
        currentBalance: json['currentBalance'],
        beneficiaryCount: json['beneficiaryCount']);
  }
}

class CardData implements Domain{


 final String topupItemId;

 final double balance ;

 final double topupAmount;

 final String expiryDate;

 final bool mailAlert;

 final bool smsAlert;

 final String email;

 final String mobile;

 final String topupType;

 final bool geoAlert;

 final bool lbAlert;

 final double lbLimit;

 final String accountNumber;
  final String cardId;

 final String reference;
 CardData({this.expiryDate,
 this.balance,this.topupItemId,this.email,this.mobile,this.mailAlert,this.smsAlert,this.geoAlert,this.lbAlert,this.lbLimit,this.accountNumber,this.topupAmount,this.topupType,this.reference,this.cardId});

 static List<CardData> getCardDataFromJson(List<dynamic> json) {
   List<CardData> list = [];
   for (dynamic data in json) {
     print(data);
     list.add( CardData(cardId: data['cardId'] ,reference: data['reference'],
         topupItemId: data['topupItemId'],email: data['email'],lbLimit: data['lbLimit'],balance: data['balance'],
         mobile: data['mobile'],lbAlert: data['lbAlert']=="Y"?true:false,geoAlert: data['geoAlert']=="Y"?true:false,accountNumber: data['accountNumber'],expiryDate: data['expiryDate'] ));
   }
   return list;
 }

 factory CardData.getFromJson(Map<String, dynamic> data) {


   return new
   CardData(topupItemId: data['topupItemId'],
       balance: data['balance'], topupAmount: data['topupAmount'],
       expiryDate: data['expiryDate'] ,mailAlert: data['mailAlert']=="Y"?true:false,smsAlert: data['smsAlert']=="Y"?true:false,email: data['email'],
       mobile: data['mobile'],topupType: data['topupType'],geoAlert:data['geoAlert']=="Y"?true:false,lbAlert: data['lbAlert']=="Y"?true:false,lbLimit: data ['lbLimit'],accountNumber: data['accountNumber'],reference: data['reference']);

 }

}