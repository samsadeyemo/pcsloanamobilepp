class SignUpRequest {
  final String staffId;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? email;
  final String bvn;

  SignUpRequest({
    required this.firstName,
    required this.lastName,
    required this.staffId,
    required this.bvn,
    this.email,
    required this.phoneNumber,
    
  });

  Map<String, dynamic> toJson() => {
    'staffId': staffId,
    'firstName': firstName,
    'lastName': lastName,
    'phoneNumber': phoneNumber,
    'email': email,
    'bvn': bvn,
  };
}
