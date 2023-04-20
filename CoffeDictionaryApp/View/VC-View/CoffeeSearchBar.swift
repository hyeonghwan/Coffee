//
//  CoffeeSearchBar.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/20.
//

import UIKit

class CoffeeSearchBar: UISearchBar{

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    convenience init(frame: CGRect,delegate: UISearchBarDelegate) {
        self.init(frame: frame)
        self.delegate = delegate
        settingView()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
    }
    
    
    private func settingView(){
        self.placeholder = "커피 이름을 입력해주세요"
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.tertiarySystemBackground.cgColor
        self.searchBarStyle = .minimal
    }
}
