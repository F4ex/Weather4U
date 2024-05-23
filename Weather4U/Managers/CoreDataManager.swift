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
    static var addLocationData: [LocationAllData] = []  // 코어데이터가 저장되는 배열
    
    private init() { }
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    func createCoreData(combinedData: CombinedData) {    // 코어데이터 저장
        guard let context = self.persistentContainer?.viewContext else {
            print("Error: Can't access Core Data view context")
            return
        }
        
        let currentCount = self.getCurrentLocationDataCount()
        let newLocation = LocationAllData(context: context)
        
        newLocation.order = Int16(currentCount)
        newLocation.areaNo = Int64(combinedData.AreaNo)
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
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        request.sortDescriptors = [sortDescriptor] // 정렬 조건 설정
        
        do {
            let locationAllDatas = try context.fetch(request)
            CoreDataManager.addLocationData = locationAllDatas
            print(CoreDataManager.addLocationData)
            print(CoreDataManager.addLocationData.count)
        } catch {
            print("Error fetching data from CoreData: \(error.localizedDescription)")
        }
    }
    

    
    func readFirstData() {
        guard let context = self.persistentContainer?.viewContext else {
            print("Error: Can't access Core Data view context")
            return
        }
        
        let request = LocationAllData.fetchRequest()
        
        do {
            let locationAllDatas = try context.fetch(request)
            if let locationData = locationAllDatas.first {
                let firstValue = CombinedData(
                    AreaNo: Int(locationData.areaNo),
                    Region: locationData.region ?? "-",
                    City: locationData.city ?? "-",
                    Town: locationData.town ?? "-",
                    Village: locationData.village ?? "-",
                    X: Int(locationData.x),
                    Y: Int(locationData.y),
                    Sentence: Int(locationData.sentence),
                    Status: locationData.status ?? "-",
                    Temperature: locationData.temperature ?? "-"
                )
                MainViewController.selectRegion = firstValue
            }
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
    

        func moveLocationData(from sourceIndex: Int, to destinationIndex: Int) {
            guard let viewContext = self.persistentContainer?.viewContext else {
                print("Error: Can't access CoreData view context")
                return
            }
            
            let fetchRequest: NSFetchRequest<LocationAllData> = LocationAllData.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            do {
                var locationDatas = try viewContext.fetch(fetchRequest)
                let mover = locationDatas.remove(at: sourceIndex)
                locationDatas.insert(mover, at: destinationIndex)
                
                // Update the order field in LocationAllData objects
                for (index, data) in locationDatas.enumerated() {
                    data.order = Int16(index)
                }
                
                try viewContext.save()
                self.readData() // 변경 값을 업데이트해주어야.
                print("코어데이터 위치 이동 성공")
            } catch {
                print("Failed to move CoreData location data: \(error.localizedDescription)")
            }
        }

    
    func updateCoreDataOrder() {
        guard let viewContext = self.persistentContainer?.viewContext else {
            print("Error: Can't access CoreData view context")
            return
        }
        
        for (index, data) in CoreDataManager.addLocationData.enumerated() {
            data.order = Int16(index)
        }
        do {
            try viewContext.save()
            print("코어데이터 업데이트 성공")
        } catch {
            print("Failed to update CoreData order: \(error.localizedDescription)")
        }
    }
    
    func getCurrentLocationDataCount() -> Int {
            guard let context = self.persistentContainer?.viewContext else {
                print("Error: Can't access Core Data view context")
                return 0
            }

            let fetchRequest: NSFetchRequest<LocationAllData> = LocationAllData.fetchRequest()
            
            do {
                let count = try context.count(for: fetchRequest)
                return count
            } catch {
                print("Failed to fetch count: \(error.localizedDescription)")
                return 0
            }
        }
}
