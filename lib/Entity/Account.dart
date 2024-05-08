class Account {
  late String name;
  late String birthdate;
  late String address;
  late String gender;
  final String account;
  late String password;
  final String status;

  Account(
    this.name,
    this.birthdate,
    this.address,
    this.gender,
    this.account,
    this.password,
    this.status
  );


  Account copyWith({
    String? name,
    String? birthdate,
    String? address,
    String? gender,
    String? password,
  }) {
    return Account(
      name ?? this.name,
      birthdate ?? this.birthdate,
      address ?? this.address,
      gender ?? this.gender,
      account ?? account,
      password ?? this.password,
      status ?? status,
    );
  }
}