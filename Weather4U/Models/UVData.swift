//
//  UVData.swift
//  Weather4U
//
//  Created by t2023-m0056 on 5/22/24.
//

import Foundation

// MARK: - UVData
struct UVData: Codable {
    let response: UVResponse
}

// MARK: - UVResponse
struct UVResponse: Codable {
    let header: UVHeader
    let body: UVBody
}

// MARK: - UVBody
struct UVBody: Codable {
    let dataType: String
    let items: UVItems
    let pageNo, numOfRows, totalCount: Int
}

// MARK: - Items
struct UVItems: Codable {
    let item: [[String: String]]
}

// MARK: - UVHeader
struct UVHeader: Codable {
    let resultCode, resultMsg: String
}
