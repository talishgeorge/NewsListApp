//
//  Constants.swift
//  NewsListApp
//
//  Created by Talish George on 29/11/21.
//

import Foundation

enum ErrorKey: String {
    case general = "Error_general"
    case parsing = "Error_parsing"
}

enum ResponseType: Int {
   case news = 1, weather
}

/// API Constants
struct ApiConstants {
    static public let apiKey = "6a3ce0a5c952460fb0ea2fd9163d9ddf"
    static public let baseUrl = "https://newsapi.org"
    static public let newsOpenURL =  "https://newsapi.org/v2/top-headlines?category=General&country=us&apiKey=6a3ce0a5c952460fb0ea2fd9163d9ddf"
    static public let openWeatherURL = "https://api.openweathermap.org/data/2.5/weather?q=London,uk&Appid=315a5a4dae4ad2b0554677c7fdfdada1"
    static public let newsUrl = "https://samples.openweathermap.org/data/2.5/forecast/daily?q=M%C3%BCnchen,DE&appid=b6907d289e10d714a6e88b30761fae22"
    static public let newsCategory = "General"
    static public let article = "Article"
    static public let decodingType = "json"
    static let news: String = "top-headlines?category=General&country=us&apiKey=6a3ce0a5c952460fb0ea2fd9163d9ddf"
}

/// Cell Identifiers
struct CellIdentifiers {
    static public let newsHeaderCell  = "NewsHeaderView"
    static public let newsCell  = "NewsTableViewCell"
}
