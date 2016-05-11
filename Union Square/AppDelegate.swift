
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = window {
            window.rootViewController = ViewController()
            window.makeKeyAndVisible()
        }

        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
        return true
    }


}

