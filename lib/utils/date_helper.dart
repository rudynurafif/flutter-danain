List<String> getListYear(int year) {
  final int currentYear = DateTime.now().year;

  final List<String> yearsList = [];
  while (year <= currentYear) {
    yearsList.add(year.toString());
    year++;
  }
  return yearsList.reversed.toList();
}
