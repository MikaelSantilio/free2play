class SystemRequirements {
  final String os;
  final String processor;
  final String memory;
  final String graphics;
  final String storage;

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
}


class Screenshot {
  final int id;
  final String url;

  Screenshot({
    required this.id,
    required this.url,
  });
  factory Screenshot.fromJson(Map<String, dynamic> json) {
    return Screenshot(
      id: json['id'] as int,
      url: json['url'] as String,
    );
  }
}