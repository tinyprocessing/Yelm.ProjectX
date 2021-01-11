//
//  item.swift
//  Yelm.ProjectX
//
//  Created by Michael on 08.01.2021.
//

import Foundation
import SwiftUI
import Yelm_Server

struct Item : View {
    
    @ObservedObject var bottom: bottom = GlobalBottom
    @ObservedObject var item: items = GlobalItems
    @State var nav_bar_hide: Bool = true
    @State var time = Timer.publish(every: 0.1, on: .current, in: .tracking).autoconnect()
    
    @ObservedObject var realm: RealmControl = GlobalRealm
    

    
    @State private var selectionString: String? = nil
    @State var color = 0
    @State var height = UIScreen.main.bounds.height
    @State var width = UIScreen.main.bounds.width
    
    @Environment(\.presentationMode) var presentation
    
    @State var show : Float = 0.0
    
    
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @State var opacity : Double = 0
    
    var body: some View{
        
        ZStack(alignment: .bottom){
            ZStack(alignment: .top){
                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack{
                            
                            // First Parallax Scroll...
                            
                            GeometryReader{reader in
                                
                                VStack{
                                    
                                    
                                    URLImage(URL(string: self.item.item.thubnail)!) { proxy in
                                        proxy.image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            // default widht...
                                            .frame(width: UIScreen.main.bounds.width+20, height: reader.frame(in: .global).minY > 0 ? CGFloat(Int(reader.frame(in: .global).minY + 245)) : 245)
                                            // adjusting view postion when scrolls...
                                            .offset(y: -reader.frame(in: .global).minY)

                                        
                                        
                                    }
                                    
                                    
                                    
                                }
                            }
                            // setting default height...
                            .frame(height: 200)
                            
                            // List Of Songs...
                            
                            VStack(spacing: 5){
                                
                                
                                if (self.item.item.title.count > 0){
                                    
                                    GeometryReader{g in
                                        VStack{
                                            Text("")
                                        }
                                        .onReceive(self.time) { (_) in
//                                            print(g.frame(in: .global).minY)
                                            
                                            if (g.frame(in: .global).minY < 80){
                                                withAnimation{
                                                    self.show = 1.0
                                                }
                                            }else{
                                                withAnimation{
                                                    self.show = 0.0
                                                }
                                            }
                                        }
                                    } .frame(height: 0)
                                    
                                    HStack {
                                        
                                        
                                        Text(self.item.item.title)
                                            .font(.title)
                                            .fontWeight(.bold)
                                        
                                        
                                        Spacer()
                                        
                                        if (self.item.item.discount_present == "-0%"){
                                            
                                            
                                            HStack(spacing: 2){
                                                Image(systemName: "star.fill")
                                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                                    .foregroundColor(Color.yellow)
                                                
                                                Image(systemName: "star.fill")
                                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                                    .foregroundColor(Color.yellow)
                                                
                                                Image(systemName: "star.fill")
                                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                                    .foregroundColor(Color.yellow)
                                                
                                                Image(systemName: "star.fill")
                                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                                    .foregroundColor(Color.yellow)
                                                
                                                Image(systemName: "star.fill")
                                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                                    .foregroundColor(Color.yellow)
                                                
                                                
                                            }
                                            
                                            
                                        }
                                        
                                        
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.top, 10)
                                    
                                }
                                
                                
                                
                                if (self.item.item.discount_present != "-0%"){
                                    HStack {
                                        Text("%")
                                            .foregroundColor(Color.white)
                                            .frame(width: 20, height: 20, alignment: .center)
                                            .padding([.top, .leading, .bottom, .trailing], 10)
                                            .font(.system(size: 16, weight: .bold, design: .rounded))
                                            .background(Color.green)
                                            .clipShape(Circle())
                                            .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
                                            .shadow(color: .dropLight, radius: 15, x: -10, y: -10)
                                        
                                        
                                        
                                        Text("Скидка \(self.item.item.discount_present)")
                                            .padding(.horizontal, 5)
                                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 2){
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                                .foregroundColor(Color.yellow)
                                            
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                                .foregroundColor(Color.yellow)
                                            
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                                .foregroundColor(Color.yellow)
                                            
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                                .foregroundColor(Color.yellow)
                                            
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                                .foregroundColor(Color.yellow)
                                            
                                            
                                        }
                                        
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.top, 10)
                                    
                                    
                                }
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                ZStack(alignment: .top){
                                    VStack(alignment: .leading){
                                        
                                        if (self.item.item.text.count > 1){
                                            
                                            Text(self.item.item.text)
                                                .foregroundColor(Color.secondary)
                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                                .padding(.horizontal, 20)
                                                .padding(.top, 5)
                                            
                                        }
                                        
                                        
                                        
                                        
                                        if (self.item.item.parameters.count > 0){
                                            
                                            HStack {
                                                
                                                Text("Характеристики")
                                                    .font(.title)
                                                    .fontWeight(.bold)
                                                
                                                Spacer()
                                                
                                                
                                            }
                                            .padding(.horizontal, 20)
                                            .padding(.top, 10)
                                            
                                        }
                                        
                                        
                                        if (self.item.item.parameters.count > 0){
                                            VStack{
                                                
                                                
                                                ForEach(self.item.item.parameters, id: \.self) { parameter in
                                                    HStack{
                                                        Text(parameter.name)
                                                            .padding(.vertical, 5)
                                                        Spacer()
                                                        Text(parameter.value)
                                                            .padding(.vertical, 5)
                                                    }
                                                    Divider()
                                                }
                                                
                                            }
                                            .padding(.horizontal, 20)
                                            .clipped()
                                        }
                                        
                                        Spacer(minLength: self.item.item.text.count > 1 ? 120 : UIScreen.main.bounds.height)
                                        
//                                        NavigationLink(destination: Cart().accentColor(Color("BLWH")), tag: "Cart", selection: $selectionString) {
//                                            EmptyView()
//                                        }.opacity(0)
                                        
                                    }
                                    
                                }
                                
                                
                                
                                
                                
                            }
                            .padding(.vertical)
                            .background(Color.white)
                            
                            .clipShape(CustomShape(corner: [.topLeft, .topRight], radii: 40))

                        } .background(Color.white)
                    }
                    
                }
                
