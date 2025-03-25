class RegistrationModel {
  final String email;
  final String phoneNumber;
  final String name;
  final String company;
  final String crNumber;
  final String nationalId;
  final String dob;
  final AddressModel address;

  RegistrationModel({
    required this.email,
    required this.phoneNumber,
    required this.name,
    required this.company,
    required this.crNumber,
    required this.nationalId,
    required this.dob,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'phoneNumber': phoneNumber,
        'name': name,
        'company': company,
        'crNumber': crNumber,
        'nationalId': nationalId,
        'dob': dob,
        'address': address.toJson(),
      };

  RegistrationModel copyWith({
    String? email,
    String? phoneNumber,
    String? name,
    String? company,
    String? crNumber,
    String? nationalId,
    String? dob,
    AddressModel? address,
  }) {
    return RegistrationModel(
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      company: company ?? this.company,
      crNumber: crNumber ?? this.crNumber,
      nationalId: nationalId ?? this.nationalId,
      dob: dob ?? this.dob,
      address: address ?? this.address,
    );
  }
}

class AddressModel {
  final String googleAddress;
  final String city;
  final String state;
  final String country;

  AddressModel({
    required this.googleAddress,
    required this.city,
    required this.state,
    required this.country,
  });

  Map<String, dynamic> toJson() => {
        'google_address': googleAddress,
        'city': city,
        'state': state,
        'country': country,
      };
}
