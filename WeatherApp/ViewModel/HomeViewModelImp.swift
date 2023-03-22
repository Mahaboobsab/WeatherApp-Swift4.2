//
//  HomeViewModelImp.swift
//  WeatherApp
//
//  Created by Meheboob Nadaf on 21/03/23.
//

import Foundation

class HomeViewModelImp: HomeViewModel {
    func getWeatherDetails(endPoint:String, completion: @escaping Response<WeatherModel>) {
        WeatherModel.getUserDetails(endPoint: endPoint) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
