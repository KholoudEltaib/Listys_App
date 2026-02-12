// import Flutter
// import UIKit

// @main
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }

// import GoogleMaps

// @main
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     GMSServices.provideAPIKey("AIzaSyAnYd6EQJrtPunY6Pa8rpcJBhbLPpSXraI")
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }

// import UIKit
// import Flutter
// import GoogleMaps

// @main
// @objc class AppDelegate: FlutterAppDelegate {
    
//     override func application(
//         _ application: UIApplication,
//         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//     ) -> Bool {
        
//         // Google Maps API Key
//         GMSServices.provideAPIKey("AIzaSyAnYd6EQJrtPunY6Pa8rpcJBhbLPpSXraI")
        
//         // Register all Flutter plugins
//         GeneratedPluginRegistrant.register(with: self)
        
//         return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//     }
    
//     // Handle incoming URLs (for Facebook Auth, Web Auth, etc.)
//     override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//         return super.application(app, open: url, options: options)
//     }
    
//     override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//         return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
//     }
    
//     // Optional: if you have any push notifications or other delegates, add them here
// }




import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // Only initialize Google Maps and Facebook services on a real device
        #if !targetEnvironment(simulator)
        // Google Maps API Key
        GMSServices.provideAPIKey("AIzaSyAnYd6EQJrtPunY6Pa8rpcJBhbLPpSXraI")

        // Optional: Initialize Facebook Gaming Services if needed
        // FBSDKGamingServicesKit initialization here
        #endif

        // Register all Flutter plugins
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // Handle incoming URLs (for Facebook Auth, Web Auth, etc.)
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return super.application(app, open: url, options: options)
    }

    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
}
