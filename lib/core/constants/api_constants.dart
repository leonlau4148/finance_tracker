class ApiConstants {
  static const String baseUrl = 'http://ravenapi.runasp.net'; // ← replace with your IP

  // Auth
  static const String login    = '$baseUrl/api/Auth/login';
  static const String register = '$baseUrl/api/Auth/register';

  // Transactions
  static const String transactions        = '$baseUrl/api/Transactions';
  static String transactionById(int id)   => '$baseUrl/api/Transactions/$id';

  // Categories
  static const String categories          = '$baseUrl/api/Categories';
  static String categoryById(int id)      => '$baseUrl/api/Categories/$id';

  // Budgets
  static const String budgets             = '$baseUrl/api/Budgets';
  static String budgetById(int id)        => '$baseUrl/api/Budgets/$id';
}
