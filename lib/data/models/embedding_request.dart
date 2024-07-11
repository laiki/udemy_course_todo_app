class EmbeddingRequest {
  final String model;
  final String input;

  EmbeddingRequest({required this.model, required this.input});

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'input': input
    };
  }

}