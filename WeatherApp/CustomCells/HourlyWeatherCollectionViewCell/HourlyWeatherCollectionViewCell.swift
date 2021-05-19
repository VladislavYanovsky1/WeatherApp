

import UIKit

class HourlyWeatherCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    static let identifier = "HourlyWeatherCollectionViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "HourlyWeatherCollectionViewCell",
                     bundle: nil)
    }

    func configure(with model: HourlyWeatherCollectionViewCellViewModel )  {
        hourLabel.text = model.dt
        tempLabel.text = model.temp
        
        self.iconImageView.image = model.iconName.image()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
