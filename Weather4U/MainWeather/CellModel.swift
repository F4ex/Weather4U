//
//  StatusCellModel.swift
//  Weather4U
//
//  Created by 이시안 on 5/17/24.
//

import UIKit

struct StatusCellViewModel {
    let propertyName: String
    let iconImage: UIImage?
    var num: String
   
}

var cellViewModels: [StatusCellViewModel] = []

func setViewModels() {
    cellViewModels = [StatusCellViewModel(propertyName: "UV INDEX", iconImage: UIImage(systemName: "sun.max"), num: "\(NetworkManager.uvData?.item[0]["h0"] ?? "-") Grade"),
                      StatusCellViewModel(propertyName: "WIND", iconImage: UIImage(systemName: "wind"), num: "\(CategoryManager.shared.getTodayWeatherDataValue(dataKey: .WSD) ?? "-")m/s"),
                      StatusCellViewModel(propertyName: "HUMIDITY", iconImage: UIImage(systemName: "drop"), num: "\(CategoryManager.shared.getTodayWeatherDataValue(dataKey: .REH) ?? "-")%")
    ]
}

struct FeelsCellViewModel {
    var PropertyName: String
    var IconImage: UIImage?
    var FaceIcon: UIImage?
    var Num: String?
    var DescriptionLabel: String?
    var GradeLabel: String?
    
    init(PropertyName: String, IconImage: UIImage? = nil, FaceIcon: UIImage? = nil, Num: String? = nil, DescriptionLabel: String? = nil, GradeLabel: String? = nil) {
        self.PropertyName = PropertyName
        self.IconImage = IconImage
        self.FaceIcon = FaceIcon
        self.Num = Num
        self.DescriptionLabel = DescriptionLabel
        self.GradeLabel = GradeLabel
    }
}

var cellViewModel2: [FeelsCellViewModel] = []
func setViewModels2() {
    cellViewModel2 = [FeelsCellViewModel(PropertyName: "Feels Like", IconImage: UIImage(systemName: "thermometer.high"),
                           Num: "\(NetworkManager.perceivedTemperatureData?.item[0]["h1"] ?? "-")°",
                           DescriptionLabel: "Apparent Temperature Difference: \(CategoryManager.shared.getTodayWeatherDataValue(dataKey: .TMP) ?? "-")°"),
                      FeelsCellViewModel(PropertyName: "Mood Forecast", IconImage: UIImage(systemName: "heart.circle"), 
                                         FaceIcon: UIImage(systemName: "face.smiling"),
                                         GradeLabel: "Perfect!")
    ]
}
