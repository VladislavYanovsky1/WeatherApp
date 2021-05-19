import Foundation
import CoreLocation

protocol WeatherViewModelDelegate: AnyObject { 
    func showAlert(with error: String)
    func openSetting()
    func set(isLoadind: Bool)
    func showInternetError()
}

class WeatherViewModel {
    
    weak var delegate: WeatherViewModelDelegate?

    var tableViewModel: Bindable<[WeatherTableViewCellViewModel]> = Bindable([])
    var collectionViewModel: Bindable<[HourlyWeatherCollectionViewCellViewModel]> = Bindable([])
    
    var city: Bindable<String?> = Bindable(nil)
    var temp: Bindable<String?> = Bindable(nil)
    var description: Bindable<String?> = Bindable(nil)
    var icon: Bindable<String?> = Bindable(nil)
    
    private lazy var  locationServise = LocationService(delegate: self)
        
    func requestWeatherWithCoordinate() {
        locationServise.requestAuthorization()
    }
    
    func fetchWeather(lat: Double =  33.441792, lon: Double = -94.037689){
        
        delegate?.set(isLoadind: true)
        
        let url = String(format: weatherURL, lat, lon )
        
        APIService.shared.getJSON(urlString: url) { (result: Result<WeatherResponse,APIService.APIError>) in
            self.delegate?.set(isLoadind: false)
            
            switch result {
            case.success(let dataWeatherModel):
                self.description.value = dataWeatherModel.daily[0].weather[0].description ?? "no data"
                self.temp.value =  String(format: "%.0f°", (dataWeatherModel.current?.temp ?? 0).rounded(.down))
                self.tableViewModel.value = dataWeatherModel.daily.map{WeatherTableViewCellViewModel(model: $0)}
                self.collectionViewModel.value = dataWeatherModel.hourly.map{HourlyWeatherCollectionViewCellViewModel(model: $0)}
            case.failure(let apiError):
                if apiError._code == NSURLErrorNotConnectedToInternet {
                    print("No enternet ")
                    self.delegate?.showInternetError()
                } else {
                    print(apiError.localizedDescription)
                    self.delegate?.showAlert(with: apiError.localizedDescription)
                }
            }
        }
    }
    
    func getAdress(fromLocation location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (plasemarks, error) in
            if let placemark = plasemarks?.first {
                self.city.value = placemark.locality
            }
        }
    }
}






extension WeatherViewModel: LocationServiceDelegate {
    
    func locationService(_ sender: LocationService, didUpdate location: CLLocation) {
        locationServise.stopUpdating()
        fetchWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        getAdress(fromLocation: location)
    } 
    
    func locationService(_ sender: LocationService, didFailWith error: LocationServiceError) {
        switch error {
        case .denied, .restricted:
            delegate?.openSetting()
        case .internal(let error):
            delegate?.showAlert(with: error.localizedDescription)
        }
    }
    
    func locationServiceIsReadyToUse() {
        locationServise.startUpdating()
    }
    
}

