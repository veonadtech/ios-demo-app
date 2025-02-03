/*   Copyright 2018-2021 Prebid.org, Inc.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation

/// Global singleton responsible to store plugin renderer instances
@objc public class PrebidMobilePluginRegister: NSObject {
    @objc public static let shared = PrebidMobilePluginRegister()
    
    private let queue = DispatchQueue(label: "PrebidMobilePluginRegisterQueue", attributes: .concurrent)
    private var plugins = [String: PrebidMobilePluginRenderer]()
    
    private let defaultRenderer = PrebidRenderer()
    
    private override init() {
        super.init()
    }
    
    /// Register plugin as renderer
    @objc public func registerPlugin(_ renderer: PrebidMobilePluginRenderer) {
        let rendererName = renderer.name
        
        queue.async(flags: .barrier) { [weak self] in
            if self?.plugins[rendererName] != nil {
                Log.debug("Plugin with name \(rendererName) is already registered.")
                return
            }
            self?.plugins[rendererName] = renderer
        }
    }
    
    @objc public func unregisterPlugin(_ renderer: PrebidMobilePluginRenderer) {
        queue.async(flags: .barrier) { [weak self] in
            self?.plugins.removeValue(forKey: renderer.name)
        }
    }
    
    /// Contains plugin
    @objc public func containsPlugin(_ renderer: PrebidMobilePluginRenderer) -> Bool {
        queue.sync {
            plugins.contains { $0.value === renderer }
        }
    }
    
    private func getPluginRenderer(for key: String) -> PrebidMobilePluginRenderer? {
        queue.sync {
            plugins[key]
        }
    }
    
    /// Register event delegate
    @objc public func registerEventDelegate(_ pluginEventDelegate: PluginEventDelegate, adUnitConfigFingerprint: String) {
        queue.async(flags: .barrier) { [plugins] in
            plugins
                .values
                .forEach {
                    $0.registerEventDelegate?(pluginEventDelegate: pluginEventDelegate, adUnitConfigFingerprint: adUnitConfigFingerprint)
                }
        }
    }
    
    /// Unregister event delegate
    @objc public func unregisterEventDelegate(_ pluginEventDelegate: PluginEventDelegate, adUnitConfigFingerprint: String) {
        queue.async(flags: .barrier) { [plugins] in
            plugins
                .values
                .forEach {
                    $0.unregisterEventDelegate?(pluginEventDelegate: pluginEventDelegate, adUnitConfigFingerprint: adUnitConfigFingerprint)
                }
        }
    }
    
    /// Returns the list of available renderers for the given ad unit for RTB request
    @objc public func getRTBListOfRenderersFor(for adUnit: AdUnitConfig) -> [PrebidMobilePluginRenderer] {
        queue.sync {
            plugins
                .values
                .filter { renderer in
                    adUnit.adFormats.contains { format in
                        renderer.isSupportRendering(for: format)
                    }
                }
        }
    }
    
    /// Returns the registered renderer according to the preferred renderer name in the bid response
    /// If no preferred renderer is found, it returns PrebidRenderer to perform default behavior
    /// Once bid is win we want to resolve the best PluginRenderer candidate to render the ad
    @objc public func getPluginForPreferredRenderer(bid: Bid) -> PrebidMobilePluginRenderer {
        if let preferredRendererName = bid.getPreferredPluginRendererName(),
           let preferredPlugin = getPluginRenderer(for: preferredRendererName),
           preferredPlugin.version == bid.getPreferredPluginRendererVersion(),
           preferredPlugin.isSupportRendering(for: bid.adFormat) {
            return preferredPlugin
        } else {
            return defaultRenderer
        }
    }
    
    @objc public func getAllPlugins() -> [PrebidMobilePluginRenderer] {
        queue.sync {
            if plugins.isEmpty {
                return []
            }
            let allPlugins = Array(plugins.values)
            return allPlugins
        }
    }
}
