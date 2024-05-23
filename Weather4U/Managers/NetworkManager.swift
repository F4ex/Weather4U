//
//  NetworkManager.swift
//  Weather4U
//
//  Created by t2023-m0056 on 5/13/24.
//

import Alamofire
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    static var weatherSentenceData: String?
    static var weatherStatusData: [StatusItem]?
    static var weatherTemperatureData: [TemperatureItem]?
    static var uvData: UVItems?
    static var perceivedTemperatureData: PerceivedTemperatureItems?
    weak var delegate: DataReloadDelegate?
    private init() { }
    
    // 최저 기온 : 예측 시간(fcst_time) - 0600
    // 최고 기온 : 예측 시간(fcst_time) - 1500
    
    static var nx : Int16 = 60
    static var ny : Int16 = 127
    static var ncode : Int16 = 108
    static var ID : String = "11B00000"
    static var regID: String = "11B10101"
    static var areaNo: Int64 = 1100000000
    
    
    
    // MARK: - 3일치 날씨 데이터 받아오기
    func fetchWeatherData(x: Int16 = nx, y: Int16 = ny, completion: @escaping (Result<[Item], Error>) -> Void) {
        let currentDateString = self.currentDateToString()
            
        // 00시, 01시, 02시일 경우 전날 23시 데이터를 요청하기
        let currentHour = Calendar.current.component(.hour, from: Date())
        let baseTime = (currentHour == 0 || currentHour == 1 || currentHour == 2) ? "2300" : "0200"
        let baseDate = (currentHour == 0 || currentHour == 1 || currentHour == 2) ? self.previousDateToString() : currentDateString
        let url = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
        let serviceKey = "PMlSyH+ObW0hWwzno2IL0dV7ieP6NaJ9kdG1wVCTBmY+8SisLa9CuYGJjmIcpb5SMuJ3RgfEtTUIyE7QevwZnw=="
        let parameters: Parameters = ["dataType": "JSON",
                                      "base_date": baseDate,
                                      "base_time": baseTime,
                                      "nx": x,
                                      "ny": y,
                                      "serviceKey": serviceKey,
                                      "numOfRows": 870] // 3일치 예측 단기 예보
        AF.request(url, method: .get, parameters: parameters).validate().responseDecodable(of: WeatherData.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.response.body.items.item))
            case .failure(let error):
                print("Error: 단기 날씨 데이터 받아오기 실패, \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 3일치 날씨 데이터 배열에 담기
    func receiveWeatherData(x: Int16 = nx, y: Int16 = ny) {
        NetworkManager.shared.fetchWeatherData(x: x, y: y, completion: { result in
            switch result {
            case .success(let data):
                DataProcessingManager.shared.forecastForDates(items: data, fcstDate: Date())
            case .failure(let error):
                print(error) // 추후에 Alert창 호출로 변경
            }
        })
    }
    
    // MARK: - MyWeatherView 날씨 데이터 받아오기
    func fetchMyWeatherData(x: Int16 = nx, y: Int16 = ny, completion: @escaping (Result<[Item], Error>) -> Void) {
        let currentDateString = self.currentDateToString()
        let currentHour = Calendar.current.component(.hour, from: Date())
        let baseTime = (currentHour == 0 || currentHour == 1 || currentHour == 2) ? "2300" : "0200"
        let baseDate = (currentHour == 0 || currentHour == 1 || currentHour == 2) ? self.previousDateToString() : currentDateString
        let url = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
        let serviceKey = "PMlSyH+ObW0hWwzno2IL0dV7ieP6NaJ9kdG1wVCTBmY+8SisLa9CuYGJjmIcpb5SMuJ3RgfEtTUIyE7QevwZnw=="
        let parameters: Parameters = ["dataType": "JSON",
                                      "base_date": baseDate,
                                      "base_time": baseTime,
                                      "nx": x,
                                      "ny": y,
                                      "serviceKey": serviceKey,
                                      "numOfRows": 254]
        AF.request(url, method: .get, parameters: parameters).validate().responseDecodable(of: WeatherData.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.response.body.items.item))
            case .failure(let error):
                print("Error: MyWeatherView 날씨 데이터 받아오기 실패, \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - MyWeatherView 날씨 데이터 배열에 담기
    func receiveMyWeatherData(addLocationData: [LocationAllData]) {
        let dispatchGroup = DispatchGroup()
        var weatherDataList: [(index: Int16, data: [Item])] = []

        for location in addLocationData {
            dispatchGroup.enter()
            NetworkManager.shared.fetchMyWeatherData(x: location.x, y: location.y) { result in
                switch result {
                case .success(let data):
                    weatherDataList.append((index: location.order, data: data))
                case .failure(let error):
                    print("Error fetching weather data for location \(location): \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            weatherDataList.sort(by: { $0.index < $1.index }) // weatherDataList를 index 기준으로 정렬
            let sortedWeatherDataList = weatherDataList.map { $0.data }
            print("MyWeatherView 날씨 Data 받아오기 완료")
            DataProcessingManager.shared.processingMyWeatherData(items: sortedWeatherDataList, fcstDate: Date())
        }
    }
    
    // MARK: - 오늘 날씨 문장 데이터 받아오기
    func fetchWeatherSentence(sentenceCode: Int16 = ncode, completion: @escaping (Result<[SentenceItem], Error>) -> Void) {
        let url = "http://apis.data.go.kr/1360000/MidFcstInfoService/getMidFcst"
        let serviceKey = "PMlSyH+ObW0hWwzno2IL0dV7ieP6NaJ9kdG1wVCTBmY+8SisLa9CuYGJjmIcpb5SMuJ3RgfEtTUIyE7QevwZnw=="
        let currentDateString = self.getCurrentTmFcString()
        let parameters: Parameters = ["dataType": "JSON",
                                      "stnId": sentenceCode,
                                      "tmFc": currentDateString,
                                      "serviceKey": serviceKey]
        AF.request(url, method: .get, parameters: parameters).validate().responseDecodable(of: WeatherSentenceData.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.response.body.items.item))
            case.failure(let error):
                print("Error: 오늘 날씨 문장 데이터 받아오기 실패, \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 오늘 날씨 문장 데이터 변수에 담기
    func receiveWeatherSentence(sentenceCode: Int16 = ncode) {
        NetworkManager.shared.fetchWeatherSentence(sentenceCode: sentenceCode, completion: { result in
            switch result {
            case .success(let data):
                NetworkManager.weatherSentenceData = data[0].wfSv
            case .failure(let error):
                print(error)
            }
        })
    }
    
    // MARK: - 3일 ~ 7일 날씨 상태 데이터 받아오기
    func fetchWeatherStatus(regID: String = ID, completion: @escaping (Result<[StatusItem], Error>) -> Void) {
        let url = "http://apis.data.go.kr/1360000/MidFcstInfoService/getMidLandFcst"
        let serviceKey = "PMlSyH+ObW0hWwzno2IL0dV7ieP6NaJ9kdG1wVCTBmY+8SisLa9CuYGJjmIcpb5SMuJ3RgfEtTUIyE7QevwZnw=="
        let currentDateString = self.getCurrentTmFcString()
        let parameters: Parameters = ["dataType": "JSON",
                                      "regId": regID,
                                      "tmFc": currentDateString,
                                      "serviceKey": serviceKey]
        AF.request(url, method: .get, parameters: parameters).validate().responseDecodable(of: WeatherStatusData.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.response.body.items.item))
            case.failure(let error):
                print("Error: 중기 날씨 상태 데이터 받아오기 실패, \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 3일 ~ 7일 날씨 상태 데이터 배열에 담기
    func receiveWeatherStatus(regID: String = ID) {
        NetworkManager.shared.fetchWeatherStatus(regID: regID, completion: { result in
            switch result {
            case .success(let data):
                NetworkManager.weatherStatusData = data
            case .failure(let error):
                print(error)
            }
        })
    }
    
    // MARK: - 3일 ~ 7일 날씨 최고, 최저 기온 데이터 받아오기
    func fetchWeatherTemperature(regID: String = regID, completion: @escaping (Result<[TemperatureItem], Error>) -> Void) {
        let url = "http://apis.data.go.kr/1360000/MidFcstInfoService/getMidTa"
        let serviceKey = "PMlSyH+ObW0hWwzno2IL0dV7ieP6NaJ9kdG1wVCTBmY+8SisLa9CuYGJjmIcpb5SMuJ3RgfEtTUIyE7QevwZnw=="
        let currentDateString = self.getCurrentTmFcString()
        let parameters: Parameters = ["dataType": "JSON",
                                      "regId": regID,
                                      "tmFc": currentDateString,
                                      "serviceKey": serviceKey]
        AF.request(url, method: .get, parameters: parameters).validate().responseDecodable(of: WeatherTemperatureData.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.response.body.items.item))
            case.failure(let error):
                print("Error: 중기 날씨 기온 데이터 받아오기 실패, \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 3일 ~ 7일 날씨 최고, 최저 기온 데이터 배열에 담기
    func receiveWeatherTemperature(regID: String = regID) {
        NetworkManager.shared.fetchWeatherTemperature(regID: regID, completion: { result in
            switch result {
            case .success(let data):
                NetworkManager.weatherTemperatureData = data
            case .failure(let error):
                print(error)
            }
        })
    }
    
    // MARK: - 자외선지수 데이터 받아오기
    func fetchUVValue(areaNo: Int64 = areaNo, completion: @escaping (Result<UVItems, Error>) -> Void) {
        let url = "http://apis.data.go.kr/1360000/LivingWthrIdxServiceV4/getUVIdxV4"
        let serviceKey = "PMlSyH+ObW0hWwzno2IL0dV7ieP6NaJ9kdG1wVCTBmY+8SisLa9CuYGJjmIcpb5SMuJ3RgfEtTUIyE7QevwZnw=="
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHH"
        let currentDateString = formatter.string(from: Date())
        let parameters: Parameters = ["dataType": "JSON",
                                      "time": currentDateString,
                                      "areaNo": areaNo,
                                      "serviceKey": serviceKey]
        AF.request(url, method: .get, parameters: parameters).validate().responseDecodable(of: UVData.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.response.body.items))
            case.failure(let error):
                print("Error: 자외선지수 데이터 받아오기 실패, \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 체감온도(여름철) 데이터 받아오기
    func fetchPerceivedTemperature(areaNo: Int64 = areaNo, completion: @escaping (Result<PerceivedTemperatureItems, Error>) -> Void) {
        let url = "http://apis.data.go.kr/1360000/LivingWthrIdxServiceV4/getSenTaIdxV4"
        let serviceKey = "PMlSyH+ObW0hWwzno2IL0dV7ieP6NaJ9kdG1wVCTBmY+8SisLa9CuYGJjmIcpb5SMuJ3RgfEtTUIyE7QevwZnw=="
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHH"
        let currentDateString = formatter.string(from: Date())
        let parameters: Parameters = ["dataType": "JSON",
                                      "time": currentDateString,
                                      "areaNo": areaNo,
                                      "requestCode": "A42",
                                      "serviceKey": serviceKey]
        AF.request(url, method: .get, parameters: parameters).validate().responseDecodable(of: PerceivedTemperatureData.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.response.body.items))
            case.failure(let error):
                print("Error: 체감온도(여름철) 데이터 받아오기 실패, \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 모든 날씨 데이터 받아오기
    func fetchAllWeatherData(x: Int16 = nx, y: Int16 = ny, sentence: Int16 = ncode, status: String = ID, temperature: String = regID, areaNo: Int64 = areaNo) {
        let dispatchGroup = DispatchGroup()
        
        // MARK: - 3일치 날씨 데이터 가공해서 배열에 담기
        dispatchGroup.enter()
        NetworkManager.shared.fetchWeatherData(x: x, y: y, completion: { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let data):
                DataProcessingManager.shared.forecastForDates(items: data, fcstDate: Date())
            case .failure(let error):
                print(error) // 추후에 Alert창 호출로 변경
            }
        })
        
        // MARK: - 3일 ~ 7일 날씨 상태 데이터 배열에 담기
        dispatchGroup.enter()
        NetworkManager.shared.fetchWeatherStatus(regID: status, completion: { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let data):
                NetworkManager.weatherStatusData = data
            case .failure(let error):
                print(error)
            }
        })
        
        // MARK: - 3일 ~ 7일 날씨 최고, 최저 기온 데이터 배열에 담기
        dispatchGroup.enter()
        NetworkManager.shared.fetchWeatherTemperature(regID: temperature, completion: { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let data):
                NetworkManager.weatherTemperatureData = data
            case .failure(let error):
                print(error)
            }
        })
        
        // MARK: - UV 데이터 변수에 담기
        dispatchGroup.enter()
        NetworkManager.shared.fetchUVValue(areaNo: areaNo, completion: { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let data):
                NetworkManager.uvData = data
            case .failure(let error):
                print(error)
            }
        })
        
        // MARK: - 체감온도(여름철) 데이터 변수에 담기
        dispatchGroup.enter()
        NetworkManager.shared.fetchPerceivedTemperature(areaNo: areaNo, completion: { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let data):
                NetworkManager.perceivedTemperatureData = data
            case .failure(let error):
                print(error)
            }
        })
        
        dispatchGroup.notify(queue: .main) {
            DataProcessingManager.shared.weeksTemperatureStatus()
            DataProcessingManager.shared.dayForecast()
            print("모든 날씨 데이터가 성공적으로 받아졌습니다.")
        }
    }
}

extension NetworkManager {
    
    func currentDateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let currentDateString = formatter.string(from: Date())
        
        return currentDateString
    }
    
    func getAfterDate(day: Int) -> Date {
        let today = Date()
        var dateComponents = DateComponents()
        dateComponents.day = day

        if let tomorrow = Calendar.current.date(byAdding: dateComponents, to: today) {
            return tomorrow
        } else {
            return Date()
        }
    }
    
    // 전날 날짜를 문자열로 반환하는 함수
    func previousDateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        return formatter.string(from: yesterday)
    }
    
    // 현재 시각에 맞는 tmFc 문자열을 반환하는 함수
    func getCurrentTmFcString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHH00"
        
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        
        if hour < 6 {
            let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
            formatter.dateFormat = "yyyyMMdd1800"
            return formatter.string(from: yesterday)
        } else if hour < 18 {
            formatter.dateFormat = "yyyyMMdd0600"
            return formatter.string(from: now)
        } else {
            formatter.dateFormat = "yyyyMMdd1800"
            return formatter.string(from: now)
        }
    }
}
