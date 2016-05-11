
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

    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        let alert = UIAlertController(title: "Important Update", message: notification.alertBody, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        if let _ = window?.rootViewController?.presentedViewController {
            window?.rootViewController?.dismissViewControllerAnimated(true, completion: {
                self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            })
        } else {
            window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        }
    }

}

