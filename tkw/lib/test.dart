import 'dart:convert';

void main() {
  // Input string with numbers separated by spaces and newlines
  String input = '''
1.77
2.43
4.01
5.10 6.34 6.82 6.85 5.96 5.06
3.70
2.30
1.70
  ''';

  // Month names in order
  List<String> months = [
    "OCAK",
    "SUBAT",
    "MART",
    "NISAN",
    "MAYIS",
    "HAZIRAN",
    "TEMMUZ",
    "AGUSTOS",
    "EYLUL",
    "EKIM",
    "KASIM",
    "ARALIK"
  ];

  // Process the input string
  List<double> values = input
      .split(RegExp(r'\s+')) // Split by whitespace (spaces or newlines)
      .where((item) => item.isNotEmpty) // Remove empty strings
      .map((item) => double.parse(item)) // Convert to double
      .toList();

  // Validate the number of values
  if (values.length != months.length) {
    print(
        'Error: The number of values (${values.length}) does not match the number of months (${months.length}).');
    return;
  }

  // Create a map for monthlyKWh
  Map<String, double> monthlyKWh = {
    for (int i = 0; i < months.length; i++) months[i]: values[i]
  };

  // Wrap the result in a JSON-like structure
  // Map<String, dynamic> result = {"monthlyKWh": monthlyKWh};

  // Convert to JSON string and print
  String jsonResult = jsonEncode(monthlyKWh);

  print('\n');
  print(jsonResult);
  print('\n');
}
