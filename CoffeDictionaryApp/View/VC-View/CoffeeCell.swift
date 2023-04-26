//
//  CoffeeCell.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/20.
//

import UIKit
import SnapKit
import Kingfisher

extension UILabel{
    static func fontSetting(_ default: String = "default") -> UILabel{
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "커피"
        label.textColor = .label
        return label
    }
}

typealias ResizedImage = UIImage

class CoffeeCell: UITableViewCell,CellIdentifier{
    
    private lazy var coffee_name: UILabel = {
        let label = UILabel.fontSetting("커피")
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var translateButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "번역", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)]), for: .normal)
        button.backgroundColor = .systemGray
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(translateButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var coffee_description: UILabel = {
        let label = UILabel.fontSetting("description")
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var coffee_ImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        imageView.tintColor = UIColor.blue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var coffee: Coffee?
    weak var translateBehavior: TranslateBehavior?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
    }
    
    @objc func translateButtonTapped(_ sender: UIButton){
        translateBehavior?.translate(coffee!)
    }
    
    func bind(_ coffee: Coffee,_ delegate: TranslateBehavior ){
        coffee_name.text = coffee.title
        coffee_description.text = coffee.description
        self.coffee = coffee
        self.translateBehavior = delegate
        ImageResizeLoader.resizeImage(coffee.image, completion: { [weak self] resizedImage in
            guard let self else {return}
            self.coffee_ImageView.image = resizedImage
        })
    }
    
    private func layoutConfigure(){
        contentView.addSubview(coffee_name)
        contentView.addSubview(translateButton)
        contentView.addSubview(coffee_description)
        contentView.addSubview(coffee_ImageView)
        
        self.backgroundColor = UIColor.tertiarySystemBackground
        contentView.backgroundColor = UIColor.tertiarySystemBackground
        
        let spacing: CGFloat = 8
        
        coffee_name.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(spacing)
        }
        
        coffee_name.setContentHuggingPriority(.defaultLow, for: .horizontal)
        coffee_name.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        translateButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.top.equalTo(coffee_name.snp.top)
            make.width.equalTo(30)
            make.height.equalTo(25)
            make.leading.equalTo(coffee_name.snp.trailing).offset(-12)
        }
        translateButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        translateButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        coffee_description.snp.makeConstraints { make in
            make.top.equalTo(coffee_name.snp.bottom).offset(spacing)
            make.leading.equalToSuperview().inset(spacing)
            make.trailing.equalTo(coffee_ImageView.snp.leading)
            make.bottom.equalToSuperview().inset(spacing)
        }
        coffee_ImageView.snp.makeConstraints { make in
            make.top.equalTo(translateButton.snp.bottom).offset(spacing)
            make.trailing.equalToSuperview().inset(spacing)
            make.width.height.equalTo(80)
            make.bottom.equalToSuperview().inset(spacing).priority(.high)
        }
    }
    
}


