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
    static var areaNo: String = "1100000000"
    
    
    
    // MARK: - 3일치 날씨 데이터 받아오기
    func fetchWeatherData(x: Int16 = nx, y: Int16 = ny, completion: @escaping (Result<[Item], Error>) -> Void) {
        let currentDateString = self.currentDateToString()
        let url = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
        let serviceKey = "PMlSyH+ObW0hWwzno2IL0dV7ieP6NaJ9kdG1wVCTBmY+8SisLa9CuYGJjmIcpb5SMuJ3RgfEtTUIyE7QevwZnw=="
        let parameters: Parameters = ["dataType": "JSON",
                                      "base_date": currentDateString,
                                      "base_time": "0200",
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
                CategoryManager.shared.forecastForDates(items: data, fcstDate: Date())
            case .failure(let error):
                print(error) // 추후에 Alert창 호출로 변경
            }
        })
    }
    
    // MARK: - 오늘 날씨 문장 데이터 받아오기
    func fetchWeatherSentence(sentenceCode: Int16 = ncode, completion: @escaping (Result<[SentenceItem], Error>) -> Void) {
        let url = "http://apis.data.go.kr/1360000/MidFcstInfoService/getMidFcst"
        let serviceKey = "PMlSyH+ObW0hWwzno2IL0dV7ieP6NaJ9kdG1wVCTBmY+8SisLa9CuYGJjmIcpb5SMuJ3RgfEtTUIyE7QevwZnw=="
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd0600"
        let currentDateString = formatter.string(from: Date())
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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd0600"
        let currentDateString = formatter.string(from: Date())
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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd0600"
        let currentDateString = formatter.string(from: Date())
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
    func fetchUVValue(areaNo: String = areaNo, completion: @escaping (Result<UVItems, Error>) -> Void) {
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
    func fetchPerceivedTemperature(areaNo: String = areaNo, completion: @escaping (Result<PerceivedTemperatureItems, Error>) -> Void) {
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
    func fetchAllWeatherData(x: Int16 = nx, y: Int16 = ny, sentence: Int16 = ncode, status: String = ID, temperature: String = regID, areaNo: String = areaNo) {
        let dispatchGroup = DispatchGroup()
        
        // MARK: - 3일치 날씨 데이터 가공해서 배열에 담기
        dispatchGroup.enter()
        NetworkManager.shared.fetchWeatherData(x: x, y: y, completion: { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let data):
                CategoryManager.shared.forecastForDates(items: data, fcstDate: Date())
            case .failure(let error):
                print(error) // 추후에 Alert창 호출로 변경
            }
        })
        
        // MARK: - 오늘 날씨 문장 데이터 변수에 담기
        dispatchGroup.enter()
        NetworkManager.shared.fetchWeatherSentence(sentenceCode: sentence, completion: { result in
            defer { dispatchGroup.leave() }
            switch result {
            case .success(let data):
                NetworkManager.weatherSentenceData = data[0].wfSv
            case .failure(let error):
                print(error)
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
                print(data.item[0]["h1"])
                NetworkManager.perceivedTemperatureData = data
            case .failure(let error):
                print(error)
            }
        })
        
        dispatchGroup.notify(queue: .main) {
            CategoryManager.shared.weeksTemperatureStatus()
            CategoryManager.shared.dayForecast()
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
}
