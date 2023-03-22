//
//  HomeViewModel.swift
//  MVVMDemo
//
//  Created by Mahaboob on 10/09/20.
//  Copyright © 2020 Meheboob. All rights reserved.
//

import Foundation

protocol HomeViewModel {
    func getWeatherDetails(endPoint:String, completion: @escaping Response<WeatherModel>)
}
