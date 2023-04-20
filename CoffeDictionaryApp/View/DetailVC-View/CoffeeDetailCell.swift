//
//  CoffeeDetailCell.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/20.
//

import UIKit
import SnapKit
import Kingfisher

class CoffeeDetailCell: UITableViewCell,CellIdentifier{
    
    enum CellType{
        case image
        case label
    }
    
    private lazy var coffee_imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel.fontSetting()
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    convenience init(style: UITableViewCell.CellStyle,
                     reuseIdentifier: String?,
                     type: CellType) {
        self.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    func imageBinder(_ coffee: String?){
        image_layoutConfigure()
        guard let coffee else {return}
        coffee_imageView.kf.setImage(with: URL(string: coffee))
    }
    func textBinder(_ description: String?){
        label_layoutConfigure()
        label.text = description
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
    }
    
    func image_layoutConfigure(){
        contentView.addSubview(coffee_imageView)
        coffee_imageView.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(12)
            $0.height.equalTo(200)
        }
    }
    
    func label_layoutConfigure(){
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}
