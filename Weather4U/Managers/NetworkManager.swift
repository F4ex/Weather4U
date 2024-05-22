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
    static var weatherStatusData: [StatusItem] = []
    static var weatherTemperatureData: [TemperatureItem]?
    weak var delegate: DataReloadDelegate?
    private init() { }
    
    // 최저 기온 : 예측 시간(fcst_time) - 0600
    // 최고 기온 : 예측 시간(fcst_time) - 1500
    
    static var nx : Int16 = 60
    static var ny : Int16 = 127
    static var ncode : Int16 = 108
    static var ID : String = "11B00000"
    
    
    
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
    func fetchWeatherTemperature(regID: String = ID, completion: @escaping (Result<[TemperatureItem], Error>) -> Void) {
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
    func receiveWeatherTemperature(regID: String = ID) {
        NetworkManager.shared.fetchWeatherTemperature(regID: regID, completion: { result in
            switch result {
            case .success(let data):
                NetworkManager.weatherTemperatureData = data
            case .failure(let error):
                print(error)
            }
        })
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
