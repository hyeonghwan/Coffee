//
//  SearchCell.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/20.
//

import UIKit
import SnapKit


protocol CellIdentifier{
    static var identifier: String { get }
}
extension CellIdentifier{
    static var identifier: String {
        return String(describing: Self.self)
    }
}

class SearchCell: UITableViewCell, CellIdentifier{
    
    private lazy var searchBar: CoffeeSearchBar? = nil
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(style: UITableViewCell.CellStyle,
                     reuseIdentifier: String?,
                     delegate: UISearchBarDelegate) {
        self.init(style: style, reuseIdentifier: reuseIdentifier)
        self.searchBar = CoffeeSearchBar(frame: .zero, delegate: delegate)
        layoutConfigure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
    }
    
    private func layoutConfigure(){
        guard let searchBar else {return}

        contentView.addSubview(searchBar)
        self.backgroundColor = UIColor.tertiarySystemBackground
        self.contentView.backgroundColor = UIColor.tertiarySystemBackground
        
        searchBar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(50).priority(.high)
        }
    }
}
