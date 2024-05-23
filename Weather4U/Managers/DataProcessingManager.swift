//
//  Category.swift
//  Weather4U
//
//  Created by t2023-m0056 on 5/13/24.
//

import UIKit

struct Weather {
    let time: String   // 오늘 시간별 값
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

struct WeekForecast {
    let status: String
    let highTemp: String
    let lowTemp: String
    let rainPercent: String
}

struct DayForecast {
    let time: String
    let status: String
    let temp: String
    let PCP: String
    let SNO: String
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

class DataProcessingManager {
    
    static let shared = DataProcessingManager()
    static var threeDaysWeatherData: [[Weather]] = []
    static var myWeatherDatas: [[Weather]] = []
    static var weekForecast: [WeekForecast] = []
    static var dayForecast: [DayForecast] = []
    weak var delegate: DataReloadDelegate?
    
    private init() { }
    
    // MARK: - 3일치 날씨상태를 나타내는 [[Weather]] 배열을 반환하는 함수
    func forecastForDates(items: [Item], fcstDate: Date) {
        var weatherDataForThreeDays: [[Weather]] = [[], [], []]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        let calendar = Calendar.current
        let todayDate = calendar.startOfDay(for: fcstDate)
        let tomorrowDate = calendar.date(byAdding: .day, value: 1, to: todayDate)!
        let dayAfterTomorrowDate = calendar.date(byAdding: .day, value: 2, to: todayDate)!

        // 오늘, 내일, 모레 날짜에 해당하는 데이터를 추출합니다.
        let dates = [todayDate, tomorrowDate, dayAfterTomorrowDate]
        
        for (index, date) in dates.enumerated() {
            let currentDate = formatter.string(from: date)
            
            // 특정 날짜에 해당하는 아이템들을 필터링합니다.
            let filteredItems = items.filter { $0.fcstDate == currentDate }
            
            // 시간별로 그룹핑합니다.
            let groupedByTime = Dictionary(grouping: filteredItems) { $0.fcstTime }
            
            // 각 시간별로 Weather 객체를 생성합니다.
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
                    case Category.TMP.rawValue, Category.TMN.rawValue, Category.TMX.rawValue:
                        if let doubleValue = Double(item.fcstValue) {
                            value = String(format: "%.0f", doubleValue)
                        } else {
                            value = item.fcstValue
                        }
                    default:
                        value = item.fcstValue
                    }
                    weatherDict[item.category] = value
                }
                
                // Weather 객체를 생성하여 리스트에 추가합니다.
                let weather = Weather(
                    time: time,
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
                weatherDataForThreeDays[index].append(weather)
            }
            // 시간별로 정렬합니다.
            weatherDataForThreeDays[index].sort { $0.time < $1.time }
        }
        DataProcessingManager.threeDaysWeatherData = weatherDataForThreeDays
    }

    // MARK: - 강수형태 설명 반환 함수
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
    
    // MARK: - 하늘상태 설명 반환 함수
    func skyStatusDescription(from code: String) -> String {
        switch code {
        case "1": return "Sunny"
        case "3": return "Mostly Cloudy"
        case "4": return "Cloudy"
        default: return "Rain / Snow"
        }
    }
    
