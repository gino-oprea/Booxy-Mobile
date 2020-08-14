class LogItem {
  int idUser;
  String email;
  String userFirstName;
  String userLastName;
  String phone;
  int idCompany;
  int idSite = 4;
  String siteName = 'Mobile';
  String pageName;
  int idAction;
  String actionName;
  bool isError;
  String logErrorMessage;
  String logInfoMessage;

  LogItem(
      {this.idUser,
      this.email,
      this.userFirstName,
      this.userLastName,
      this.phone,
      this.idCompany,
      this.pageName,
      this.idAction,
      this.actionName,
      this.isError,
      this.logErrorMessage,
      this.logInfoMessage});

  Map toJson() {
    Map obj = {
      'idUser': this.idUser,
      'email': this.email,
      'userFirstName': this.userFirstName,
      'userLastName': this.userLastName,
      'phone': this.phone,
      'idCompany': this.idCompany,
      'idSite': this.idSite,
      'siteName': this.siteName,
      'pageName': this.pageName,
      'idAction': this.idAction,
      'actionName': this.actionName,
      'isError': this.isError,
      'logErrorMessage': this.logErrorMessage,
      'logInfoMessage': this.logInfoMessage != null ? this.logInfoMessage : ""
    };

    return obj;
  }
}
