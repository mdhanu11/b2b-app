class ApiConstants {
  static const String emporixBaseUrl = 'https://api.emporix.io';
  static const String talabatBaseUrl = 'https://sandbox.getbaqala.com/b2b';

  // Emporix Endpoints
  static const String categories = '/category/{tenant}/categories';
  static const String products = '/category/{tenant}/categories';

  // Talabat Endpoints
  static const String requestOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String register = '/customer/signup';
  static const String login = '/customer/signin';
  static const String talabatProfile = '/user/profile';

  //Algolia Details
  //TODO: Thinking to change these to login api, and fetch it from there. These are for B2C app.
  static const String algoliaAppId = '23434';
  static const String algoliaApiKey = '232342112';
  static const String algoliaIndexName = '343421244';
}
