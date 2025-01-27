class TopicoModel {
  final String id;
  final String title;
  final String description;
  final String texto;
  final String exemplo;
  final String dica;
  final String rank;

  TopicoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.texto,
    required this.exemplo,
    required this.dica,
    required this.rank,
  });

  // Converte um documento do Firestore para um TopicoModel
  factory TopicoModel.fromFirestore(Map<String, dynamic> data, String id) {
    return TopicoModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      texto: data['texto'] ?? '',
      exemplo: data['exemplo'] ?? '',
      dica: data['dica'] ?? '',
      rank: data['rank'] ?? '',
    );
  }

  // Converte um TopicoModel para um Map (útil para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'texto': texto,
      'exemplo': exemplo,
      'dica': dica,
      'rank': rank,
    };
  }
}
