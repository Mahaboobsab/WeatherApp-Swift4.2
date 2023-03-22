//
//  ViewController.swift
//  WeatherApp
//
//  Created by Meheboob Nadaf on 21/03/23.
//

import UIKit
import SDWebImage
import CoreLocation

class ViewController: BaseViewController, CLLocationManagerDelegate {
    
    // MARK:  Outlet's
    
    @IBOutlet weak var tempMaxLbl: UILabel!
    @IBOutlet weak var feelsLikeLbl: UILabel!
    @IBOutlet weak var tempMinLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var weatherDiscLbl: UILabel!
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var degreeLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    // MARK:  Propertie's
    private let homeViewModel = HomeViewModelImp()
    private var weatherModel: WeatherModel?
    var locManager = CLLocationManager()
    var lattitude: String?
    var longitude: String?
    
    // MARK:  Life Cycle Method's
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locManager.requestWhenInUseAuthorization()
        locManager.delegate = self
        locManager.requestLocation()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location else {
                return
            }
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            
        }
        
    }
    
    // MARK:  API Helper's
    
    private func getWeatherDetails(lattitude: String, longitude: String) {
        if Connectivity.isConnectedToInternet {
            startAnimation()
            homeViewModel.getWeatherDetails(endPoint: String(format: Constants.kHomeURL, lattitude,longitude,Constants.kAppid)) { response in
                self.stopAnimation()
                switch response {
                case .success(let data):
                    self.weatherModel = data
                    self.updateUI()
                case .failure(let error):
                    self.showAlertMessage(error.localizedDescription, title: NSLocalizedString("General.Error", comment: ""), ok: NSLocalizedString("General.ok", comment: ""), cancel: nil)
                }
            }
        } else {
            self.showAlertMessage(NSLocalizedString("General.Network.Error", comment: ""), title: NSLocalizedString("General.Error", comment: ""), ok: NSLocalizedString("General.ok", comment: ""), cancel: nil)
        }
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.cityNameLbl.text = self.weatherModel?.name
            if let temp = self.weatherModel?.main?.temp {
                self.tempLbl.text = "\(Int(temp - 273.15))°c"
            }
            let imageUrl = String(format: Constants.kImageBaseUrl, self.weatherModel?.weather?.first?.icon ?? "")
            self.weatherImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "background.jpg"))
            self.weatherDiscLbl.text = self.weatherModel?.weather?.first?.description ?? ""
            if let humidity = self.weatherModel?.main?.humidity {
                self.humidityLbl.text = "\(humidity)"
            }
            if let feelsLike = self.weatherModel?.main?.feelsLike {
                self.feelsLikeLbl.text = "\(feelsLike)"
            }
            if let tempMin = self.weatherModel?.main?.tempMin {
                self.tempMinLbl.text = "\(tempMin)"
            }
            if let tempMax = self.weatherModel?.main?.tempMax {
                self.tempMaxLbl.text = "\(tempMax)"
            }
        }
    }
    
    @IBAction func searchCountry(_ sender: Any) {
        let popOver = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchCityVC") as! SearchCityVC
        popOver.delegate = self
        present(popOver, animated: true, completion: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last! as CLLocation
        lattitude = "\(currentLocation.coordinate.latitude)"
        longitude = "\(currentLocation.coordinate.longitude)"
        getWeatherDetails(lattitude: "\(currentLocation.coordinate.latitude)", longitude: "\(currentLocation.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
        getWeatherDetails(lattitude: "44.34", longitude: "10.99")
    }
    
    @IBAction func refresh(_ sender: Any) {
        getWeatherDetails(lattitude: lattitude ?? "", longitude: longitude ?? "")
    }
}


extension ViewController: SerachCityProtocolDelegate {
    func getSearchedCIty(city: CityList) {
        if let lat = city.lat, let lon = city.lon{
            self.getWeatherDetails(lattitude: "\(lat)", longitude: "\(lon)")
        }
    }
}
