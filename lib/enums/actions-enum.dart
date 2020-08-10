class ActionsEnum {
  static const Save = 1;
  static const Add = 2;
  static const Edit = 3;
  static const Delete = 4;
  static const Login = 5;
  static const Search = 6;
  static const Logout = 7;
  static const View = 8;
  static const Cancel = 9;

  static String getActionName(int idAction) {
    switch (idAction) {
      case 1:
        return 'Save';
        break;
      case 2:
        return 'Add';
        break;
      case 3:
        return 'Edit';
        break;
      case 4:
        return 'Delete';
        break;
      case 5:
        return 'Login';
        break;
      case 6:
        return 'Search';
        break;
      case 7:
        return 'Logout';
        break;
      case 8:
        return 'View';
        break;
      case 9:
        return 'Cancel';
        break;
      default:
        return 'View';
        break;
    }
  }
}
