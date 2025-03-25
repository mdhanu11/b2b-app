class User {
  final int id;
  final String emporixCustomerId;
  final String name;
  final String phoneNumber;
  final String email;
  final String nationalId;
  final String dob;
  final String crNumber;
  final String companyName;
  final String accountStatus;
  final String role;

  User({
    required this.id,
    required this.emporixCustomerId,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.nationalId,
    required this.dob,
    required this.crNumber,
    required this.companyName,
    required this.accountStatus,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      emporixCustomerId: json['emporix_customer_id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      nationalId: json['national_id'],
      dob: json['dob'],
      crNumber: json['cr_number'],
      companyName: json['company_name'],
      accountStatus: json['account_status'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emporix_customer_id': emporixCustomerId,
      'name': name,
      'phone_number': phoneNumber,
      'email': email,
      'national_id': nationalId,
      'dob': dob,
      'cr_number': crNumber,
      'company_name': companyName,
      'account_status': accountStatus,
      'role': role,
    };
  }
}
