//
//  WeatherStatusData.swift
//  Weather4U
//
//  Created by t2023-m0056 on 5/14/24.
//

import Foundation

// MARK: - WeatherStatusData
struct WeatherStatusData: Codable {
    let response: StatusResponse
}

// MARK: - StatusResponse
struct StatusResponse: Codable {
    let header: StatusHeader
    let body: StatusBody
}

// MARK: - StatusBody
struct StatusBody: Codable {
    let dataType: String
    let items: StatusItems
    let pageNo, numOfRows, totalCount: Int
}

// MARK: - StatusItems
struct StatusItems: Codable {
    let item: [StatusItem]
}

// MARK: - StatusItem
struct StatusItem: Codable {
    let regID: String
    let wf3Am, wf3Pm, wf4Am, wf4Pm: String
    let wf5Am, wf5Pm, wf6Am, wf6Pm: String
    let wf7Am, wf7Pm: String

    enum CodingKeys: String, CodingKey {
        case regID = "regId"
        case wf3Am, wf3Pm, wf4Am, wf4Pm, wf5Am, wf5Pm, wf6Am, wf6Pm, wf7Am, wf7Pm
    }
}

// MARK: - StatusHeader
struct StatusHeader: Codable {
    let resultCode, resultMsg: String
}
