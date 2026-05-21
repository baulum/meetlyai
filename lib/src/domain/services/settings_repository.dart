abstract interface class SettingsRepository {
  Future<bool> isOnboardingComplete();

  Future<void> saveOnboardingComplete(bool complete);

  Future<bool> isGuidedTourComplete();

  Future<void> saveGuidedTourComplete(bool complete);

  Future<String?> getGeminiApiKey();

  Future<void> saveGeminiApiKey(String apiKey);

  Future<void> clearGeminiApiKey();

  Future<String?> getGeminiModel();

  Future<void> saveGeminiModel(String model);

  Future<String?> getWhisperModelPath();

  Future<void> saveWhisperModelPath(String path);

  Future<String?> getWhisperExecutablePath();

  Future<void> saveWhisperExecutablePath(String path);

  Future<String?> getPreferredLanguage();

  Future<void> savePreferredLanguage(String languageCode);

  Future<int> getChunkTranscriptionIntervalSeconds();

  Future<void> saveChunkTranscriptionIntervalSeconds(int seconds);

  // LLM Provider settings
  Future<String?> getLlmProvider(); // 'gemini' or 'openai_compatible'

  Future<void> saveLlmProvider(String provider);

  Future<String?> getOpenAiApiKey();

  Future<void> saveOpenAiApiKey(String apiKey);

  Future<String?> getOpenAiBaseUrl();

  Future<void> saveOpenAiBaseUrl(String baseUrl);

  Future<String?> getOpenAiModelName();

  Future<void> saveOpenAiModelName(String modelName);
}
