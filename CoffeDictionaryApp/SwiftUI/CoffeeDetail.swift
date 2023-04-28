//
//  CoffeeDetail.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/28.
//

import SwiftUI
import Kingfisher


struct CoffeeDetail: View{
    @Binding var coffee: Coffee
    
    @State private var coffeeImage: Image = Image(systemName: "swift")
    
    @State private var didLoad = false
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View{
        List{
            Section(content: {
                VStack{
                    coffeeImage
                        .frame(width: 200, height: 200, alignment: .center)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.purple, lineWidth: 5))
                    Text("\(coffee.description)")
                }
            }) .onAppear(perform: {
                if didLoad == false {
                    resize()
                    didLoad = true
                }
            })
            Section{
                Button("즐겨찾기에 추가하기", action: {
                    coffee.star = true
                })
            }
            
            Section(content: {
                Button("내용 수정하기", action: {
                    print("Test")
                })
            })
            
            Section(content: {
                Button("위키 백과에서 자세히 보기", action: {
                    NetworkService.shared.wikiRequest(coffee, {
                        print("success -> \($0)")
                    })
                })
            })
            
        }.navigationTitle("\(coffee.title)")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backBtn)
            .navigationBarItems(trailing: starButton)
           
    }
    
    
    func resize(){
        ImageResizeLoader.resizeImage(coffee.image, completion: { resizedImage in
            guard let resizedImage else {return}
            coffeeImage = Image(uiImage: resizedImage)
        })
    }
    
    
    var starButton: some View{
        Button(action: {
            coffee.star?.toggle()
        }, label: {
            let img = coffee.star == true ? Image(systemName: "star.fill") : Image(systemName: "star")
            return img.tint(Color(uiColor: UIColor.systemYellow))
        })
    }
    
    var backBtn : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }) {
        HStack {
            Image(systemName: "chevron.left") // set image here
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color(uiColor: UIColor.label))
        }
    }
    }
}
