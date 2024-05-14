//
//  tableViewCell.swift
//  Weather4U
//
//  Created by 이시안 on 5/14/24.
//

import Foundation
import UIKit

class WeekWeatherCell: UITableViewCell {
    static let identifier = "WeekWeatherCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
