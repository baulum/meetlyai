import 'package:drift/drift.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/services/settings_repository.dart';
import '../database/app_database.dart';

class SecureSettingsRepository implements SettingsRepository {
  SecureSettingsRepository(this._db, {FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const _onboardingComplete = 'onboarding_complete';
  static const _guidedTourComplete = 'guided_tour_complete';
  static const _geminiApiKey = 'gemini_api_key';
  static const _geminiModel = 'gemini_model';
  static const _whisperModelPath = 'whisper_model_path';
  static const _whisperExecutablePath = 'whisper_executable_path';
  static const _preferredLanguage = 'preferred_language';
  static const _chunkTranscriptionIntervalSeconds =
      'chunk_transcription_interval_seconds';
  static const _llmProvider = 'llm_provider';
  static const _openAiApiKey = 'openai_api_key';
  static const _openAiBaseUrl = 'openai_base_url';
  static const _openAiModelName = 'openai_model_name';

  static const defaultGeminiModel = 'gemini-2.5-flash';
  static const defaultChunkTranscriptionIntervalSeconds = 25;

  final AppDatabase _db;
  final FlutterSecureStorage _secureStorage;

  @override
  Future<bool> isOnboardingComplete() async {
    return await _readSetting(_onboardingComplete) == 'true';
  }

  @override
  Future<void> saveOnboardingComplete(bool complete) {
    return _writeSetting(_onboardingComplete, complete.toString());
  }

  @override
  Future<bool> isGuidedTourComplete() async {
    return await _readSetting(_guidedTourComplete) == 'true';
  }

  @override
  Future<void> saveGuidedTourComplete(bool complete) {
    return _writeSetting(_guidedTourComplete, complete.toString());
  }

  @override
  Future<String?> getGeminiApiKey() => _secureStorage.read(key: _geminiApiKey);

  @override
  Future<void> saveGeminiApiKey(String apiKey) {
    return _secureStorage.write(key: _geminiApiKey, value: apiKey.trim());
  }

  @override
  Future<void> clearGeminiApiKey() => _secureStorage.delete(key: _geminiApiKey);

  @override
  Future<String?> getGeminiModel() async {
    return await _readSetting(_geminiModel) ?? defaultGeminiModel;
  }

  @override
  Future<void> saveGeminiModel(String model) =>
      _writeSetting(_geminiModel, model);

  @override
  Future<String?> getWhisperModelPath() => _readSetting(_whisperModelPath);

  @override
  Future<void> saveWhisperModelPath(String path) {
    return _writeSetting(_whisperModelPath, path);
  }

  @override
  Future<String?> getWhisperExecutablePath() {
    return _readSetting(_whisperExecutablePath);
  }

  @override
  Future<void> saveWhisperExecutablePath(String path) {
    return _writeSetting(_whisperExecutablePath, path);
  }

  @override
  Future<String?> getPreferredLanguage() async {
    return await _readSetting(_preferredLanguage) ?? 'auto';
  }

  @override
  Future<void> savePreferredLanguage(String languageCode) {
    return _writeSetting(_preferredLanguage, languageCode);
  }

  @override
  Future<int> getChunkTranscriptionIntervalSeconds() async {
    final raw = await _readSetting(_chunkTranscriptionIntervalSeconds);
    final parsed = int.tryParse(raw ?? '');
    return _normalizeChunkInterval(parsed);
  }

  @override
  Future<void> saveChunkTranscriptionIntervalSeconds(int seconds) {
    return _writeSetting(
      _chunkTranscriptionIntervalSeconds,
      _normalizeChunkInterval(seconds).toString(),
    );
  }

  int _normalizeChunkInterval(int? seconds) {
    if (seconds == null) {
      return defaultChunkTranscriptionIntervalSeconds;
    }
    return seconds.clamp(10, 120);
  }

  @override
  Future<String?> getLlmProvider() => _readSetting(_llmProvider);

  @override
  Future<void> saveLlmProvider(String provider) =>
      _writeSetting(_llmProvider, provider);

  @override
  Future<String?> getOpenAiApiKey() => _readSetting(_openAiApiKey);

  @override
  Future<void> saveOpenAiApiKey(String apiKey) =>
      _writeSetting(_openAiApiKey, apiKey.trim());

  @override
  Future<String?> getOpenAiBaseUrl() => _readSetting(_openAiBaseUrl);

  @override
  Future<void> saveOpenAiBaseUrl(String baseUrl) =>
      _writeSetting(_openAiBaseUrl, baseUrl.trim());

  @override
  Future<String?> getOpenAiModelName() => _readSetting(_openAiModelName);

  @override
  Future<void> saveOpenAiModelName(String modelName) =>
      _writeSetting(_openAiModelName, modelName.trim());

  Future<String?> _readSetting(String key) async {
    final row = await (_db.select(
      _db.settingRows,
    )..where((table) => table.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> _writeSetting(String key, String value) {
    return _db
        .into(_db.settingRows)
        .insertOnConflictUpdate(
          SettingRowsCompanion(
            key: Value(key),
            value: Value(value),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }
}
