//
//  PerceivedTemperatureData.swift
//  Weather4U
//
//  Created by t2023-m0056 on 5/22/24.
//

import Foundation

// MARK: - PerceivedTemperatureData
struct PerceivedTemperatureData: Codable {
    let response: PerceivedTemperatureResponse
}

// MARK: - PerceivedTemperatureResponse
struct PerceivedTemperatureResponse: Codable {
    let header: PerceivedTemperatureHeader
    let body: PerceivedTemperatureBody
}

// MARK: - PerceivedTemperatureBody
struct PerceivedTemperatureBody: Codable {
    let dataType: String
    let items: PerceivedTemperatureItems
    let pageNo, numOfRows, totalCount: Int
}

// MARK: - PerceivedTemperatureItems
struct PerceivedTemperatureItems: Codable {
    let item: [[String: String]]
}

// MARK: - PerceivedTemperatureHeader
struct PerceivedTemperatureHeader: Codable {
    let resultCode, resultMsg: String
}
