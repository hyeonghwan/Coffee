//
//  CoffeeTableView.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/28.
//

import SwiftUI


struct TableView: View{
    @Binding var item: [Coffee]
    @State private var shouldPresentSheet = false
    @State private var searchText = ""
    var body: some View {
        NavigationView{
            VStack{
                SearchBar(text: $searchText)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                List{
                    ForEach($item) { coffee in
                        NavigationLink {
                            CoffeeDetail(coffee: coffee)
                        } label: {
                            if searchText.isEmpty{
                                TableRow(binding: coffee)
                            }else if coffee.wrappedValue.title.contains(searchText){
                                TableRow(binding: coffee)
                            }else if coffee.wrappedValue.description.contains(searchText){
                                TableRow(binding: coffee)
                            }else{
                                
                            }
                        }
                    }.onDelete { indexSet in
                        item.remove(atOffsets: indexSet)
                    }
                }.listStyle(.plain)
                    .navigationTitle(Text("Coffee"))
                    .navigationBarItems(trailing: addButton)
            }
        }.sheet(isPresented: $shouldPresentSheet) {
            print("Sheet dismissed!")
        } content: {
            CoffeeAddPage(item: $item)
        }
    }
    
    var addButton: some View{
        Button(action: {
            shouldPresentSheet.toggle()
        }, label: {
            Image(systemName: "plus")
                .tint(Color(uiColor: UIColor.systemPurple))
        })
    }
}


struct TableRow: View {
    
    @Binding var binding: Coffee
    
    var printCom: (String) -> () = { string in
        print(string)
        
    }

    @State private var coffeImage: Image = Image(systemName: "swift")
    
    @State private var viewDidLoad = false
  
    var body: some View{
        
        VStack(alignment: .leading){
            HStack{
                Text("\(binding.title)")
                    .font(.title)
                    .foregroundColor(Color(uiColor: UIColor.label))
                
                Spacer(minLength: 10)
                Button("번역"){
                    
                    //MARK: - Translate
                    NetworkService.shared.translateRequest(binding,printCom)
                    
                }.buttonStyle(CustomButtonStyle(bgColor: Color(uiColor: UIColor.label),
                                                boarderColor: Color.purple))
            }
            
            HStack(alignment: .top){
                Text("\(binding.description)")
                    .font(.body)
                    .foregroundColor(Color.gray)
                Spacer(minLength: 10)
                coffeImage
                    .foregroundColor(.orange)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100,height: 100)
                    .scaledToFill()
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.purple, lineWidth: 1))
            }
        }.onAppear(perform: {
            if viewDidLoad == false {
                resize()
            }
        })
    }
    
    func resize(){
        ImageResizeLoader.resizeImage(binding.image, completion: { resizedImage in
            guard let resizedImage else {return}
            coffeImage = Image(uiImage: resizedImage)
        })
    }
}

struct CustomButtonStyle: ButtonStyle {
    
    let bgColor: Color
    let boarderColor: Color
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack{
            Spacer()
            configuration.label
                .lineLimit(2).minimumScaleFactor(0.7)
                .padding(.vertical,10)
                .foregroundColor(bgColor)
            Spacer()
        }
        .frame(width: 50, height: 50, alignment: .trailing)
        .padding(.horizontal,5)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(boarderColor, lineWidth: 5)
        )
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
