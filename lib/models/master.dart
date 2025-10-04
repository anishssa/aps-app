class Master {
  final int id;
  final String name;

  Master({required this.id, required this.name});

  // Factory constructor for creating a new Product instance from a map.
  factory Master.fromJson(Map<String, dynamic> json) {
    return Master(
      id: json['id'],
      name: json['name'],
    );
  }

  // Method to convert a Product instance into a map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
