//
//  Constants.swift
//  MVVMDemo
//
//  Created by Mahaboob on 10/09/20.
//  Copyright © 2020 Meheboob. All rights reserved.
//

import UIKit

class Constants: NSObject {
    static let kHomeURL = "data/2.5/weather?lat=%@&lon=%@&appid=%@"
    static let kImageBaseUrl = "https://openweathermap.org/img/wn/%@@2x.png"
    static let kSearchCityUrl = "geo/1.0/direct?q=%@&limit=100&appid=%@&country code=US"
    static let kAppid="f32f36efd5c0cefa353f90cb87fa26d5"
}
