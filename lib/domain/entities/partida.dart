class Partida {
  int vidas;
  int respostasCorretas;
  DateTime timestamp;
  String rankAtual;
  String fraseVocabulario;
  String fraseEscuta;
  String fraseFala;
  int pontosGanhos;
  int pontosPerdidos;
  bool ganhou;

  // Construtor
  Partida({
    required this.vidas,
    required this.respostasCorretas,
    required this.timestamp,
    required this.rankAtual,
    required this.fraseVocabulario,
    required this.fraseEscuta,
    required this.fraseFala,
    required this.pontosGanhos,
    required this.pontosPerdidos,
    required this.ganhou,
  });

  // Método copyWith
  Partida copyWith({
    int? vidas,
    int? respostasCorretas,
    DateTime? timestamp,
    String? rankAtual,
    String? fraseVocabulario,
    String? fraseEscuta,
    String? fraseFala,
    int? pontosGanhos,
    int? pontosPerdidos,
    bool? ganhou,
  }) {
    return Partida(
      vidas: vidas ?? this.vidas,
      respostasCorretas: respostasCorretas ?? this.respostasCorretas,
      timestamp: timestamp ?? this.timestamp,
      rankAtual: rankAtual ?? this.rankAtual,
      fraseVocabulario: fraseVocabulario ?? this.fraseVocabulario,
      fraseEscuta: fraseEscuta ?? this.fraseEscuta,
      fraseFala: fraseFala ?? this.fraseFala,
      pontosGanhos: pontosGanhos ?? this.pontosGanhos,
      pontosPerdidos: pontosPerdidos ?? this.pontosPerdidos,
      ganhou: ganhou ?? this.ganhou,
    );
  }
}
