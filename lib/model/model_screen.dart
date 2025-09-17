class ActivityModel {
  final String type;        // نوع النشاط (مثال: Walking, Recycling...)
  final String description; // وصف النشاط
  final double co2Saved;    // CO2 saved in kg
  final double piReward;    // Pi earned
  final DateTime date;      // تاريخ النشاط

  // بيانات خاصة بالمشي (اختيارية)
  final int? steps;         // عدد الخطوات
  final double? distance;   // المسافة بالمتر

  ActivityModel({
    required this.type,
    required this.description,
    required this.co2Saved,
    required this.piReward,
    required this.date,
    this.steps,
    this.distance,
  });

  // تحويل إلى Map للتخزين (مثلاً SharedPreferences أو قاعدة بيانات)
  Map<String, dynamic> toMap() => {
    'type': type,
    'description': description,
    'co2Saved': co2Saved,
    'piReward': piReward,
    'date': date.toIso8601String(),
    'steps': steps,
    'distance': distance,
  };

  // استرجاع من Map
  factory ActivityModel.fromMap(Map<String, dynamic> m) => ActivityModel(
    type: m['type'] as String,
    description: m['description'] as String,
    co2Saved: (m['co2Saved'] as num).toDouble(),
    piReward: (m['piReward'] as num).toDouble(),
    date: DateTime.parse(m['date'] as String),
    steps: m['steps'] != null ? m['steps'] as int : null,
    distance: m['distance'] != null ? (m['distance'] as num).toDouble() : null,
  );
}
