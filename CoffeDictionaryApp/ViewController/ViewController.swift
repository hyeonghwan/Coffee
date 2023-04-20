//
//  ViewController.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/19.
//

import UIKit
import SnapKit


class ViewController: UIViewController {
    
    private var removeActionFlag: Bool = false
    lazy var model: [Coffee] = [] {
        didSet{
            DispatchQueue.main.async { [weak self] in
                guard let self else {return}
                if self.removeActionFlag{
                    removeActionFlag.toggle()
                    return
                }
                self.tableView.reloadData()
            }
        }
    }
    
    lazy var segmentsControls: MSegmentedControl = {
        let segment = MSegmentedControl( frame: .zero, buttonTitle: ["All","Hot","Ice"])
        segment.delegate = self
        segment.textColor = UIColor.gray
        segment.selectorTextColor = .label
        return segment
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.rowHeight = UITableView.automaticDimension
        table.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        table.register(CoffeeCell.self, forCellReuseIdentifier: CoffeeCell.identifier)
        table.estimatedRowHeight = 100
        table.allowsMultipleSelectionDuringEditing = true
        table.backgroundColor = UIColor.tertiarySystemBackground
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutConfigure()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            NetworkService.shared
                .getAllCoffeeList(completion: {
                    result in
                    switch result {
                    case .success(let success):
                        self.model = success
                    case .failure(let failure):
                        assert(false, "\(#file), \(#function) \(failure)")
                    }
                })
        })
        settingBackgrount()
    }
    
    private func settingBackgrount(){
        tableView.backgroundColor = UIColor.tertiarySystemBackground
        view.backgroundColor = UIColor.tertiarySystemBackground
        
    }
    
    private func layoutConfigure() {
        self.view.addSubview(tableView)
        self.navigationItem.titleView = segmentsControls
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        segmentsControls.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
}

extension ViewController: MSegmentedControlDelegate{
    func segSelectedIndexChange(to index: Int) {
        
    }
}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CoffeeDetailViewController(model[indexPath.row])
        self.present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeActionFlag.toggle()
            model.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        switch indexPath.section{
        case 1:
            return .delete
        default:
            return .none
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
}

extension ViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        default:
            return model.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = SearchCell(style: .default, reuseIdentifier: SearchCell.identifier, delegate: self)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CoffeeCell.identifier, for: indexPath) as! CoffeeCell
            cell.bind(model[indexPath.row])
            return cell
        }
    }
}

extension ViewController: UISearchBarDelegate{
    
}

