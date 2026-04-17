class AmbienceModel {
  final String id;
  final String title;
  final String tag;
  final int durationSeconds;
  final String thumbnailUrl;
  final String audioUrl;
  final String description;
  final List<String> recipes;

  AmbienceModel({
    required this.id,
    required this.title,
    required this.tag,
    required this.durationSeconds,
    required this.thumbnailUrl,
    required this.audioUrl,
    required this.description,
    required this.recipes,
  });

  factory AmbienceModel.fromJson(Map<String, dynamic> json) {
    return AmbienceModel(
      id: json['id'] as String,
      title: json['title'] as String,
      tag: json['tag'] as String,
      durationSeconds: json['durationSeconds'] as int,
      thumbnailUrl: json['thumbnailUrl'] as String,
      audioUrl: json['audioUrl'] as String,
      description: json['description'] as String,
      recipes: List<String>.from(json['recipes'] ?? []),
    );
  }
}
