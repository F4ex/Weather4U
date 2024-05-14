//
//  NetworkManager.swift
//  Weather4U
//
//  Created by t2023-m0056 on 5/13/24.
//

import Alamofire
import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    static var weatherData: [Item] = []
    
    private init() { }
    
    // 최저 기온 : 페이지 번호 - 5, 예측 시간(fcst_time) - 0600
    // 최고 기온 : 페이지 번호 - 16, 예측 시간(fcst_time) - 1500
    func fetchWeatherData(date: Date, page: Int, completion: @escaping (Result<[Item], Error>) -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let currentDateString = formatter.string(from: date)
        let url = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
        let serviceKey = "PMlSyH+ObW0hWwzno2IL0dV7ieP6NaJ9kdG1wVCTBmY+8SisLa9CuYGJjmIcpb5SMuJ3RgfEtTUIyE7QevwZnw=="
        let parameters: Parameters = ["dataType": "JSON", "base_date": currentDateString, "base_time": "0200", "nx": 55, "ny": 127, "serviceKey": serviceKey, "pageNo": page, "numOfRows": 870]
        AF.request(url, method: .get, parameters: parameters).validate().responseDecodable(of: WeatherData.self) { response in
            switch response.result {
            case .success(let data):
//                print(data.response)
                completion(.success(data.response.body.items.item))
            case .failure(let error):
                print("Error: 데이터 받아오기 실패, \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func executeNetwork(date: Date, page: Int) {
        NetworkManager.shared.fetchWeatherData(date: date, page: page) { result in
            switch result {
            case .success(let data):
                NetworkManager.weatherData.append(contentsOf: data)
                CategoryManager.todayWeatherData = CategoryManager.shared.forecastForDate(items: NetworkManager.weatherData, fcstDate: Date())
                
            case .failure(let error):
                print(error)
            }
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
    
    func currentTimeToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmm"
        let currentTimeString = formatter.string(from: Date())
        
        return currentTimeString
    }
}
