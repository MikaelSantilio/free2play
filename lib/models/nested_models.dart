class SystemRequirements {
  final String? os;
  final String? processor;
  final String? memory;
  final String? graphics;
  final String? storage;
  static String tableName = "systemRequirements";

  SystemRequirements({
    required this.os,
    required this.processor,
    required this.memory,
    required this.graphics,
    required this.storage,
  });
  factory SystemRequirements.fromJson(Map<String, dynamic> json) {
    return SystemRequirements(
      os: json['os'] as String,
      processor: json['processor'] as String,
      memory: json['memory'] as String,
      graphics: json['graphics'] as String,
      storage: json['storage'] as String,
    );
  }
  Map<String, dynamic> toMap(int idGame) {
    return {
      'idGame': idGame,
      'os': os,
      'processor': processor,
      'memory': memory,
      'graphics': graphics,
      'storage': storage,
    };
  }
}


class Screenshot {
  final int id;
  final String image;
  static String tableName = "screenshot";

  Screenshot({
    required this.id,
    required this.image,
  });
  factory Screenshot.fromJson(Map<String, dynamic> json) {
    return Screenshot(
      id: json['id'] as int,
      image: json['image'] as String,
    );
  }
  Map<String, dynamic> toMap(int idGame) {
    return {
      'idScreenshot': id,
      'idGame': idGame,
      'image': image,
    };
  }
}