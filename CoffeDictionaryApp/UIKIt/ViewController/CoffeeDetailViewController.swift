//
//  CoffeeDetailViewController.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/20.
//

import UIKit
import SnapKit

class CoffeeDetailViewController: UIViewController{

    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.dataSource = self
        table.delegate = self
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 300
        table.sectionHeaderHeight = 30
        table.allowsMultipleSelectionDuringEditing = true
        table.backgroundColor = UIColor.tertiarySystemBackground
        return table
    }()
    
    var coffee: Coffee?
    
    init(_ coffee: Coffee){
        super.init(nibName: nil, bundle: nil)
        self.coffee = coffee
    }
    
    required init?(coder: NSCoder) {
        fatalError("fatal")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutConfigure()
    }
    
    private func layoutConfigure(){
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension CoffeeDetailViewController: UITableViewDelegate{
    
}
extension CoffeeDetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return coffee?.title
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            var cell: CoffeeDetailCell
            if indexPath.row == 0{
                cell = CoffeeDetailCell(style: .default,
                                        reuseIdentifier: CoffeeDetailCell.identifier,
                                        type: .image)
                cell.imageBinder(coffee?.image)
            }else{
                cell = CoffeeDetailCell(style: .default,
                                        reuseIdentifier: CoffeeDetailCell.identifier,
                                        type: .label)
                cell.textBinder(coffee?.description)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}
