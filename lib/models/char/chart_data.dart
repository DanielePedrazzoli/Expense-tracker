class ChartData {
  ChartData(this.day, this.income, this.expense) {
    total = income - expense;
  }

  final int day;
  final double income;
  final double expense;
  double total = 0;
}
