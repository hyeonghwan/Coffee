//
//  CoffeeAddPage.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/28.
//

import SwiftUI


struct CoffeeAddPage: View{
    
    @Binding var item: [Coffee]
    
    private let namePlacHolder: String = "커피 이름을 입력해주세요"
    private let descriptionPlaceHolder: String = "커피 상세정보를 입력하세요"
    private let url_placeHolder: String = "https://..."
    
    
    @FocusState var isKeyBoardActive_name: Bool
    @FocusState var isKeyBoardActive_des: Bool
    @FocusState var isKeyBoardActive_deta: Bool
    @FocusState var isKeyBoardActive_img: Bool
    
    
    @State var name: String = ""
    @State var _description: String = ""
    @State var detailurl: String = ""
    @State var image_url: String = ""
    
    
    
    private let spacing: CGFloat = 4
    var body: some View{
        VStack(alignment: .center){
            NavigationView {
                List{
                    Section(content:{
                        nameView
                    },header: {
                        Text("이름")
                    })
                    Section(content:{
                        description
                    },header: {
                        Text("설명")
                    })
                    Section(content:{
                        detailURL
                    },header: {
                        Text("상세정보 웹페이지 URL")
                    })
                    Section(content:{
                        imageURL
                    },header: {
                        Text("이미지 주소")
                    })
                   
                    Spacer()
                }.navigationBarTitle(Text("새로운 Coffee 추가"), displayMode: .large)
                    .toolbar(content: {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("확인") {
                                focusChange()
                            }
                        }
                    })
            }
        }
    }
    
    private func focusChange(){
        print("focus Change")
        if isKeyBoardActive_name == true{
            isKeyBoardActive_name = false
            isKeyBoardActive_des = true
        }else if isKeyBoardActive_des == true{
            isKeyBoardActive_des = false
            isKeyBoardActive_deta = true
        }else if isKeyBoardActive_deta == true{
            isKeyBoardActive_deta = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                isKeyBoardActive_img = true
            })
        }else{
            isKeyBoardActive_img = false
        }
    }
    
    var nameView: some View{
        TextField(text: $name, label: {
            Text(namePlacHolder)
        }).focused($isKeyBoardActive_name)
            .onChange(of: name, perform: {
                print($0)
            }).onSubmit {
                focusChange()
            }
    }
    
    var description: some View {
        TextField(text: $_description, label: {
            Text(descriptionPlaceHolder)
        }).focused($isKeyBoardActive_des)
            .onChange(of: _description, perform: {
                print($0)
            }).onSubmit {
                focusChange()
            }
            
    }
    
    var detailURL: some View{
        TextField(text: $detailurl, label: {
            Text(url_placeHolder)
        }).focused($isKeyBoardActive_deta)
            .onChange(of: detailurl, perform: {
                print($0)
            }).onSubmit {
                focusChange()
            }
    }
    
    var imageURL: some View{
        TextField(text: $image_url, label: {
            Text(url_placeHolder)
        }).focused($isKeyBoardActive_img)
            .onChange(of: image_url, perform: { key in
                print("key|: \(key)")
            }).onSubmit {
                focusChange()
                save()
            }
    }
    
    func save(){
        if image_url.isEmpty || detailurl.isEmpty || _description.isEmpty || name.isEmpty{
            print("비어있거나 잘못된 정보입니다.")
        }else{
            if detailurl.hasPrefix("https://") && image_url.hasPrefix("https://"){
                item.append(Coffee(id: UUID().uuidString,
                                   type_ID: item.count + 1, title: name, description: _description, image: image_url, ingredients: ["원두"]))
            }
        }
    }
    
}



