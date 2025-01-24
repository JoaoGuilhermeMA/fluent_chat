class Perfil {
  final String name;
  final String email;
  final String profilePicture;
  final String rank;

  Perfil({
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.rank,
  });

  // Converte um Map para um objeto User
  factory Perfil.fromMap(Map<String, dynamic> map) {
    return Perfil(
      name: map['name'],
      email: map['email'],
      profilePicture: map['profilePicture'],
      rank: map['rank'],
    );
  }

  // Converte um objeto User para um Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'rank': rank,
    };
  }
}
