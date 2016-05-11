
import UIKit
import CoreLocation
import MapKit

enum WhereAmI {
    case InUnionSquare
    case NotInUnionSquare
}

class ViewController: UIViewController {

    var locationManager = CLLocationManager()
    let unionSquare = CLLocation(latitude: 37.7874, longitude: -122.40824)
    let mapView = MKMapView()
    let inUnionSquareKey = "in Union Square"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.fillParent()
        mapView.showsUserLocation = true

        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            startTrackingLocation()
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }

    func startTrackingLocation() {
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.distanceFilter = 100
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
    }

    func notifyMe(whereAmI: WhereAmI) {
        let inUnionSquare: Bool = whereAmI == .InUnionSquare
        let notification = UILocalNotification()
        notification.alertBody = inUnionSquare ? "You are in Union Square!" : "You have left Union Square!"
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        NSUserDefaults.standardUserDefaults().setBool(inUnionSquare, forKey: inUnionSquareKey)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let coordinate = location.coordinate
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500)
            let regionForMap = mapView.regionThatFits(region)
            mapView.setRegion(regionForMap, animated: true)
        }

        let inUnionSquare = !locations.filter({ location in location.distanceFromLocation(unionSquare) < 100 }).isEmpty
        switch NSUserDefaults.standardUserDefaults().boolForKey(inUnionSquareKey) {
        case true:
            if !inUnionSquare {
                notifyMe(.NotInUnionSquare)
            }
        case false:
            if inUnionSquare {
                notifyMe(.InUnionSquare)
            }
        }
    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}

