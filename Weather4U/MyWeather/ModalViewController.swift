//
//  ModalViewController.swift
//  Weather4U
//
//  Created by t2023-m0095 on 5/20/24.
//

import CoreData
import UIKit

class ModalViewController: BaseViewController {
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    
    let cancelButton = UIButton()
    let addButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureUI() {
        
        [cancelButton, addButton].forEach {
            view.addSubview($0)
        }
        
        // Cancel Button 설정
        cancelButton.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(tappedCancelButton), for: .touchUpInside)
        cancelButton.layer.cornerRadius = 10
        
        // Add Button 설정
        addButton.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        addButton.setTitle("Add", for: .normal)
        addButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        addButton.setTitleColor(.black, for: .normal)
        addButton.addTarget(self, action: #selector(tappedAddButton), for: .touchUpInside)
        addButton.layer.cornerRadius = 10
        
    }
    
    
    override func constraintLayout() {
        cancelButton.snp.makeConstraints {
            $0.top.left.equalTo(view.safeAreaLayoutGuide).inset(15)
            $0.height.equalTo(50)
            $0.width.equalTo(80)
        }
        
        addButton.snp.makeConstraints {
            $0.top.right.equalTo(view.safeAreaLayoutGuide).inset(15)
            $0.height.equalTo(cancelButton.snp.height)
            $0.width.equalTo(cancelButton.snp.width)
        }
    }
    
    @objc func tappedCancelButton() {
        print("Cancel")
        
        MyWeatherPageTableViewController().tableView.reloadData()
        dismiss(animated: true)
        
    }
    
    @objc func tappedAddButton() {
        print("Add")
        
        //코어데이터에 저장
        guard let context = persistentContainer?.viewContext else { return }
        
//        let addLocation = Book(context: context)
//        addLocation.bookTitle = detailBook?.title
//        addLocation.bookPrice = Int64(detailBook!.salePrice)
//        addLocation.bookAuthor = detailBook?.authors.joined(separator: ", ")
//        addLocation.bookThumbnail = detailBook?.thumbnail
//
//        try? context.save()
//        
//        let request = Book.fetchRequest()
//        _ = try? context.fetch(request)
        
        MyWeatherPageTableViewController().tableView.reloadData()
        
        dismiss(animated: true)
    }
    
    
    
}
