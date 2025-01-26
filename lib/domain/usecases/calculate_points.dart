// lib/domain/usecases/calculate_points.dart
import 'package:fluent_chat/domain/entities/perfil.dart';

class CalculatePoints {
  Perfil call({
    required Perfil currentPerfil,
    required int livesUsed,
    required int correctAnswers,
  }) {
    const int basePoints = 15;
    const int pointsPerLife = 3;
    const int penaltyPerError = 5;

    int pointsEarned = basePoints + (livesUsed * pointsPerLife);
    int pointsLost = basePoints - (correctAnswers * penaltyPerError);

    int newPoints = currentPerfil.points + pointsEarned - pointsLost;
    int newLives = currentPerfil.lives - livesUsed;

    // Atualiza o rank com base nos pontos
    String newRank = _calculateRank(newPoints);

    return currentPerfil.copyWith(
      points: newPoints,
      lives: newLives,
      rank: newRank,
    );
  }

  String _calculateRank(int points) {
    if (points >= 800) return 'Radiante';
    if (points >= 600) return 'Diamante';
    if (points >= 400) return 'Ouro';
    if (points >= 200) return 'Prata';
    return 'Bronze';
  }
}
