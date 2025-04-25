class LocalAuth {
  static final Map<String, Map<String, String>> _users = {};

  static Future<bool> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (_users.containsKey(email) && _users[email]!['password'] == password) {
      return true;
    }
    return false;
  }

  static Future<bool> signUp(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (_users.containsKey(email)) {
      return false;
    }
    _users[email] = {'name': name, 'password': password};
    return true;
  }
}
