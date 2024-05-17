//
//  Category.swift
//  Weather4U
//
//  Created by t2023-m0056 on 5/13/24.
//

import Foundation

struct TodayWeather {
    let todayTime: String   // 오늘 시간별 값
    let POP: String   // 강수확률(%)
    let PTY: String   // 강수형태(코드값)
    let PCP: String   // 1시간 강수량(1mm)
    let REH: String   // 습도(%)
    let SNO: String   // 1시간 신적설(1mm)
    let SKY: String   // 하늘상태(코드값)
    let TMP: String   // 1시간 기온(℃)
    let TMN: String   // 일 최저기온(℃)
    let TMX: String   // 일 최고기온(℃)
    let UUU: String   // 풍속(동서성분m/s)
    let VVV: String   // 풍속(남북성분m/s)
    let WAV: String   // 파고(M)
    let VEC: String   // 풍향(deg)
    let WSD: String   // 풍속(m/s)
}

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
    static var todayWeatherData: [TodayWeather] = []
    
    private init() { }
    
    func forecastForDate(items: [Item], fcstDate: Date) -> [TodayWeather] {
        var todayWeatherList: [TodayWeather] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let currentDate = formatter.string(from: fcstDate)
        
        // 특정 날짜에 해당하는 아이템들을 필터링합니다.
        let filteredItems = items.filter { $0.fcstDate == currentDate }
        
        // 시간별로 그룹핑합니다.
        let groupedByTime = Dictionary(grouping: filteredItems) { $0.fcstTime }
        
        // 각 시간별로 TodayWeather 객체를 생성합니다.
        for (time, items) in groupedByTime {
            var weatherDict = [String: String]()
            
            // 각 카테고리별 최신 값을 딕셔너리에 저장합니다.
            items.forEach { item in
                let value: String
                switch item.category {
                case Category.PTY.rawValue:
                    value = rainTypeDescription(from: item.fcstValue)
                case Category.SKY.rawValue:
                    value = skyStatusDescription(from: item.fcstValue)
                default:
                    value = item.fcstValue
                }
                weatherDict[item.category] = value
            }
            
            // TodayWeather 객체를 생성하여 리스트에 추가합니다.
            let weather = TodayWeather(
                todayTime: time,
                POP: weatherDict["POP"] ?? "0", // 강수확률
                PTY: weatherDict["PTY"] ?? "0", // 강수형태
                PCP: weatherDict["PCP"] ?? "0", // 1시간 강수량
                REH: weatherDict["REH"] ?? "0", // 습도
                SNO: weatherDict["SNO"] ?? "0", // 1시간 신적설
                SKY: weatherDict["SKY"] ?? "0", // 하늘상태
                TMP: weatherDict["TMP"] ?? "0", // 1시간 기온
                TMN: weatherDict["TMN"] ?? "0", // 일 최저기온
                TMX: weatherDict["TMX"] ?? "0", // 일 최고기온
                UUU: weatherDict["UUU"] ?? "0", // 풍속(동서성분)
                VVV: weatherDict["VVV"] ?? "0", // 풍속(남북성분)
                WAV: weatherDict["WAV"] ?? "0", // 파고
                VEC: weatherDict["VEC"] ?? "0", // 풍향
                WSD: weatherDict["WSD"] ?? "0"  // 풍속
            )
            
            todayWeatherList.append(weather)
        }
        
        // 시간별로 정렬합니다.
        todayWeatherList.sort { $0.todayTime < $1.todayTime }
        return todayWeatherList
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
    
    func getTodayWeatherDataValue(dataKey: Category, currentTime: Bool = true, highTemp: Bool = false) -> String? {
        var currentTimeString = ""
        
        if currentTime {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH00"
            currentTimeString = formatter.string(from: Date())
        } else {
            currentTimeString = highTemp ? "1500" : "0600"
        }
        
        guard let forecastAtTime = CategoryManager.todayWeatherData.first(where: { $0.todayTime == currentTimeString }) else {
            print("\(currentTimeString)시 데이터가 없습니다.")
            return nil
        }
        
        switch dataKey {
        case .POP:
            return forecastAtTime.POP
        case .PTY:
            return forecastAtTime.PTY
        case .PCP:
            return forecastAtTime.PCP
        case .REH:
            return forecastAtTime.REH
        case .SNO:
            return forecastAtTime.SNO
        case .SKY:
            return forecastAtTime.SKY
        case .TMP:
            return forecastAtTime.TMP
        case .TMN:
            return forecastAtTime.TMN
        case .TMX:
            return forecastAtTime.TMX
        case .UUU:
            return forecastAtTime.UUU
        case .VVV:
            return forecastAtTime.VVV
        case .WAV:
            return forecastAtTime.WAV
        case .VEC:
            return forecastAtTime.VEC
        case .WSD:
            return forecastAtTime.WSD
        }
    }
}
