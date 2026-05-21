enum LlmProvider {
  gemini,
  openaiCompatible,
}

class LlmProviderConfig {
  const LlmProviderConfig({
    required this.provider,
    this.apiKey,
    this.baseUrl,
    this.modelName,
  });

  final LlmProvider provider;
  final String? apiKey;
  final String? baseUrl; // For OpenAI-compatible APIs
  final String? modelName;

  LlmProviderConfig copyWith({
    LlmProvider? provider,
    String? apiKey,
    String? baseUrl,
    String? modelName,
  }) {
    return LlmProviderConfig(
      provider: provider ?? this.provider,
      apiKey: apiKey ?? this.apiKey,
      baseUrl: baseUrl ?? this.baseUrl,
      modelName: modelName ?? this.modelName,
    );
  }

  @override
  String toString() => 'LlmProviderConfig(provider: $provider, baseUrl: $baseUrl, modelName: $modelName)';
}
