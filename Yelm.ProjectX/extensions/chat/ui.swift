//
//  ui.swift
//  Yelm.ProjectX
//
//  Created by Michael on 10.01.2021.
//

import Foundation
import SwiftUI



struct Message: View {
    @State var message: String
    @State var user: String
    @State var time: String = ""
    @State var attachment: [String: String] = [:]
    @State var alignment: HorizontalAlignment = .leading
    @State var message_color: Color = Color.theme
    @State var message_text_color: Color = Color.white
    
    
    @State private var rect: CGRect = CGRect()
    
    var body: some View {
        
        VStack{
            
            VStack(alignment: self.alignment) {
                HStack {
                    if alignment == .trailing {
                        Spacer()
                    }
                    Text(self.user == "shop" ? "Магазин" : "Вы")
                        .foregroundColor(Color.init(hex: "BDBDBD"))
                        .font(.footnote)
                        .padding(.bottom, 0)
                    
                    if alignment == .leading {
                        Spacer()
                    }
                    
                }
                
                HStack {
                    if alignment == .trailing || alignment == .center {
                        Spacer()
                    }
                    
                    
                    if (self.message.count == 0 && self.attachment.count > 0){
                        
                        VStack(alignment: .leading) {
                            
                            URLImage(URL(string: self.attachment["image"]!)!) { proxy in
                                proxy.image
                                    .resizable()
                                    .frame(width: proxy.size.width, height: proxy.size.height)
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(15)
                                    .contentShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                                    .contextMenu {
                                        Button(action: {
                                            
                                        }) {
                                            Text("Сохранить")
                                            Image(systemName: "square.and.arrow.down")
                                        }
                                    }
                            }
                            
                        }
                    }else{
                        VStack(alignment: .leading) {
                            
                            
                            Text(message)
                                .foregroundColor(message_text_color)
                                .padding(.all, 10)
                                .background(message_color)
                                .cornerRadius(15)
                                .contentShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                                
                                
                                .contextMenu {
                                    Button(action: {
                                        // change country setting
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
                .background(Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 0.5))
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
