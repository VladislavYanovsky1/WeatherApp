

import Foundation
import UIKit

extension String  {
    
    private static let iconIdToUIImage = [
        "01": UIImage(named: "clear sky"),
        "02": UIImage(named: "few clouds"),
        "03":  UIImage(named: "scattered clouds"),
        "04":  UIImage(named: "broken clouds"),
        "09":  UIImage(named: "shower rain"),
        "10":  UIImage(named: "rain"),
        "11":  UIImage(named: "thunderstorm"),
        "13":  UIImage(named: "snow"),
        "50":  UIImage(named: "mist")
        ]

    func image() -> UIImage? {
        let icon =  String.iconIdToUIImage.filter {self.contains($0.key)}.first?.value
//        return String.iconIdToUIImage[self] ?? UIImage(named: "error") // для картинок дня/ночи
        return icon != nil ? icon : UIImage(named: "error")
    }
}

        






