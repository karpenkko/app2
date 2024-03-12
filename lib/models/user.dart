mixin UserCache {
  static Map<String, User> userCache = {};
}

class User with UserCache {
  String username;
  int age;

  User({required this.username, required this.age});

  factory User.guest(String name) => UserCache.userCache.containsKey(name) ? UserCache.userCache[name]! : User(username: 'Guest', age: 0);

  String getUsername() => username;
}