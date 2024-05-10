//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_nsd/flutter_nsd_plugin.h>
#include <nsd_windows/nsd_windows_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FlutterNsdPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterNsdPlugin"));
  NsdWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("NsdWindowsPluginCApi"));
}
