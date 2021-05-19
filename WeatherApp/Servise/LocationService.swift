
import Foundation
import CoreLocation

protocol LocationServiceDelegate: class {
    func locationService(_ sender: LocationService, didUpdate location: CLLocation)
    func locationService(_ sender: LocationService, didFailWith error: LocationServiceError)
    func locationServiceIsReadyToUse()
}

final class LocationService: NSObject {
    
    // MARK: - Properties

    private let locationManager = CLLocationManager()
    private weak var delegate: LocationServiceDelegate?
    
    // MARK: - Initializers
    
    convenience init(delegate: LocationServiceDelegate) {
        self.init()
        
        self.delegate = delegate
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    deinit {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Internal Methods
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdating() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        default:
             break
        }
    }
    
    func stopUpdating() {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            delegate?.locationService(self, didUpdate: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationService(self, didFailWith: .internal(error))
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            delegate?.locationServiceIsReadyToUse()
        case .denied:
            delegate?.locationService(self, didFailWith: .denied)
        case .restricted:
            delegate?.locationService(self, didFailWith: .restricted)
        default:
            break
        }
    }
}

// MARK: - LocationServiceError

enum LocationServiceError: Error {
    case denied
    case restricted
    case `internal`(Error)
}

