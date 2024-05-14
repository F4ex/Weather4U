//
//  LocationData.swift
//  Weather4U
//
//  Created by t2023-m0056 on 5/14/24.
//

import Foundation

// MARK: - LocationDatum
struct LocationDatum: Codable {
    let city: City
    let town, village: String
    let x, y: Int

    enum CodingKeys: String, CodingKey {
        case city = "City"
        case town = "Town"
        case village = "Village"
        case x = "X"
        case y = "Y"
    }
}

enum City: String, Codable {
    case 강원특별자치도 = "강원특별자치도"
    case 경기도 = "경기도"
    case 경상남도 = "경상남도"
    case 경상북도 = "경상북도"
    case 광주광역시 = "광주광역시"
    case 대구광역시 = "대구광역시"
    case 대전광역시 = "대전광역시"
    case 부산광역시 = "부산광역시"
    case 서울특별시 = "서울특별시"
    case 세종특별자치시 = "세종특별자치시"
    case 울산광역시 = "울산광역시"
    case 이어도 = "이어도"
    case 인천광역시 = "인천광역시"
    case 전라남도 = "전라남도"
    case 전라북도 = "전라북도"
    case 제주특별자치도 = "제주특별자치도"
    case 충청남도 = "충청남도"
    case 충청북도 = "충청북도"
}

typealias LocationData = [LocationDatum]
