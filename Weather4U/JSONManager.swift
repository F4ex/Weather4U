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
    
    private init() { }
    
    func loadJSONToLocationData(fileName: String, extensionType: String) {
        let fileName: String = fileName
        let extensionType = extensionType
        
        guard let fileLocation = Bundle.main.url(forResource: fileName, withExtension: extensionType) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: fileLocation)
            guard let locationData = try? JSONDecoder().decode(LocationData.self, from: data) else {
                return
            }
            
            JSONManager.locationData = locationData
        } catch {
            return
        }
    }

}
