
import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var dayTempLabel: UILabel!
    @IBOutlet var nightTempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    static let identifier = "WeatherTableViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell",
                     bundle: nil)
    }
    
    func configure(with model: WeatherTableViewCellViewModel) {
        self.dayTempLabel.text = model.dayTemp
        self.nightTempLabel.text = model.nightTemp
        self.dayLabel.text = model.day
        self.iconImageView.image = model.iconName.image()
    }
}