    // MARK: - 오늘 날짜의 날씨상태를 반환해주는 함수
    func getTodayWeatherDataValue(dataKey: Category, currentTime: Bool = true, highTemp: Bool = false) -> String? {
        var currentTimeString = ""
        
        if currentTime {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH00"
            currentTimeString = formatter.string(from: Date())
        } else {
            currentTimeString = highTemp ? "1500" : "0600"
        }
        
        guard let forecastAtTime = DataProcessingManager.threeDaysWeatherData.first?.first(where: { $0.time == currentTimeString }) else {
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
    
    // MARK: - 일주일 날씨 및 기온을 나타내는 [WeekForecast]배열을 반환하는 함수
    func weeksTemperatureStatus() {
        var weekForecast: [WeekForecast] = []

        // 현재 시간 기준 오늘의 날씨 상태, 최고 기온 및 최저 기온을 기반으로 WeekForecast 객체 생성
        for _ in 0..<3 {
            let week = WeekForecast(
                status: DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .SKY) ?? "-",
                highTemp: DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .TMX, currentTime: false, highTemp: true) ?? "0",
                lowTemp: DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .TMN, currentTime: false) ?? "-",
                rainPercent: DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .POP) ?? "-"
            )
            weekForecast.append(week)
        }

        // NetworkManager를 통해 받아온 주간 날씨 데이터를 기반으로 WeekForecast 객체 생성
        if let weatherStatusData = NetworkManager.weatherStatusData?.first,
           let weatherTemperatureData = NetworkManager.weatherTemperatureData?.first {
            let days = [(weatherStatusData.wf3Pm, weatherTemperatureData.taMax3, weatherTemperatureData.taMin3, weatherStatusData.rnSt3Pm),
                        (weatherStatusData.wf4Pm, weatherTemperatureData.taMax4, weatherTemperatureData.taMin4, weatherStatusData.rnSt4Pm),
                        (weatherStatusData.wf5Pm, weatherTemperatureData.taMax5, weatherTemperatureData.taMin5, weatherStatusData.rnSt5Pm),
                        (weatherStatusData.wf6Pm, weatherTemperatureData.taMax6, weatherTemperatureData.taMin6, weatherStatusData.rnSt6Pm),
                        (weatherStatusData.wf7Pm, weatherTemperatureData.taMax7, weatherTemperatureData.taMin7, weatherStatusData.rnSt7Pm)]

            for day in days {
                let week = WeekForecast(
                    status: day.0,
                    highTemp: String(day.1),
                    lowTemp: String(day.2),
                    rainPercent: String(day.3)
                )
                weekForecast.append(week)
            }
        }
        DataProcessingManager.weekForecast = weekForecast
        self.delegate?.dataReload()
    }
    
    // MARK: - 24시간 날씨를 [DayForecast] 배열에 담아 반환하는 함수
    func dayForecast() {
        // 현재 시간을 가져옵니다.
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH00"
        
        // 현재 시간을 시간 단위로 추출합니다.
        let currentHour = Int(formatter.string(from: now)) ?? 0
        
        // 24시간 동안의 데이터를 담을 배열을 초기화합니다.
        var dayForecasts: [DayForecast] = []
        
        // threeDaysWeatherData에서 데이터를 추출합니다.
        for dayIndex in 0..<3 {
            for weather in DataProcessingManager.threeDaysWeatherData[dayIndex] {
                // 현재 시간부터 24시간까지의 데이터를 추출합니다.
                if let weatherHour = Int(weather.time), (weatherHour >= currentHour && dayIndex == 0) || (dayIndex > 0) {
                    // DayForecast 객체를 생성하여 배열에 추가합니다.
                    let forecast = DayForecast(
                        time: weather.time,
                        status: weather.SKY,  // 하늘 상태
                        temp: weather.TMP,    // 기온
                        PCP: weather.POP,     // 강수확률
                        SNO: weather.PTY      // 강수형태
                    )
                    dayForecasts.append(forecast)
                    
                    // 24개의 데이터를 추출하면 반환합니다.
                    if dayForecasts.count == 24 {
                        DataProcessingManager.dayForecast = dayForecasts
                        return
                    }
                }
            }
        }
        
        // 만약 24개의 데이터를 추출하지 못했다면 남은 데이터를 채워서 반환합니다.
        while dayForecasts.count < 24 {
            let emptyForecast = DayForecast(time: "-", status: "0", temp: "0", PCP: "0", SNO: "0")
            dayForecasts.append(emptyForecast)
        }
        
        DataProcessingManager.dayForecast = dayForecasts
        return
    }
    
    // [불쾌지수 = 0.81 \times 기온 + 0.01 \times 습도 \times (0.99 \times 기온 - 14.3) + 46.3]를 계산하는 함수
    func discomfortIndexCalculation() -> UIImage? {
        guard let temperatureString = DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .TMP),
              let humidityString = DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .REH),
              let temperature = Double(temperatureString),
              let humidity = Double(humidityString) else {
            return nil
        }
        
        let temperatureFactor = 0.81 * temperature
        let humidityFactor = 0.01 * humidity * (0.99 * temperature - 14.3)
        let constant = 46.3
        let discomfortIndex: Double = temperatureFactor + humidityFactor + constant
        
        switch discomfortIndex {
        case 0..<65:
            return UIImage(named: "smile")
        case 65..<75:
            return UIImage(named: "straightFace")
        case 75..<80:
            return UIImage(named: "nah")
        default:
            return UIImage(named: "frown")
        }
    }
    
    // [불쾌지수 = 0.81 \times 기온 + 0.01 \times 습도 \times (0.99 \times 기온 - 14.3) + 46.3]를 계산하는 함수
    func discomfortIndexString() -> String {
        guard let temperatureString = DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .TMP),
              let humidityString = DataProcessingManager.shared.getTodayWeatherDataValue(dataKey: .REH),
              let temperature = Double(temperatureString),
              let humidity = Double(humidityString) else {
            return ""
        }
        
        let temperatureFactor = 0.81 * temperature
        let humidityFactor = 0.01 * humidity * (0.99 * temperature - 14.3)
        let constant = 46.3
        let discomfortIndex: Double = temperatureFactor + humidityFactor + constant
        
        switch discomfortIndex {
        case 0..<65:
            return "Perfect"
        case 65..<75:
            return "Fine"
        case 75..<80:
            return "Bad"
        default:
            return "Terrible"
        }
    }

    func currentFormattedTime() -> String {
                let now = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "HH00"
                return formatter.string(from: now)
            }

}
