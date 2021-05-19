
import Foundation
import UIKit

class  WeatherTableViewCellViewModel {
    
    let dayTemp: String
    let nightTemp: String
    let day: String
    let iconName: String
    
    init(model: DailyWeather) {
        dayTemp =  String(format: "%.0f°", (model.temp?.day ?? 0).rounded(.down))
        nightTemp = String(format: "%.0f°", (model.temp?.night ?? 0).rounded(.down))
        day = getDayForDate(_date: Date(timeIntervalSince1970: Double(model.dt ?? 0)))
        iconName =  model.weather[0].icon ?? "Need new icons"
    }
}

    func getDayForDate(_date: Date?) -> String {
        guard let inputDate = _date else {
            return ""
        }

        let formater = DateFormatter()
        formater.dateFormat = "EEEE"
        return formater.string(from: inputDate)
    }

