//
//  ContentView.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/28.
//

import SwiftUI


struct ContentView: View{
    @State private var viewDidLoad = false
    @ObservedObject var observable = NetworkObservable.shared
    
    var body: some View {
        ZStack{
            AngularGradient(gradient: Gradient(colors:[.red,.orange,.yellow,.green,.blue,.purple]), center: .bottom)
                .edgesIgnoringSafeArea(.all)
            TableView(item: $observable.coffeeList)
        }
        .onAppear {
            if viewDidLoad == false {
                viewDidLoad = true
                observable.getAllCoffeeList()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
