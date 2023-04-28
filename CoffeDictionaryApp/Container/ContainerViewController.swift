//
//  ContainerViewController.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/28.
//

import UIKit
import SwiftUI

//
//let hostingViewController = UIHostingController(rootView: ContentView())
//
//let viewController = ViewController()
//let navigationController = UINavigationController(rootViewController: viewController)



extension UIViewController: SideMenuDelegate{
    func menuButtonTapped(){
        
    }
    
    func itemSelected(item: ViewControllerPresentation){
        
    }
    
    func moveToVC(_ name: String){
        
    }
}

final class ContainerViewController: UIViewController {
    private var sideMenuViewController: SideMenuViewController!
    private var navigator: UINavigationController!
    private var rootViewController: UIViewControllerSideMenuDelegate! {
        didSet {
            rootViewController.delegate = self
            if let vc = rootViewController as? UIViewController{
                navigator.setViewControllers([vc], animated: false)
            }
        }
    }
    
    convenience init(sideMenuViewController: SideMenuViewController, rootViewController: UIViewController) {
        self.init()
        self.sideMenuViewController = sideMenuViewController
        self.rootViewController = rootViewController as! any UIViewControllerSideMenuDelegate
        self.navigator = UINavigationController(rootViewController: rootViewController)
    }
    
    convenience init(sideMenuViewController: SideMenuViewController, rootViewController: UIHostingController<ContentView>) {
        self.init()
        self.sideMenuViewController = sideMenuViewController
        self.rootViewController = rootViewController as! any UIViewControllerSideMenuDelegate
        self.navigator = UINavigationController(rootViewController: rootViewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        addChildViewControllers()
        configureDelegates()
        configureGestures()
    }
    
    private func configureDelegates() {
        sideMenuViewController.delegate = self
        rootViewController.delegate = self
    }
    
    private func configureGestures() {
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        swipeLeftGesture.direction = .left
        swipeLeftGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeLeftGesture)
        
        let rightSwipeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(swipedRight))
        rightSwipeGesture.cancelsTouchesInView = false
        rightSwipeGesture.edges = .left
        view.addGestureRecognizer(rightSwipeGesture)
    
//        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
//        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func swipedLeft() {
        sideMenuViewController.hide()
//        print("left")
    }
    
    @objc private func swipedRight(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        sideMenuViewController.show()

    }
    
    
    
    func updateRootViewController(_ viewController: UIViewControllerSideMenuDelegate) {
        rootViewController = viewController
    }
    
    private func addChildViewControllers() {
        addChild(navigator)
        view.addSubview(navigator.view)
        navigator.didMove(toParent: self)
        
        addChild(sideMenuViewController)
        view.addSubview(sideMenuViewController.view)
        sideMenuViewController.didMove(toParent: self)
    }
}

extension ContainerViewController: SideMenuDelegate {
    @objc func menuButtonTapped() {
        sideMenuViewController.show()
    }
    
    func moveToVC(_ name: String) {
        guard let item = sideMenuViewController.sideMenuItems.filter({ item in
            item.name == name
        }).first else { return }
        
        itemSelected(item: item.viewController)
    }
    
    func itemSelected(item: ViewControllerPresentation) {
        switch item {
        case let .embed(viewController):
            updateRootViewController(viewController)
            sideMenuViewController.hide()
        case let .push(viewController):
            sideMenuViewController.hide()
            navigator.pushViewController(viewController, animated: true)
        case let .modal(viewController):
            sideMenuViewController.hide()
            navigator.present(viewController, animated: true, completion: nil)
        }
    }
}
