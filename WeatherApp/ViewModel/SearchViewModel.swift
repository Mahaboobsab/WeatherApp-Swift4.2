//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Meheboob Nadaf on 22/03/23.
//

import Foundation

protocol SearchViewModel {
    func getCityDetails(endPoint:String, completion: @escaping Response<[CityList]>)
}
