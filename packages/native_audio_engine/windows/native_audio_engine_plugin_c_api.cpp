#include "include/native_audio_engine/native_audio_engine_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "native_audio_engine_plugin.h"

void NativeAudioEnginePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  native_audio_engine::NativeAudioEnginePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
