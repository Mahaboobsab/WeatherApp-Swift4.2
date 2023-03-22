//
//  SearchViewModelImp.swift
//  WeatherApp
//
//  Created by mituser on 22/03/23.
//

import Foundation

class SearchViewModelImp: SearchViewModel {
    func getCityDetails(endPoint: String, completion: @escaping Response<[CityList]>) {
        CityList.getCityDetails(endPoint: endPoint) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
