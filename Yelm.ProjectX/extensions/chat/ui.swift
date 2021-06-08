//
//  ui.swift
//  Yelm.ProjectX
//
//  Created by Michael on 10.01.2021.
//

import Foundation
import SwiftUI
import Photos
import Yelm_Server
import UIKit


struct Message: View {
    @State var message: String
    @State var user: String
    @State var time: String = ""
    @State var attachment: [String: String] = [:]
    @State var alignment: HorizontalAlignment = .leading
    @State var message_color: Color = Color.theme
    @State var message_text_color: Color = Color.white
    @State var image: UIImage = UIImage.init()
    @State var image_asset_loaded : Bool = false
    @State var image_asset: PHAsset? = nil
    @State var image_asset_size : CGSize = CGSize(width: 300, height: 300)
    @ObservedObject var item: items = GlobalItems
    @State var selection: Int? = nil
    @State var tag : items_structure = items_structure()
    @ObservedObject var realm: RealmControl = GlobalRealm

    @State var selection_history: String? = nil

    
    
    @State private var rect: CGRect = CGRect()
    
    var body: some View {
        
        VStack{
            
            VStack(alignment: self.alignment) {
                if(self.user == "shop"){
                    HStack {
                        if alignment == .trailing {
                            Spacer()
                        }
                        Text("Магазин")
                            .foregroundColor(Color.init(hex: "BDBDBD"))
                            .font(.footnote)
                            .padding(.bottom, 0)
                        
                        if alignment == .leading {
                            Spacer()
                        }
                        
                    }
                }
                
                HStack {
                    if alignment == .trailing || alignment == .center {
                        Spacer()
                    }
                    
                    
                    if (self.attachment.count > 0){
                        
                        if ((self.attachment["image"]) != nil){
                        VStack(alignment: .leading) {
                            
                            URLImage(URL(string: self.attachment["image"]!)!) { proxy in
                                proxy.image
                                    .resizable()
                                    .frame(width: proxy.size.width, height: proxy.size.height)
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(15)
                                    .addBorder(message_color, width: 2, cornerRadius: 15)
                                    .contentShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                                    .contextMenu {
                                        Button(action: {
                                            UIImageWriteToSavedPhotosAlbum(proxy.uiimage, nil, nil, nil)
                                        }) {
                                            Text("Сохранить")
                                            Image(systemName: "square.and.arrow.down")
                                        }
                                    }
                            }
                            
                        }
                        }
                        
                        if ((self.attachment["data"]) != nil){
                            if (self.attachment["data"] == "PHAsset"){
                                VStack(alignment: .leading) {
                                    
                                    if (self.image_asset_loaded){
                                    Image(uiImage: self.image)
                                        .resizable()
                                        .frame(width: self.image_asset_size.width, height: self.image_asset_size.height)
                                        .aspectRatio(contentMode: .fill)
                                        .cornerRadius(15)
                                        .addBorder(message_color, width: 2, cornerRadius: 15)
                                        .contentShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                                     
                                    }
                                }.onAppear{
                                    
                                    DispatchQueue.global(qos: .utility).async {


                                        let options = PHImageRequestOptions()
                                        options.isSynchronous = true
                                        options.deliveryMode = PHImageRequestOptionsDeliveryMode.opportunistic
                                        options.isNetworkAccessAllowed = true
                                        
                                        manager.requestImage(for: self.image_asset!, targetSize: .init(), contentMode: .aspectFill, options: options) { (image, _) in
                                            let compressed = UIImage(data: image!.jpeg(.lowest)!)

                                            

                                            
                                            let size_aspect = image!.size
                                            
                                            let ratio = size_aspect.width / size_aspect.height;
                                            var new_width = UIScreen.main.bounds.size.width / 1.7;
                                            
                                            if (size_aspect.height > size_aspect.width){
                                                new_width = UIScreen.main.bounds.size.width / 2.4;
                                            }
                                            let new_height = new_width / ratio;

                                            self.image_asset_size = CGSize(width: Int(new_width), height: Int(new_height))
                                            

                                            DispatchQueue.main.async {
                                                self.image = compressed!
                                                self.image_asset_loaded = true
                                            }
                                        }
                                        

                                        
                                    }
                                    
                                }
                            }
                        }
                        
                        if ((self.attachment["item"]) != nil){
                            
                            VStack{
                                NavigationLink(destination: Item(), tag: 4, selection:  $selection){
                                
                                VStack(alignment: .leading, spacing: 0){
                                    
                                    ZStack(alignment: .top){
                                        URLImage(URL(string: self.tag.thubnail)!) { proxy in
                                            proxy.image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 180, height: 180)
                                                .cornerRadius(20)
                                        }
                                        .overlay(
                                            Rectangle()
                                                .fill(Color.black)
                                                .cornerRadius(20)
                                                .opacity( self.realm.get_item_access(ID: tag.id) ? 0.3 : 0)
                                                .overlay(
                                                    
                                                    VStack{
                                                        if (self.realm.get_item_access(ID: tag.id)){
                                                            Text(String(self.realm.get_items_count(ID: tag.id)))
                                                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                                                .foregroundColor(.white)
                                                                .frame(width: 100, height: 50)
                                                            
                                                        }
                                                        
                                                    }
                                                )
                                            
                                            
                                            
                                            
                                            
                                        )
                                        HStack(spacing: 0){
                                            
                                            Spacer()
                                            
                                            HStack{
                                                
                                                if (self.tag.action.contains("1+1")){
                                                    VStack{
                                                        Text("1+1")
                                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                                            .padding(5)
                                                            .padding(.horizontal, 10)
                                                            .foregroundColor(.white)
                                                    }
                                                    .background(Color.orange)
                                                    .cornerRadius(20)
                                                    .padding(.top, 7)
                                                    .padding(.trailing, 5)
                                                }
                                                
                                            }
                                            
                                            HStack{
                                                
                                                if (self.tag.discount_present != "-0%"){
                                                    
                                                    VStack{
                                                        Text("\(self.tag.discount_present)")
                                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                                            .padding(5)
                                                            .padding(.horizontal, 10)
                                                            .foregroundColor(.white)
                                                    }
                                                    .background(Color.green)
                                                    .cornerRadius(20)
                                                    .padding(.top, 7)
                                                    .padding(.trailing, 7)
                                                    
                                                }
                                            }
                                        }
                                        
                                    }
                                    
                                    Text(self.tag.title)
                                        .frame(height: 50)
                                        .font(.system(size: 14, weight: .regular, design: .rounded))
                                        .lineSpacing(2)
                                        .lineLimit(2)
                                        .frame(alignment: .leading)
                                    
                                    HStack{
                                        
                                        HStack(spacing: 0){
                                            
                                            if (self.realm.get_item_access(ID: self.tag.id)){
                                                
                                                
                                                Button(action: {
                                                    
                                                    
                                                    self.realm.post_cart(ID: self.tag.id, method: "decrement")
                                                    
                                                    
                                                }) {
                                                    
                                                    Rectangle()
                                                        .fill(Color.theme)
                                                        .frame(width: 16, height: 30)
                                                        .overlay(
                                                            Image(systemName: "minus")
                                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                                                .foregroundColor(.theme_foreground)
                                                        )
                                                    
                                                    
                                                    
                                                    
                                                }
                                                
                                                .padding(.leading, 8)
                                                .padding(.trailing, 5)
                                                .buttonStyle(PlainButtonStyle())
                                                
                                            }
                                            
                                            if (floor((self.tag.discount as NSString).floatValue) == (self.tag.discount as NSString).floatValue){
                                                
                                                Text("\(String(format:"%.0f", (self.tag.discount as NSString).floatValue) ) \(ServerAPI.settings.symbol)")
                                                    .lineLimit(1)
                                                    .foregroundColor(.theme_foreground)
                                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                                    .padding([.top, .bottom], 7)
                                                    .background(Color.theme)
                                                    .cornerRadius(20)
                                                    .fixedSize()
                                                    .padding(.leading, self.realm.get_item_access(ID: self.tag.id) ? 0 : 12)
                                                
                                            }else{
                                                
                                                Text("\(self.tag.discount) \(ServerAPI.settings.symbol)")
                                                    .lineLimit(1)
                                                    .foregroundColor(.theme_foreground)
                                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                                    .padding([.top, .bottom], 7)
                                                    .background(Color.theme)
                                                    .cornerRadius(20)
                                                    .fixedSize()
                                                    .padding(.leading, self.realm.get_item_access(ID: tag.id) ? 0 : 12)
                                            }
                                            
                                            
                                            Button(action: {
                                                
                                                
                                                
                                                if (self.realm.get_item_access(ID: self.tag.id) == false) {
                                                    
                                                    
                                                    self.realm.objectWillChange.send()
                                                    self.realm.create_item_cart(ID: self.tag.id, Title: self.tag.title, Price: self.tag.price_float, PriceItem: self.tag.price_float, Count: 1, Thumbnail: self.tag.thubnail, ItemType: self.tag.type, Quantity: self.tag.quanity, CanIncrement: "1", Discount: self.tag.discount_value)
                                                    
                                                    
                                                    self.realm.objectWillChange.send()
                                                    
                                                    
                                                    let generator = UIImpactFeedbackGenerator(style: .soft)
                                                    generator.impactOccurred()
                                                    
                                                    logAddToCartEvent(contentData: tag.title,
                                                                      contentId: String(tag.id),
                                                                      contentType: "item",
                                                                      currency: ServerAPI.settings.currency,
                                                                      price: Double(tag.price_float))
                                                    
                                                }else{
                                                    self.realm.post_cart(ID: self.tag.id, method: "increment")
                                                    
                                                    logAddToCartEvent(contentData: tag.title,
                                                                      contentId: String(tag.id),
                                                                      contentType: "item",
                                                                      currency: ServerAPI.settings.currency,
                                                                      price: Double(tag.price_float))
                                                }
                                                
                                                
                                                
                                                
                                            }) {
                                                
                                                Rectangle()
                                                    .fill(Color.theme)
                                                    .frame(width: 16, height: 30)
                                                    .overlay(
                                                        Image(systemName: "plus")
                                                            .font(.system(size: 16, weight: .medium, design: .rounded))
                                                            .foregroundColor(.theme_foreground)
                                                    )
                                                
                                            }
                                            .padding(.trailing, 8)
                                            .padding(.leading, 5)
                                            .buttonStyle(PlainButtonStyle())
                                            
                                        }
                                        .background(Color.theme)
                                        .cornerRadius(20)
                                        
                                        Spacer()
                                        
                                        VStack{
                                            
                                            if (Float(self.tag.discount) != self.tag.price_float){
                                                
                                                if (floor(self.tag.price_float) == self.tag.price_float){
                                                    
                                                    Text("\(String(format:"%.0f", self.tag.price_float)) \(ServerAPI.settings.symbol)")
                                                        .strikethrough()
                                                        .lineLimit(1)
                                                        .foregroundColor(.gray)
                                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                                }else{
                                                    
                                                    Text("\(String(format:"%.2f", self.tag.price_float)) \(ServerAPI.settings.symbol)")
                                                        .strikethrough()
                                                        .lineLimit(1)
                                                        .foregroundColor(.gray)
                                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                                
                                                }
                                              
                                            }
                                            
                                            
                                            
                                            Text("\(self.tag.quanity) \(self.tag.type)")
                                                .lineLimit(1)
                                                .foregroundColor(.gray)
                                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                        }
                                        
                                        
                                        
                                    }
                                    
                                    Spacer()
                                    
                                }
                                
                                .frame(width: 180, height: 245)
                                .padding(.top, 15)
                                .padding(.bottom, 15)
                                
                            }.buttonStyle(ScaleButtonStyle())
                            }
                            
                            .padding()
                            .background(message_color)
                            .cornerRadius(15)
                            .contentShape(RoundedRectangle(cornerRadius: 15, style: .continuous))

                                                
                            .simultaneousGesture(TapGesture().onEnded{
                                ServerAPI.settings.log(action: "open_item_chat", about: "\(tag.id)")
                                open_item = true
                                let item = self.tag
                                self.item.item = item
                            })
                            
                        }
                        
                        if ((self.attachment["order"]) != nil){
                            
                            
                            VStack(alignment: .leading) {
                                NavigationLink(destination: EmptyView(), label: {})
                                
                                VStack{
                                    Text(message)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .foregroundColor(message_text_color)
                                    
                                    NavigationLink(destination: History(id_order: self.attachment["id"]!), tag: "order_\(self.attachment["id"]!)", selection:  $selection_history){
                                        HStack(spacing: 10){
                                            Image(systemName: "map")
                                                .foregroundColor(.black)
                                            Text("Подробности")
                                                .foregroundColor(.black)
                                                
                                        }
                                        .padding(.horizontal, 20)
                                        .padding(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.theme, lineWidth: 2)
                                        )
                                        .padding(.vertical, 5)
                                        
                                    }.buttonStyle(PlainButtonStyle())
                                    .tag("\(self.attachment["id"]!)")
                                    
                                    .simultaneousGesture(TapGesture().onEnded{
                                        ServerAPI.settings.log(action: "open_order_history")
                                        open_item = true
                                        
                                        print(Int(attachment["id"]!) ?? 0)
                                    })
                                       
                                }
                                    .padding(.all, 10)
                                    .background(message_color)
                                    .cornerRadius(15)
                                    .contentShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                                    
                                    
                                
                            }
                            .frame(width: UIScreen.main.bounds.width/1.5)
                            .tag("order_cell_\(self.attachment["id"]!)")
                            
                        }

                    }else{
                        VStack(alignment: .leading) {
                            
                            VStack{
                                Text(message)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .foregroundColor(message_text_color)
                            }
                                .padding(.all, 10)
                                .background(message_color)
                                .cornerRadius(15)
                                .contentShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                                
                                
                                .contextMenu {
                                    Button(action: {
                                        // change country setting
                                        
                                        let pasteboard = UIPasteboard.general
                                        pasteboard.string = message
                                        
                                    }) {
                                        Text("Скопировать")
                                        Image(systemName: "doc.on.clipboard")
                                    }
                                }
                            
                        }
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    if alignment == .leading || alignment == .center {
                        Spacer()
                    }
                }
                
                
                HStack {
                    if alignment == .trailing {
                        Spacer()
                    }
                    Text(time)
                        .foregroundColor(Color.init(hex: "BDBDBD"))
                        .font(.footnote)
                        .padding(0)

                    if alignment == .leading {
                        Spacer()
                    }

                } .padding(.bottom, 5)
//
                
            }.padding(.horizontal)
            
        }
       
        
        
    }
    
}

