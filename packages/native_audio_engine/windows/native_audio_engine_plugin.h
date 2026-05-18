#ifndef FLUTTER_PLUGIN_NATIVE_AUDIO_ENGINE_PLUGIN_H_
#define FLUTTER_PLUGIN_NATIVE_AUDIO_ENGINE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace native_audio_engine {

class NativeAudioEnginePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  NativeAudioEnginePlugin();

  virtual ~NativeAudioEnginePlugin();

  // Disallow copy and assign.
  NativeAudioEnginePlugin(const NativeAudioEnginePlugin&) = delete;
  NativeAudioEnginePlugin& operator=(const NativeAudioEnginePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace native_audio_engine

#endif  // FLUTTER_PLUGIN_NATIVE_AUDIO_ENGINE_PLUGIN_H_
