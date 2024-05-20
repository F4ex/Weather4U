//
//  JsonParser.swift
//  Weather4U
//
//  Created by t2023-m0056 on 5/14/24.
//

import Foundation

class JSONManager {
    
    static let shared = JSONManager()
    static var locationData: LocationData = []
    
    init() { }
    
    func loadJSONToLocationData() {
        let decoder = JSONDecoder()
        
        guard 
            let weatherSentenceFileLocation = Bundle.main.url(forResource: "weatherSentenceLocationData", withExtension: "json"),
            let weatherStatusFileLocation = Bundle.main.url(forResource: "weatherStatusLocationData", withExtension: "json"),
            let weatherTemperatureFileLocation = Bundle.main.url(forResource: "weatherTemperatureLocationData", withExtension: "json"),
            let weatherFileLocation = Bundle.main.url(forResource: "weatherLocationData", withExtension: "json") else {
            return
        }
        
        do {
            let sentenceData = try Data(contentsOf: weatherSentenceFileLocation)
            let sentenceCode = try decoder.decode(SentenceCode.self, from: sentenceData)
            let statusData = try Data(contentsOf: weatherStatusFileLocation)
            let statusCode = try decoder.decode(StatusCode.self, from: statusData)
            let temperatureData = try Data(contentsOf: weatherTemperatureFileLocation)
            let temperatureCode = try decoder.decode(TemperatureCode.self, from: temperatureData)
            let detailedData = try Data(contentsOf: weatherFileLocation)
            let detailedLocations = try decoder.decode([DetailedLocation].self, from: detailedData)
            
            var combinedDataArray = [CombinedData]()
            
            // detailedLocations 배열을 순회하며 CombinedData 생성
            for location in detailedLocations {
                // 예시로 '서울, 인천, 경기도'에 대한 정보를 매핑
                // 실제로는 location 정보에 따라 다른 값을 할당해야 함
                let combinedData = CombinedData(
                    Region: "\(location.City) \(location.Town) \(location.Village)",
                    City: location.City,
                    Town: location.Town,
                    Village: location.Village,
                    X: location.X,
                    Y: location.Y,
                    Sentence: sentenceCode.filter { location.City.contains($0.key) }.first?.value ?? 108,
                    Status: statusCode.filter { location.City.contains($0.key) }.first?.value ?? "11B00000",
                    Temperature: temperatureCode.filter { location.City.contains($0.key) }.first?.value ?? "11B10101"
                )
                combinedDataArray.append(combinedData)
            }
        } catch {
            print(error)
            return
        }
    }

}
