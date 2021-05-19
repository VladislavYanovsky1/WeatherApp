
import Foundation


class HourlyWeatherCollectionViewCellViewModel {
    let dt: String
    let temp: String
    let iconName: String
    
    init(model: HourlyWeather) {
        dt = getTime(_date: Date(timeIntervalSince1970: Double(model.dt ?? 0)))
        temp =  String(format: "%.0f°", (model.temp ?? 0).rounded(.down))
        iconName = "\(model.weather[0].icon ?? "" )"
    }
}

func getTime(_date: Date?) -> String {
    guard let inputDate = _date else {
        return ""
    }
    
    let formater = DateFormatter()
    formater.dateFormat = "HH:mm"
    return formater.string(from: inputDate)
}


