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
    
    private init() { }
    
    func fetchWeatherData(date: String, time: String, completion: @escaping (Result<Response, Error>) -> Void) {
        let url = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst"
        let serviceKey = "PMlSyH+ObW0hWwzno2IL0dV7ieP6NaJ9kdG1wVCTBmY+8SisLa9CuYGJjmIcpb5SMuJ3RgfEtTUIyE7QevwZnw=="
        let parameters: Parameters = ["dataType": "JSON", "base_date": date, "base_time": time, "nx": 55, "ny": 127, "serviceKey": serviceKey]
        AF.request(url, method: .get, parameters: parameters).validate().responseDecodable(of: WeatherData.self) { response in
            switch response.result {
            case .success(let data):
                print(data.response)
                completion(.success(data.response))
            case .failure(let error):
                print("Error: 데이터 받아오기 실패, \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func executeNetwork(date: String, time: String) {
        NetworkManager.shared.fetchWeatherData(date: date, time: time) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