struct ChatTextField: View {
    @State var label: String
    @Binding var value: String
    @State var showLabel: Bool = true
    @State var keyboardType: UIKeyboardType = .twitter
    @State var onCommit: () -> Void = { }
    @State private var editing: Bool = false
    
    var onEditingChanged: (Bool) -> Void = { _ in }
    @State var disableAutocorrection: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if showLabel {
                Text(label).bold().padding(.top, 20)
            }
            TextField(label, text: $value, onEditingChanged: onEditingChanged, onCommit: onCommit)
                .keyboardType(keyboardType)
                .padding(.all, 10)
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .disableAutocorrection(disableAutocorrection)
            
        }
    }
}


struct AdvancedTextField: UIViewRepresentable {
    @Binding public var isFirstResponder: Bool
    @Binding public var text: String
    
    public var configuration = { (view: UITextField) in }
    
    public init(text: Binding<String>, isFirstResponder: Binding<Bool>, configuration: @escaping (UITextField) -> () = { _ in }) {
        self.configuration = configuration
        self._text = text
        self._isFirstResponder = isFirstResponder
    }
    
    public func makeUIView(context: Context) -> UITextField {
        let view = UITextField()
        view.addTarget(context.coordinator, action: #selector(Coordinator.textViewDidChange), for: .editingChanged)
        view.delegate = context.coordinator
        return view
    }
    
    public func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        switch isFirstResponder {
        case true: uiView.becomeFirstResponder()
        case false: uiView.resignFirstResponder()
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator($text, isFirstResponder: $isFirstResponder)
    }
    
    public class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>
        var isFirstResponder: Binding<Bool>
        
        init(_ text: Binding<String>, isFirstResponder: Binding<Bool>) {
            self.text = text
            self.isFirstResponder = isFirstResponder
        }
        
        @objc public func textViewDidChange(_ textField: UITextField) {
            self.text.wrappedValue = textField.text ?? ""
        }
        
        public func textFieldDidBeginEditing(_ textField: UITextField) {
            self.isFirstResponder.wrappedValue = true
        }
        
        public func textFieldDidEndEditing(_ textField: UITextField) {
            self.isFirstResponder.wrappedValue = false
        }
    }
}

extension View {
     public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
         let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
         return clipShape(roundedRect)
              .overlay(roundedRect.strokeBorder(content, lineWidth: width))
     }
 }
