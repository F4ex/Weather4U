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
}

let cellViewModels = [
        StatusCellViewModel(propertyName: "UV INDEX", iconImage: UIImage(systemName: "sun.max")),
        StatusCellViewModel(propertyName: "WIND", iconImage: UIImage(systemName: "wind")),
        StatusCellViewModel(propertyName: "HUMIDITY", iconImage: UIImage(systemName: "drop"))
    ]

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

let cellViewModel2 = [
    FeelsCellViewModel(PropertyName: "Feels Like", IconImage: UIImage(systemName: "thermometer.high"), Num: "00°", DescriptionLabel: "Apparent Temperature Difference: \(00)°"),
    FeelsCellViewModel(PropertyName: "Mood Forecast", IconImage: UIImage(systemName: "heart.circle"), FaceIcon: UIImage(systemName: "face.smiling"), GradeLabel: "Perfect!")
]
