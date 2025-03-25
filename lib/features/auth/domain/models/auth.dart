import 'user.dart';

class Auth {
  final User user;
  final String token;
  final String tenant;

  Auth({
    required this.user,
    required this.token,
    required this.tenant,
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      user: User.fromJson(json['customer']),
      token: json['token'],
      tenant: json['tenant'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer': user.toJson(),
      'token': token,
      'tenant': tenant,
    };
  }
}
