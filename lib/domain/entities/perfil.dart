class Perfil {
  final String name;
  final String email;
  final String profilePicture;
  final String rank;
  final int points;
  final int lives;

  Perfil({
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.rank,
    this.points = 0,
    this.lives = 5,
  });

  // Converte um Map para um objeto Perfil
  factory Perfil.fromMap(Map<String, dynamic> map) {
    return Perfil(
      name: map['name'],
      email: map['email'],
      profilePicture: map['profilePicture'],
      rank: map['rank'] ?? 'Bronze', // Rank padrão
      points: map['points'] ?? 0,
      lives: map['lives'] ?? 5,
    );
  }

  // Converte um objeto Perfil para um Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'rank': rank,
      'points': points,
      'lives': lives,
    };
  }

  // Método para copiar o objeto com novos valores
  Perfil copyWith({
    String? name,
    String? email,
    String? profilePicture,
    String? rank,
    int? points,
    int? lives,
  }) {
    return Perfil(
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      rank: rank ?? this.rank,
      points: points ?? this.points,
      lives: lives ?? this.lives,
    );
  }
}
