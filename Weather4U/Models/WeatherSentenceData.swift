//
//  WeatherSentence.swift
//  Weather4U
//
//  Created by t2023-m0056 on 5/14/24.
//

import Foundation

// MARK: - WeatherSentenceData
struct WeatherSentenceData: Codable {
    let response: SentenceResponse
}

// MARK: - SentenceResponse
struct SentenceResponse: Codable {
    let header: Header
    let body: SentenceBody
}

// MARK: - SentenceBody
struct SentenceBody: Codable {
    let dataType: String
    let items: SentenceItems
    let pageNo, numOfRows, totalCount: Int
}

// MARK: - SentenceItems
struct SentenceItems: Codable {
    let item: [SentenceItem]
}

// MARK: - SentenceItem
struct SentenceItem: Codable {
    let wfSv: String
}
