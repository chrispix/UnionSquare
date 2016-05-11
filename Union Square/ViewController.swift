
import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {

    var locationManager = CLLocationManager()
    let unionSquare = CLLocation(latitude: 37.787400, longitude: -122.408240)
    let mapView = MKMapView()

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

    func notifyMe() {
        let notification = UILocalNotification()
        notification.alertBody = "You are in Union Square!"
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
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

        for location in locations {
            if location.distanceFromLocation(unionSquare) < 100 {
                notifyMe()
                break
            }
        }
    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}

