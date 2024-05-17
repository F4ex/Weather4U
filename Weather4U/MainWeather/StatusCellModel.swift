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
