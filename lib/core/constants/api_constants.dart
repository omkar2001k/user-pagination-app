class ApiConstants {
  static const String baseUrl = 'https://reqres.in/api';
  static const String usersEndpoint = '/users';

  static const int defaultPerPage = 10;
  static const int defaultPage = 1;

  static const Duration timeoutDuration = Duration(seconds: 10);
  
  static const String cachedUsersBoxName = 'cached_users_box';
  static const String cachedUsersKey = 'cached_users_list';
}
