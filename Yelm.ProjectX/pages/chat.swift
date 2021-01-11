//
//  chat.swift
//  Yelm.ProjectX
//
//  Created by Michael on 10.01.2021.
//

import Foundation
import SwiftUI
import Combine

//"image" : "https://smart-questions.ru/wp-content/uploads/2016/11/ubjWmePYKD4.jpg"
//https://images.pexels.com/photos/1407346/pexels-photo-1407346.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940

struct Chat : View {
    
    @State private var writing: Bool = false
    @State private var text: String = ""
    
    
    @State private var messages : [chat_message] = [
        chat_message(id: 0, user: chat_user(id: 0, name: "user16", online: ""), text: "Добрый день, подскажите пожалуйста есть ли сыр в продаже головками?", time: "12:00", attachments: [:]),
        chat_message(id: 1, user: chat_user(id: 1, name: "shop", online: ""), text: "Да, конечно!", time: "12:01", attachments: [:]),
        chat_message(id: 3, user: chat_user(id: 1, name: "shop", online: ""), text: "", time: "12:04",
                     attachments: ["image" : "https://avatars.mds.yandex.net/get-eda/3682162/00c405007ab3e1be279544a8eabd0673/1200x1200"])]
    
    @ObservedObject var chat: chat = GlobalChat
    @ObservedObject var bottom: bottom = GlobalBottom
    @Environment(\.presentationMode) var presentation
    
    @State var nav_bar_hide: Bool = true
    
    
    
    @available(iOS 14.0, *)
    private func scrollToLastMessage(proxy: ScrollViewProxy) {
        if let lastMessage = self.messages.last { // 4
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
                                .foregroundColor(Color.white)
                                .frame(width: 15, height: 15, alignment: .center)
                                .padding([.top, .leading, .bottom, .trailing], 10)
                                
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                
                                .background(Color.blue)
                                .clipShape(Circle())
                            
                        }
                        .padding(.top, 10)
                        .padding(.trailing, 10)
                        .buttonStyle(ScaleButtonStyle())
                        
                        Text("Чат")
                            .padding(.top, 10)
                            .font(.system(size: 28, weight: .semibold, design: .rounded))
                        
                        
                        Spacer()
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
                                
                                ForEach(self.messages) { message in
                                    if (message.user.name == UserDefaults.standard.string(forKey: "USER") ?? "user16"){
                                        Message(message: message.text,
                                                user: message.user.name,
                                                time: message.time,
                                                attachment: message.attachments,
                                                alignment: .trailing,
                                                message_color: Color.theme,
                                                message_text_color: .white)
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
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        scrollToLastMessage(proxy: proxy)
                                    }
                                })
                                .onChange(of: self.messages.count) { _ in // 3
                                    scrollToLastMessage(proxy: proxy)
                                    print(proxy)
                                }
                                
                                
                                
                            }
                        } else {
                           
                            
                            GeometryReader { geometry in


                                ScrollView(.vertical, showsIndicators: false) {



                                    ForEach(self.messages.reversed(), id: \.self){ message in

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
                    }
                    
            
                    
                    
                    HStack(alignment: .center){
                        
                        Button(action: {
                            
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
                            var user = chat_user(id: 0, name: user_cache, online: "yes")
                            
                            if (self.messages.count > 0){
                                if (self.messages.last?.user.name == user_cache){
                                    user = chat_user(id: 1, name: "shop", online: "yes")
                                }
                            }
                            
                            self.messages.append(chat_message(id: (self.messages.count+1),
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
        
        .onAppear {
            self.nav_bar_hide = true
            self.bottom.hide = true
        }
        
        .onDisappear{
            self.bottom.hide = false
        }
    }
    
    
}
