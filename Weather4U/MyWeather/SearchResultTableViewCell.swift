//
//  SearchResultTableViewCell.swift
//  Weather4U
//
//  Created by t2023-m0095 on 5/17/24.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    static let identifier = "SearchResultTableViewCell"
    
    let locationNameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(locationNameLabel)
        locationNameLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        locationNameLabel.textColor = .black
        locationNameLabel.layer.masksToBounds = true
        locationNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(18)
            $0.leading.trailing.equalToSuperview().inset(50)
        }
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
