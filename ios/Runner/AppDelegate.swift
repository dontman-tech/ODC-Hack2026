import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let dialerChannel = FlutterMethodChannel(name: "rekollect/dialer", binaryMessenger: controller.binaryMessenger)
    dialerChannel.setMethodCallHandler { call, result in
      guard call.method == "openDialer" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard let phoneNumber = call.arguments as? String,
            let url = URL(string: "tel://\(phoneNumber)") else {
        result(FlutterError(code: "INVALID_PHONE", message: "Phone number is empty", details: nil))
        return
      }
      UIApplication.shared.open(url)
      result(nil)
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
