# Multi-LLM Provider Support

MeetlyAI unterstützt jetzt mehrere LLM-Provider für Summary und Chat-Funktionen:

## Unterstützte Provider

### 1. **Gemini** (Standard)
- Google's generatives Modell
- Gute Balance zwischen Qualität und Geschwindigkeit
- Kostenlos (mit API-Key)

**Konfiguration:**
- Settings > LLM Settings > Provider > Gemini
- API Key benötigt (von Google AI Studio)

### 2. **OpenAI-kompatible APIs** (Qwen, Hermes, etc.)
- Qwen 3 Coder (https://qwen.ai.unturf.com/v1)
- Hermes (https://hermes.ai.unturf.com/v1)
- Eigene OpenAI-kompatible Endpoints

**Konfiguration:**
- Settings > LLM Settings > Provider > OpenAI Compatible
- API Key: (meist "choose-any-value" oder leer bei Open-Source-Hosted)
- Base URL: z.B. https://qwen.ai.unturf.com/v1
- Model Name: z.B. hf.co/unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF:Q4_K_M

## Implementierung

Die Architektur nutzt:
- **LlmService Interface**: Abstraktion für verschiedene Provider
- **Factory Pattern**: Automatische Erstellung basierend auf Konfiguration
- **Settings Persistence**: Nutzer kann Provider-Wahl speichern

### Code-Struktur
```
domain/
  services/llm_service.dart        # Interface
  models/llm_config.dart           # Konfiguration
data/
  services/
    gemini_llm_service.dart        # Gemini Implementation
    openai_compatible_llm_service.dart  # OpenAI-kompatibel
```

## Switching zur Laufzeit

User können im Settings-Menu den Provider wechseln und neue Credentials eingeben. Beim nächsten Summary/Chat wird automatisch der neue Provider genutzt.

## Error Handling

- Fehlende Credentials → Fehler in der UI
- API-Fehler → User-freundliche Fehlermeldungen  
- Fallback → Bei Fehler wird Error gezeigt (kein Silent Fail)

## Zukünftige Provider

Einfach ein neues Service implementieren:

```dart
class MyLlmService implements LlmService {
  @override
  Future<MeetingSummary> summarizeMeeting(...) { ... }
  
  @override
  Stream<String> streamMeetingAnswer(...) async* { ... }
}
```

Und in `providers.dart` hinzufügen.
