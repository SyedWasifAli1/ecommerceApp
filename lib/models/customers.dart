class Customer {
  final String id;
  final String email;
  final String fullName;
  final String billingAddress;
  final String defaultShippingAddress;
  final String country;
  final String phone;

  Customer({
    required this.id,
    required this.email,
    required this.fullName,
    required this.billingAddress,
    required this.defaultShippingAddress,
    required this.country,
    required this.phone,
  });

  // Convert Customer object to a Map (for saving to database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'billingAddress': billingAddress,
      'defaultShippingAddress': defaultShippingAddress,
      'country': country,
      'phone': phone,
    };
  }

  // Create a Customer object from a Map (from database)
  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      email: map['email'],
      fullName: map['fullName'],
      billingAddress: map['billingAddress'],
      defaultShippingAddress: map['defaultShippingAddress'],
      country: map['country'],
      phone: map['phone'],
    );
  }
}
