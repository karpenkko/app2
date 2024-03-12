mixin WishesList{
  late final Map<String, String> wishes = {
    'Monday': 'Have a great start of the week!',
    'Tuesday': 'Stay motivated and focused!',
    'Wednesday': 'Halfway through, you can do it!',
    'Thursday': 'Keep pushing, the weekend is near!',
    'Friday': 'Weekend is almost here, hang in there!',
    'Saturday': 'Enjoy your weekend to the fullest!',
    'Sunday': 'Relax and recharge for the week ahead!'
  };
}

class Wishes with WishesList {
  final now = DateTime.now();

  String getWish() {
    final currentDay = now.weekday;
    final dayName = getDayName(currentDay);
    return wishes[dayName] ?? '';
  }

  String getDayName(int currentDay) {
    final Set<String> dayNames = {'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'};
    return (currentDay >= 1 && currentDay <= 7) ? dayNames.elementAt(currentDay - 1) : '';
  }
}