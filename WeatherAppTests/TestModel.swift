//
//  TestModel.swift
//  WeatherApp
//
//  Created by mituser on 22/03/23.
//

import Foundation

struct CityRequest: Encodable {
    let lat, lon, city: String?
}

struct CityAPIResponse : Codable {
    let message : String?
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}


struct ValidationResponse {
    let message, cod : String?
    let isValid: Bool
}
