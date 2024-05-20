//
//  CoredataManager.swift
//  Weather4U
//
//  Created by t2023-m0056 on 5/20/24.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    static var addLocationData: [LocationAllData] = []
    
    private init() { }
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    func createCoreData(combinedData: CombinedData) {
        guard let context = self.persistentContainer?.viewContext else {
            print("Error: Can't access Core Data view context")
            return
        }

        let newLocation = LocationAllData(context: context)

        newLocation.region = combinedData.Region
        newLocation.city = combinedData.City
        newLocation.town = combinedData.Town
        newLocation.village = combinedData.Village
        newLocation.x = Int16(combinedData.X)
        newLocation.y = Int16(combinedData.Y)
        newLocation.sentence = Int16(combinedData.Sentence)
        newLocation.status = combinedData.Status
        newLocation.temperature = combinedData.Temperature

        do {
            try context.save()
            print("Data saved successfully")
        } catch {
            print("Failed to save data: \(error.localizedDescription)")
        }
    }
    
    func readData() {
        guard let context = self.persistentContainer?.viewContext else {
            print("Error: Can't access Core Data view context")
            return
        }
        
        let request = LocationAllData.fetchRequest()
        
        do {
            let locationAllDatas = try context.fetch(request)
            CoreDataManager.addLocationData = locationAllDatas
        } catch {
            print("Error fetching data from CoreData: \(error.localizedDescription)")
        }
    }
    
    func deleteData(at index: Int) {
        guard let viewContext = self.persistentContainer?.viewContext else {
            print("Error: Can't access Core Data view context")
            return
        }
        
        let request = LocationAllData.fetchRequest()
        
        do {
            let wishListDatas = try viewContext.fetch(request)
            // 인덱스 유효성 검사
            guard wishListDatas.indices.contains(index) else {
                print("Error: Index out of range")
                return
            }
            // 인덱스에 해당하는 데이터 삭제
            let dataToDelete = wishListDatas[index]
            viewContext.delete(dataToDelete)
            
            // 변경 사항 저장
            try viewContext.save()
            print("Data deleted successfully")
        } catch {
            print("Failed to delete data: \(error.localizedDescription)")
        }
    }
}
