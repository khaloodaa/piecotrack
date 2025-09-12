class ActivityModel {
  final String type;        // e.g. "Walking 1 km"
  final String description; // e.g. "3 × Walking 1 km"
  final double co2Saved;    // in kg
  final double piReward;    // Pi earned
  final DateTime date;

  ActivityModel({
    required this.type,
    required this.description,
    required this.co2Saved,
    required this.piReward,
    required this.date,
  });

  // optional: helper to create from Map (later for persistence)
  Map<String, dynamic> toMap() => {
    'type': type,
    'description': description,
    'co2Saved': co2Saved,
    'piReward': piReward,
    'date': date.toIso8601String(),
  };

  factory ActivityModel.fromMap(Map<String, dynamic> m) => ActivityModel(
    type: m['type'] as String,
    description: m['description'] as String,
    co2Saved: (m['co2Saved'] as num).toDouble(),
    piReward: (m['piReward'] as num).toDouble(),
    date: DateTime.parse(m['date'] as String),
  );
}