                VStack{
                    
                        HStack(alignment: .center){
                            Button(action: {

                                self.presentation.wrappedValue.dismiss()
                                let generator = UIImpactFeedbackGenerator(style: .soft)
                                generator.impactOccurred()

                            }) {

                                Image(systemName: "arrow.backward")
                                    .foregroundColor(Color.white)
                                    .frame(width: 15, height: 15, alignment: .center)
                                    .padding([.top, .leading, .bottom, .trailing], 10)

                                    .font(.system(size: 15, weight: .bold, design: .rounded))

                                    .background(Color.blue)
                                    .clipShape(Circle())

                            }
                            .padding(.top, 10)
                            .buttonStyle(ScaleButtonStyle())



                            Spacer()

                            if (self.show == 1.0){
                                Text(self.item.item.title)
                                    .padding(.top, 10)
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                            }




                            Spacer()


                            Button(action: {


                                let generator = UIImpactFeedbackGenerator(style: .soft)
                                generator.impactOccurred()

                            }) {

                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(Color.white)
                                    .frame(width: 15, height: 15, alignment: .center)
                                    .padding([.top, .leading, .bottom, .trailing], 10)

                                    .font(.system(size: 15, weight: .bold, design: .rounded))

                                    .background(Color.blue)
                                    .clipShape(Circle())

                            }
                            .padding(.top, 10)

                            .buttonStyle(ScaleButtonStyle())



                        }
                        .padding(.top, (UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!)
                        .padding([.trailing, .leading], 20)
                        .padding(.bottom, 10)
                        .background(self.show == 1.0 ? Color.white : Color.clear)
                }
        
    }
    
