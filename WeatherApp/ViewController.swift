
import UIKit
import Foundation
import CoreLocation
import Lottie
import SCLAlertView

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource{
    
    // MARK: - IBOutlets
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet var weatherTableView: UITableView!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var searchCityTextField: UITextField!
    @IBOutlet weak var tempAndDec: UILabel!
    @IBOutlet weak var animationView: AnimationView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Decalare ViewModel
    let weatherViewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
        
       // MARK: - Animation
       
        animationView?.loopMode = .loop
        animationView?.backgroundBehavior = .pauseAndRestore
        animationView?.backgroundColor = .clear
        animationView?.frame = view.bounds
        animationView?.animationSpeed = 0.5
        animationView?.play()
       
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
        
        weatherTableView.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        weatherCollectionView.register(HourlyWeatherCollectionViewCell.nib(), forCellWithReuseIdentifier: HourlyWeatherCollectionViewCell.identifier)
        
        weatherViewModel.delegate = self
        
        bindViewModel()
        weatherViewModel.requestWeatherWithCoordinate()
}

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        animationView?.reloadImages()
    }
    
    //MARK: Functions
    private func bindViewModel() {
        
        self.weatherViewModel.city.bind { (result) in
            self.cityNameLabel.text = result
        }
        
        self.weatherViewModel.description.bind { (result) in
            self.tempAndDec.text = result
        }
        
        self.weatherViewModel.tableViewModel.bind { (result) in
            self.weatherTableView.reloadData()
        }
        self.weatherViewModel.collectionViewModel.bind { (result) in
            self.weatherCollectionView.reloadData()
        }
}

    func showAlert(withTitle title: String?, message: String?, andAction actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach({alert.addAction($0)})
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherViewModel.tableViewModel.value.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: weatherViewModel.tableViewModel.value[indexPath.row])
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherViewModel.collectionViewModel.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCollectionViewCell.identifier, for: indexPath) as! HourlyWeatherCollectionViewCell
        cell.configure(with: weatherViewModel.collectionViewModel.value[indexPath.row])
        return cell
    }

}


extension ViewController: WeatherViewModelDelegate {
    func showInternetError() {
        SCLAlertView().showWarning("No Internet connection", subTitle: "Please check your internet connection and restart the app")
    }
    
    func set(isLoadind: Bool) {
        if isLoadind {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func showAlert(with error: String) {
        SCLAlertView().showError("System Error.Please check your internet connection and restart the app", subTitle: error)
    }
    
    func openSetting() {
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingAction = UIAlertAction(title: "Setting", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        showAlert(withTitle: "Error", message: "Location acces denied. Please allow it from Settings.", andAction: [settingAction, cancelAction])
    }
}

