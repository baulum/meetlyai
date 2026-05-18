abstract interface class SettingsRepository {
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
}
