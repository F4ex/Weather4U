//
//  Category.swift
//  Weather4U
//
//  Created by t2023-m0056 on 5/13/24.
//

import Foundation

enum Category: String, CaseIterable {
    case POP = "POP"   // 강수확률(%)
    case PTY = "PTY"   // 강수형태(코드값)
    case PCP = "PCP"   // 1시간 강수량(1mm)
    case REH = "REH"   // 습도(%)
    case SNO = "SNO"   // 1시간 신적설(1mm)
    case SKY = "SKY"   // 하늘상태(코드값)
    case TMP = "TMP"   // 1시간 기온(℃)
    case TMN = "TMN"   // 일 최저기온(℃)
    case TMX = "TMX"   // 일 최고기온(℃)
    case UUU = "UUU"   // 풍속(동서성분m/s)
    case VVV = "VVV"   // 풍속(남북성분m/s)
    case WAV = "WAV"   // 파고(M)
    case VEC = "VEC"   // 풍향(deg)
    case WSD = "WSD"   // 풍속(m/s)
}

class CategoryManager {
    
    static let shared = CategoryManager()
    static var todayWeatherData: [String: [[String:String]]] = [:]
    
    private init() { }
    
    func forecastForDate(items: [Item], fcstDate: Date) -> [String: [[String:String]]] {
        var forecastsByTime: [String: [[String:String]]] = [:]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let currentDate = formatter.string(from: fcstDate)
        
        // 특정 날짜에 해당하는 아이템들을 필터링합니다.
        let filteredItems = items.filter { $0.fcstDate == currentDate }

        // 필터링된 아이템들을 시간별로 처리합니다.
        for item in filteredItems {
            // 각 아이템의 카테고리에 따른 처리를 준비합니다.
            let value: String
            switch item.category {
            case Category.PTY.rawValue:
                value = rainTypeDescription(from: item.fcstValue)
            case Category.SKY.rawValue:
                value = skyStatusDescription(from: item.fcstValue)
            default:
                value = item.fcstValue
            }
            
            // 예보 시각을 기준으로 딕셔너리를 업데이트합니다.
            let category = Category(rawValue: item.category)
            let categoryDescription = category?.categoryDescription() ?? "Unknown"
            let forecastInfo = [categoryDescription: value]
            
            if forecastsByTime[item.fcstTime] != nil {
                forecastsByTime[item.fcstTime]?.append(forecastInfo)
            } else {
                forecastsByTime[item.fcstTime] = [forecastInfo]
            }
        }
        print(forecastsByTime)
        return forecastsByTime
    }
    
    // 강수형태 설명 반환 함수
    func rainTypeDescription(from code: String) -> String {
        switch code {
        case "0": return "없음"
        case "1": return "비"
        case "2": return "비/눈"
        case "3": return "눈"
        case "4": return "소나기"
        default: return "알 수 없음"
        }
    }
    
    // 하늘상태 설명 반환 함수
    func skyStatusDescription(from code: String) -> String {
        switch code {
        case "1": return "맑음"
        case "3": return "구름 많음"
        case "4": return "흐림"
        default: return "알 수 없음"
        }
    }
}

// 카테고리 설명 변환 함수
extension Category {
    func categoryDescription() -> String {
        switch self {
        case .POP:
            return "강수확률"
        case .PTY:
            return "강수형태"
        case .PCP:
            return "1시간 강수량"
        case .REH:
            return "습도"
        case .SNO:
            return "1시간 신적설"
        case .SKY:
            return "하늘상태"
        case .TMP:
            return "1시간 기온"
        case .TMN:
            return "일 최저기온"
        case .TMX:
            return "일 최고기온"
        case .UUU:
            return "풍속(동서성분)"
        case .VVV:
            return "풍속(남북성분)"
        case .WAV:
            return "파고"
        case .VEC:
            return "풍향"
        case .WSD:
            return "풍속"
        }
    }
}
