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
    
    private init() { initMain() }
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    private func initMain() {
          guard let context = self.persistentContainer?.viewContext else {
              print("Error: Can't access Core Data view context")
              return
          }

          let request = LocationAllData.fetchRequest()
          request.predicate = NSPredicate(format: "region == %@", "서울특별시")

          do {
              let seoulData = try context.fetch(request)
              if seoulData.isEmpty {
                  let seoul = CombinedData(
                      Region: "서울특별시",
                      City: "서울특별시",
                      Town: "",
                      Village: "",
                      X: Int(NetworkManager.nx),
                      Y: Int(NetworkManager.ny),
                      Sentence: Int(NetworkManager.ncode),
                      Status: "11B00000",
                      Temperature: "11B00000"
                  )
                  createCoreData(combinedData: seoul)
                  print("Main - 서울특별시")
              } else {
                  print("서울 데이터가 이미 존재합니다.")
              }
          } catch {
              print("Failed to fetch Seoul data: \(error.localizedDescription)")
          }
      }
    
    
    func createCoreData(combinedData: CombinedData) {    // 코어데이터 저장
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
    
    func updateCoreDataOrder() {
        guard let viewContext = self.persistentContainer?.viewContext else {
            print("Error: Can't access CoreData view context")
            return
        }
        
        for (index, data) in MyWeatherPageTableViewController.array.enumerated() {
            data.order = Int16(index)
        }
        do {
            try viewContext.save()
            print("CoreData order updated successfully")
        } catch {
            print("Failed to update CoreData order: \(error.localizedDescription)")
        }
    }
}
