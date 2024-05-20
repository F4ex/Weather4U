//
//  ModalViewController.swift
//  Weather4U
//
//  Created by t2023-m0095 on 5/20/24.
//

import UIKit

class ModalViewController: MainViewController {
    
    let cancelButton = UIButton()
    let addButton = UIButton()


    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureUI() {
        
        [cancelButton, addButton] .forEach {
            view.addSubview($0)
        }
        
        cancelButton.tintColor = .white
        cancelButton.titleLabel?.text = "Cancel"
        cancelButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(tappedCancelButton), for: .touchUpInside)
        
        addButton.tintColor = .white
        addButton.titleLabel?.text = "Add"
        addButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        addButton.setTitleColor(.black, for: .normal)
        addButton.addTarget(self, action: #selector(tappedAddButton), for: .touchUpInside)
    }
    
    
    override func constraintLayout() {
        cancelButton.snp.makeConstraints {
            $0.top.left.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(30)
            $0.width.equalTo(50)
        }
        
        addButton.snp.makeConstraints {
            $0.top.left.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(cancelButton.snp.height)
            $0.width.equalTo(cancelButton.snp.width)
        }
    }
    
    @objc func tappedCancelButton() {
        
    }
    
    @objc func tappedAddButton() {
        
    }

   

}
