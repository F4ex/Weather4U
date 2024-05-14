//
//  WeatherTemperatureData.swift
//  Weather4U
//
//  Created by t2023-m0056 on 5/14/24.
//

import Foundation

// MARK: - WeatherTemperatureData
struct WeatherTemperatureData: Codable {
    let response: TemperatureResponse
}

// MARK: - TemperatureResponse
struct TemperatureResponse: Codable {
    let header: TemperatureHeader
    let body: TemperatureBody
}

// MARK: - Body
struct TemperatureBody: Codable {
    let dataType: String
    let items: TemperatureItems
    let pageNo, numOfRows, totalCount: Int
}

// MARK: - Items
struct TemperatureItems: Codable {
    let item: [TemperatureItem]
}

// MARK: - Item
struct TemperatureItem: Codable {
    let regID: String
    let taMin3, taMax3: Int
    let taMin4, taMax4: Int
    let taMin5, taMax5: Int
    let taMin6, taMax6: Int
    let taMin7, taMax7: Int

    enum CodingKeys: String, CodingKey {
        case regID = "regId"
        case taMin3, taMax3, taMin4, taMax4, taMin5, taMax5, taMin6, taMax6, taMin7, taMax7 
    }
}

// MARK: - Header
struct TemperatureHeader: Codable {
    let resultCode, resultMsg: String
}
