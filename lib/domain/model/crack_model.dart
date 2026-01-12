class CrackModel {
  final List<CrackApp> crackApps;
  final List<CrackApp> noCrackApps;

  CrackModel({
    required this.crackApps,
    required this.noCrackApps,
  });

  factory CrackModel.fromJson(Map<String, dynamic> json) {
    return CrackModel(
      crackApps: List<CrackApp>.from(json['crack_apps']?.map((app) => CrackApp.fromJson(app))),
      noCrackApps: List<CrackApp>.from(json['no_crack_apps']?.map((app) => CrackApp.fromJson(app))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'crack_apps': crackApps.map((app) => app.toJson()).toList(),
      'no_crack_apps': noCrackApps.map((app) => app.toJson()).toList(),
    };
  }
}

class CrackApp {
  final int id;
  final String title;
  final String appName;
  final String logo;
  final String color;
  final int isfree;
  final int coins;
  bool isPay;
  final int weight;

  CrackApp({
    required this.id,
    required this.title,
    required this.appName,
    required this.logo,
    required this.color,
    required this.isfree,
    required this.coins,
    required this.isPay,
    required this.weight,
  });

  factory CrackApp.fromJson(Map<String, dynamic> json) {
    return CrackApp(
      id: json['id'],
      title: json['title'],
      appName: json['app_name'],
      logo: json['logo'],
      color: json['color'],
      isfree: json['isfree'],
      coins: json['coins'],
      isPay: (json['is_pay'] ?? 0) > 0,
      weight: json['weight'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'app_name': appName,
      'logo': logo,
      'color': color,
      'isfree': isfree,
      'coins': coins,
      'is_pay': isPay,
      'weight': weight,
    };
  }
}