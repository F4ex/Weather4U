//
//  WeatherData.swift
//  Weather4U
//
//  Created by t2023-m0056 on 5/13/24.
//

import Foundation

// MARK: - WeatherData
struct WeatherData: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let header: Header
    let body: Body
}

// MARK: - Body
struct Body: Codable {
    let dataType: String
    let items: Items
    let pageNo, numOfRows, totalCount: Int
}

// MARK: - Items
struct Items: Codable {
    let item: [Item]
}

// MARK: - Item
struct Item: Codable {
    let baseDate, baseTime, category: String
    let nx, ny: Int
    let obsrValue: String
}

// MARK: - Header
struct Header: Codable {
    let resultCode, resultMsg: String
}
