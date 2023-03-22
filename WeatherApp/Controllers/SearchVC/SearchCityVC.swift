//
//  SearchCityVC.swift
//  WeatherApp
//
//  Created by Meheboob Nadaf on 22/03/23.
//

import UIKit

protocol SerachCityProtocolDelegate: AnyObject {
    func getSearchedCIty(city: CityList)
}

class SearchCityVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchOutlet: UIButton!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTxt: UITextField!
    var cityList = [CityList]()
    var cachedCityList = [CityList]()
    
    // MARK:  Propertie's
    
    private let searchViewModel = SearchViewModelImp()
    weak var delegate: SerachCityProtocolDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        searchTableView.separatorColor = .clear
        searchOutlet.layer.cornerRadius = 25
        searchOutlet.clipsToBounds = true
        if let data = UserDefaults.standard.data(forKey: "cities") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                // Decode Note
                self.cityList = try decoder.decode([CityList].self, from: data)
                cachedCityList = try decoder.decode([CityList].self, from: data)
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
    }
    
    @IBAction func searchAction(_ sender: Any) {
        getCityList()
    }
    
    func getCityList() {
        if Connectivity.isConnectedToInternet {
            startAnimation()
            searchViewModel.getCityDetails(endPoint: String(format: Constants.kSearchCityUrl, searchTxt.text ?? "",Constants.kAppid)) { response in
                self.stopAnimation()
                switch response {
                case .success(let data):
                    let list = data.filter({$0.country == "US"})
                    if list.isEmpty {
                        self.showAlertMessage(NSLocalizedString("SearchCity.noresults.error", comment: ""), title: NSLocalizedString("General.Error", comment: ""), ok: NSLocalizedString("General.ok", comment: ""), cancel: nil)
                    } else {
                        self.cityList = list
                        DispatchQueue.main.async {
                            self.searchTableView.reloadData()
                        }
                    }
                case .failure(let error):
                    self.showAlertMessage(error.localizedDescription, title: NSLocalizedString("General.Error", comment: ""), ok: NSLocalizedString("General.ok", comment: ""), cancel: nil)
                }
            }
        } else {
            self.showAlertMessage(NSLocalizedString("General.Network.Error", comment: ""), title: NSLocalizedString("General.Error", comment: ""), ok: NSLocalizedString("General.ok", comment: ""), cancel: nil)
        }
        
    }
}

extension SearchCityVC {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityListCell", for: indexPath) as! CityListCell
        cell.cityNameLbl.text = cityList[indexPath.row].name
        cell.cityStateLbl.text = cityList[indexPath.row].state
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cities = [CityList]()
        cities.append(cityList[indexPath.row])
        cities.append(contentsOf: cachedCityList)
        let points: Set<CityList> = Set(cities)
        cities.removeAll()
        cities.append(contentsOf: points)
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()
            // Encode Note
            let data = try encoder.encode(cities)
            // Write/Set Data
            UserDefaults.standard.set(data, forKey: "cities")
            
        } catch {
            print("Unable to Encode Note (\(error))")
        }
        delegate?.getSearchedCIty(city: cityList[indexPath.row])
        self.dismiss(animated: true)
        
    }
}
