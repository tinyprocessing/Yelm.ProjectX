//
//  chat.swift
//  Yelm.ProjectX
//
//  Created by Michael on 10.01.2021.
//

import Foundation
import SwiftUI
import Combine
import Yelm_Chat


struct Chat : View {
    
    @State private var writing: Bool = false
    @State private var text: String = ""
    @ObservedObject var modal : ModalManager = GlobalModular

    
   
    @ObservedObject var chat : ChatIO = YelmChat

    
    @ObservedObject var bottom: bottom = GlobalBottom
    @Environment(\.presentationMode) var presentation
    
    @State var nav_bar_hide: Bool = true
    
    
    
    @available(iOS 14.0, *)
    private func scrollToLastMessage(proxy: ScrollViewProxy) {
        if let lastMessage = self.chat.chat.messages.last { // 4
            withAnimation(.easeOut(duration: 0.1)) {
                proxy.scrollTo(lastMessage.id, anchor: .bottom) // 5
            }
        }
    }
    
    
    
    
    var body: some View {
        
        ZStack{
            
            VStack{
                
                
                VStack{
                    
                    HStack(alignment: .center){
                        Button(action: {
                            
                            self.presentation.wrappedValue.dismiss()
                            let generator = UIImpactFeedbackGenerator(style: .soft)
                            generator.impactOccurred()
                            
                        }) {
                            
                            Image(systemName: "arrow.backward")
                                .foregroundColor(Color.theme_foreground)
                                .frame(width: 15, height: 15, alignment: .center)
                                .padding([.top, .leading, .bottom, .trailing], 10)
                                
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                
                                .background(Color.theme)
                                .clipShape(Circle())
                            
                        }
                        .padding(.top, 10)
                        .padding(.trailing, 10)
                        .buttonStyle(ScaleButtonStyle())
                        
                        VStack(alignment: .leading){
                            Text("Чат")
                                .padding(.top, 10)
                                .font(.system(size: 28, weight: .semibold, design: .rounded))
                            
                            Text(self.chat.core.socket_state == true ? "Онлайн" : "Оффлайн")
                                .foregroundColor(self.chat.core.socket_state == true ? .green : .gray)
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .lineLimit(1)
                            
                        }
                      
                        
                        
                        Spacer()
                        
                        
                        Button(action: {
                            
                        }) {
                            
                            Image(systemName: "gear")
                                .foregroundColor(Color.theme_foreground)
                                .frame(width: 18, height: 18, alignment: .center)
                                .padding(7)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .background(Color.theme)
                                .clipShape(Circle())
                            
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                    
                }
                .padding([.trailing, .leading], 20)
                .padding(.bottom, 10)
                .clipShape(CustomShape(corner: [.bottomLeft, .bottomRight], radii: 20))
                .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
                .shadow(color: .dropLight, radius: 15, x: -10, y: -10)
                
                
                
                
                
                VStack{
                    

                    ScrollView {
                    if #available(iOS 14.0, *) {
                        ScrollViewReader { proxy in // 1
                            
                            ForEach(self.chat.chat.messages, id: \.self) { message in
                                if (message.user.name == UserDefaults.standard.string(forKey: "USER") ?? "user16"){
                                    Message(message: message.text,
                                            user: message.user.name,
                                            time: message.time,
                                            attachment: message.attachments,
                                            alignment: .trailing,
                                            message_color: Color.theme,
                                            message_text_color: .white,
                                            image_asset: message.asset)
                                        .id(message.id) // 2
                                }
                                
                                if (message.user.name == "shop"){
                                    Message(message: message.text,
                                            user: message.user.name,
                                            time: message.time,
                                            attachment: message.attachments,
                                            alignment: .leading,
                                            message_color: Color.init(hex: "F2F3F4"),
                                            message_text_color: .black)
                                        .id(message.id) // 2

                                }
                                
                                if (message.user.name == "server"){
                                    Message(message: message.text,
                                            user: message.user.name,
                                            time: message.time,
                                            attachment: message.attachments,
                                            alignment: .center,
                                            message_color: Color.clear,
                                            message_text_color: .black)
                                        .id(message.id) // 2
    

                                }

                                
                            }
                            
                            
                            .onReceive(Just(self.$writing), perform: { (publisher) in
                                if (self.writing == true){
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        scrollToLastMessage(proxy: proxy)
                                    }
                                }
                            })
                            .onChange(of: self.chat.chat.messages.count) { _ in // 3
                                print("messages add")
                                scrollToLastMessage(proxy: proxy)
                                print(proxy)
                            }
                            
                            
                            
                        }
                    } else {
                        
                        
                        GeometryReader { geometry in


                            ScrollView(.vertical, showsIndicators: false) {



                                ForEach(self.chat.chat.messages.reversed(), id: \.self){ message in

                                    if (message.user.name == UserDefaults.standard.string(forKey: "USER") ?? "user16"){
                                        Message(message: message.text,
                                                user: message.user.name,
                                                time: message.time,
                                                attachment: message.attachments,
                                                alignment: .trailing,
                                                message_color: Color.theme,
                                                message_text_color: .white)
                                            .rotationEffect(.radians(.pi))




                                    }

                                    if (message.user.name == "shop"){
                                        Message(message: message.text,
                                                user: message.user.name,
                                                time: message.time,
                                                attachment: message.attachments,
                                                alignment: .leading,
                                                message_color: Color.init(hex: "F2F3F4"),
                                                message_text_color: .black)
                                            .rotationEffect(.radians(.pi))




                                    }

                                    if (message.user.name == "server"){
                                        Message(message: message.text,
                                                user: message.user.name,
                                                time: message.time,
                                                attachment: message.attachments,
                                                alignment: .center,
                                                message_color: Color.clear,
                                                message_text_color: .black)
                                            .rotationEffect(.radians(.pi))
                                    }
                                }


                            }
                            .background(Color.clear)
                            .rotationEffect(.radians(.pi))
                            .scaleEffect(x: -1, y: 1, anchor: .center)


                        }
                        
                    }
                }.background(Color.clear)
  
                    
                    HStack(alignment: .center){
                        
                        Button(action: {
                            
                            
                         
                            
                            DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
                                self.modal.openModal()
                            }
                            
                        }) {
                            
                            Image(systemName: "plus")
                                .foregroundColor(Color.theme)
                                .padding(10)
                                .font(.system(size: 20, weight: .bold, design: .rounded))

                            
                        }
                        .buttonStyle(ScaleButtonStyle())
                        
                        Spacer(minLength: 10)
                        
                        ChatTextField(label: "Ваше сообщение",
                                      value: $text,
                                      showLabel: false,
                                      keyboardType: .twitter,
                                      onCommit: {
                                        
                                      },
                                      onEditingChanged: { (editing) in
                                        withAnimation {
                                            self.writing = editing
                                        }
                                      },
                                      disableAutocorrection: true)
                            .tag("input_view")
                        
                        Spacer(minLength: 10)
                        
                        Button(action: {
                            
                            let date = Date()
                            let calendar = Calendar.current
                            let hour = calendar.component(.hour, from: date)
                            let minutes = calendar.component(.minute, from: date)
                            
                            let time = "\(hour):\(minutes)"
                            let generator = UIImpactFeedbackGenerator(style: .soft)
                            generator.impactOccurred()
                            let user_cache = UserDefaults.standard.string(forKey: "USER") ?? "user16"
                            var user = chat_user(id: 0, name: user_cache)
                            
                            if (self.chat.chat.messages.count > 0){
                                if (self.chat.chat.messages.last?.user.name == user_cache){
                                    user = chat_user(id: 1, name: "shop")
                                }
                            }
                            
                            self.chat.chat.messages.append(chat_message(id: (self.chat.chat.messages.count+1),
                                                              user: user,
                                                              text: self.text,
                                                              time: time,
                                                              attachments: [:]))
                            
                            self.text = ""
                        }) {
                            
                            Image(systemName: "paperplane")
                                .tag("chat_button")
                                .foregroundColor(Color.white)
                                .frame(width: 15, height: 15, alignment: .center)
                                .padding(10)
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .background(Color.theme)
                                .clipShape(Circle())
                            
                        }
                        .buttonStyle(ScaleButtonStyle())
                        
                        
                    } .padding()
                    
    
                    
                }
                
                
                
                
                
                
            }
            
        }
        
        .navigationBarTitle("hidden_layer")
        .navigationBarHidden(self.nav_bar_hide)
        
        .onAppear {
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.modal.newModal(position: .closed) {
                    ModalImages()
                        .clipped()
                }
            }
            
            self.nav_bar_hide = true
            self.bottom.hide = true
        }
        
        .onDisappear{
            
            self.modal.closeModal()
            
            
            self.bottom.hide = false
        }
    }
    
    
}
