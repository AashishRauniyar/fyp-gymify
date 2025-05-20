class NutritionAnalysis {
  final String foodName;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int fiber;
  final int sugar;
  final int sodium;
  final int potassium;
  final String healthBenefits;
  final bool isHealthy;

  NutritionAnalysis({
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.sugar,
    required this.sodium,
    required this.potassium,
    required this.healthBenefits,
    required this.isHealthy,
  });

  factory NutritionAnalysis.fromJson(Map<String, dynamic> json) {
    return NutritionAnalysis(
      foodName: json['food_name'] ?? '',
      calories: json['calories'] ?? 0,
      protein: json['protein'] ?? 0,
      carbs: json['carbs'] ?? 0,
      fat: json['fat'] ?? 0,
      fiber: json['fiber'] ?? 0,
      sugar: json['sugar'] ?? 0,
      sodium: json['sodium'] ?? 0,
      potassium: json['potassium'] ?? 0,
      healthBenefits: json['health_benefits'] ?? '',
      isHealthy: json['is_healthy'] ?? false,
    );
  }
}
