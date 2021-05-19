
import Foundation

class WeatherResponse: Codable {
    var lat: Double?
    var lon: Double?
    var timezone: String?
    var current: CurrentWeather?
    var daily: [DailyWeather]
    var hourly: [HourlyWeather]
}

class CurrentWeather: Codable {
    var dt: Int?
    var sunrise: Int?
    var sunset: Int?
    var temp: Double?
    var feels_like: Double?
    var pressure: Int?
    var humidity: Int?
    var wind_speed: Double?
    var icon: String?
    var weather: [Weather]
}

class Weather: Codable {
    var main: String?
    var temp: Temperature?
    var weather: [DailyWeatherCondition]?
    
}

class DailyWeather: Codable {
    var dt: Double?
    var temp: Temperature?
    var weather: [DailyWeatherCondition]
}


class Temperature: Codable {
    var day: Double?
    var night: Double?
    
}

class DailyWeatherCondition: Codable {
    var main: String?
    var description: String?
    var icon: String?
}

class HourlyWeather: Codable {
    var dt: Int?
    var temp: Double?
    var weather: [HourlyIcons]
}

class HourlyIcons: Codable {
    var icon: String?
    
}
