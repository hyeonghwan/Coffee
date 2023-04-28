//
//  SideMenuDelegate.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/28.
//

import UIKit

protocol SideMenuDelegate: AnyObject {
    func menuButtonTapped()
    func itemSelected(item: ViewControllerPresentation)
    func moveToVC(_ name: String)
}

protocol UIViewControllerSideMenuDelegate{
    var delegate: SideMenuDelegate? { get set }
}

enum ViewControllerPresentation {
    case embed(UIViewControllerSideMenuDelegate)
    case push(UIViewController)
    case modal(UIViewController)
}
