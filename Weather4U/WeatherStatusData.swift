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

// MARK: - Response
struct StatusResponse: Codable {
    let header: StatusHeader
    let body: Body
}

// MARK: - Body
struct StatusBody: Codable {
    let dataType: String
    let items: StatusItems
    let pageNo, numOfRows, totalCount: Int
}

// MARK: - Items
struct StatusItems: Codable {
    let item: [StatusItem]
}

// MARK: - Item
struct StatusItem: Codable {
    let regID: String
    let rnSt3Am, rnSt3Pm, rnSt4Am, rnSt4Pm: Int
    let rnSt5Am, rnSt5Pm, rnSt6Am, rnSt6Pm: Int
    let rnSt7Am, rnSt7Pm: Int
    let wf3Am, wf3Pm, wf4Am, wf4Pm: String
    let wf5Am, wf5Pm, wf6Am, wf6Pm: String
    let wf7Am, wf7Pm: String

    enum CodingKeys: String, CodingKey {
        case regID = "regId"
        case rnSt3Am, rnSt3Pm, rnSt4Am, rnSt4Pm, rnSt5Am, rnSt5Pm, rnSt6Am, rnSt6Pm, rnSt7Am, rnSt7Pm, wf3Am, wf3Pm, wf4Am, wf4Pm, wf5Am, wf5Pm, wf6Am, wf6Pm, wf7Am, wf7Pm
    }
}

// MARK: - Header
struct StatusHeader: Codable {
    let resultCode, resultMsg: String
}