            VStack(spacing: 0){
                HStack(spacing: 15){
                    VStack(spacing: 5){
                        Text("\(self.item.item.discount) ₽")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.blue)
                        Text("\(self.item.item.quanity) \(self.item.item.type)")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(.secondary)
                    }


                    Spacer()
                    if (self.realm.get_item_access(ID: self.item.item.id) == false) {

                        Button(action: {



                            if (self.realm.get_item_access(ID: self.item.item.id) == false) {

//
                                self.realm.objectWillChange.send()
                                
                                self.realm.create_item_cart(ID: self.item.item.id, Title: self.item.item.title, Price: self.item.item.price_float, PriceItem: self.item.item.price_float, Count: 1, Thumbnail: self.item.item.thubnail, ItemType: self.item.item.type, Quantity: self.item.item.quanity, CanIncrement: "1", Discount: self.item.item.discount_value)

                                self.realm.get_total_price()
                                self.realm.objectWillChange.send()


                                let generator = UIImpactFeedbackGenerator(style: .soft)
                                generator.impactOccurred()
                            }

                        }) {
                            HStack{
                                Spacer()
                                Text("В корзину")
                                    .font(.system(size: 20, weight: .medium, design: .rounded))
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }.buttonStyle(ScaleButtonStyle())

                    }else{

                        HStack(spacing: 0){

                            if (self.realm.get_item_access(ID: self.item.item.id)){


                                Button(action: {

                                    

                                    self.realm.post_cart(ID: self.item.item.id, method: "decrement")
                                    self.realm.get_total_price()


                                }) {

                                    Rectangle()
                                        .fill(Color.blue)
                                        .frame(width: 20, height: 20)
                                        .overlay(
                                            Image(systemName: "minus")
                                                .font(.system(size: 20, weight: .medium, design: .rounded))
                                                .foregroundColor(.white)
                                        )




                                }

                                .padding(.leading, 8)
                                .padding(.trailing, 5)
                                .buttonStyle(PlainButtonStyle())

                            }


                            Text("\(self.realm.get_items_count(ID: self.item.item.id))")
                                .lineLimit(1)
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .medium, design: .rounded))
                                .padding([.top, .bottom], 7)
                                .background(Color.blue)
                                .fixedSize()
                                .padding(.horizontal, 15)

                            Button(action: {

                                


                                if (self.realm.get_item_access(ID: self.item.item.id) == false) {


                                }else{
                                    self.realm.post_cart(ID: self.item.item.id, method: "increment")
                                    self.realm.get_total_price()
                                }



                            }) {

                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(width: 20, height: 20)
                                    .overlay(
                                        Image(systemName: "plus")
                                            .font(.system(size: 20, weight: .medium, design: .rounded))
                                            .foregroundColor(.white)
                                    )

                            }
                            .padding(.trailing, 8)
                            .padding(.leading, 5)
                            .buttonStyle(PlainButtonStyle())

                        }
                        .background(Color.blue)
                        .cornerRadius(10)





                    }


                }.padding([.trailing, .leading], 20)
            }
            .padding(.bottom, 40)
            .padding(.top, 30)
            .background(Color.white)
            .clipShape(CustomShape(corner: [.topLeft, .topRight], radii: 20))

            .shadow(color: .dropShadow, radius: 15, x: 0, y: 2)
            
            
        }
        
        .navigationBarTitle("hidden_layer")
        .navigationBarHidden(self.nav_bar_hide)
        .edgesIgnoringSafeArea(.top)
        .edgesIgnoringSafeArea(.bottom)
        
        
        .onAppear {
            self.bottom.hide = true
            self.nav_bar_hide = true
        }

        .onDisappear{
            
            if (open_item == false){
                self.bottom.hide = false
            }else{
                open_item = false
            }
        }
    }
    
    
}


