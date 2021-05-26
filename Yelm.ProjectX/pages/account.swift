//
//  account.swift
//  Yelm.ProjectX
//
//  Created by Michael Safir on 20.05.2021.
//

import Foundation
import SwiftUI
import Combine
import Yelm_Server
import Introspect

struct Account: View {
    
    
    @State var selection: String? = nil
    @ObservedObject var item: items = GlobalItems

    @ObservedObject var bottom: bottom = GlobalBottom
    @ObservedObject var realm: RealmControl = GlobalRealm
    @ObservedObject var search_server : search = GlobalSearch

    @State var nav_bar_hide: Bool = true
    @State var phone: String = ""
    
    @State var sms_code_send: Bool = false
    @State var auth_done: Bool = true
    
    @Environment(\.presentationMode) var presentation
    
    @State var search : String = ""
    @State private var notifications = true
    
    
    var body: some View {
        VStack{
            
            
            VStack(alignment: .leading){
                
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
                        
                        Text("Мой аккаунт")
                            .padding(.top, 10)
                            .font(.system(size: 28, weight: .semibold, design: .rounded))
                         
                        
                       
                        
                        Spacer()
                    }
                
                
                
                if (self.auth_done == false){
                HStack{
                    
                    Spacer()
                    
                    Image(uiImage: Bundle.main.icon!)
                        .resizable()
                        .cornerRadius(15)
                        .frame(width: 75, height: 75)
                        .padding(.vertical, 30)
                        .shadow(color: Color.secondary.opacity(0.4), radius: 6, x: 6, y: 6)
                    
                    Spacer()
                }
                
                if (self.sms_code_send == false){
                
                HStack(){
                    Text("Номер телефона")
                        .font(.system(size: 25, weight: .semibold, design: .rounded))
                    
                    Spacer()
                }
                .padding(.bottom , 5)
                
                
                HStack(){
                    Text("Мы отправим Вам смс код, чтобы подтвердить Ваш аккаунт. После авторизации Вам будут доступны все функции программы лояльности")
                        .foregroundColor(.secondary)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .lineLimit(3)
                        Spacer()
                }
                .frame(height: 60)
                .frame(width: UIScreen.main.bounds.width-30)
                .padding(.bottom , 5)
                
                TextField("Номер телефона", text: $phone)
                    .padding(.vertical, 10)
                    .keyboardType(.phonePad)
                    .foregroundColor(Color.init(hex: "BDBDBD"))
                    .padding(.horizontal, 10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    
                    .padding(.horizontal, 1)
                    .padding(.bottom , 10)
   
                }else{
                    SMS { code, state in
                        print(code)
                    }
                }
                
                Button(action: {
                    if (self.sms_code_send == false){
                        self.sms_code_send = true
                    }else{
                        self.sms_code_send = false
                    }
                    
                }) {
                    
                    
                    HStack{
                        Spacer()
                        Text(self.sms_code_send == false ? "Продолжить" : "Отмена")
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color.theme)
                    .foregroundColor(.theme_foreground)
                    .cornerRadius(10)
                    
                }
                .frame(height: 50)
                .buttonStyle(ScaleButtonStyle())
                .clipShape(CustomShape(corner: .allCorners, radii: 10))
               
                   
                    
                Spacer()
                }else{
                    ScrollView(.vertical, showsIndicators: false){
                        HStack(spacing: 5){
                            ZStack{
                                Circle()
                                    .fill(Color.secondary.opacity(0.2))
                                    .frame(width: 55, height: 55)
                                
                                Text("😍")
                                    .rotationEffect(.init(degrees: 12))
                                    .font(.system(size: 30, weight: .semibold, design: .rounded))
                            }.padding(.trailing)
                            
                            VStack(alignment: .leading, spacing: 5){
                                Text("Михаил")
                                    .font(.system(size: 25, weight: .semibold, design: .rounded))
                                
                                Text("Аккаунт проверен")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    
                            }
                            
                            Spacer()
                            
                            
                            Button(action: {
                              
                                
                            }) {
                                ZStack{
                                    Circle()
                                        .fill(Color.secondary.opacity(0.2))
                                        .frame(width: 35, height: 35)
                                    
                                    Image(systemName: "square.and.pencil")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                        .foregroundColor(.black)
                                }
                            } .buttonStyle(ScaleButtonStyle())
                            
                        }.padding(.vertical, 10)
                        
                        
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: UIScreen.main.bounds.width-40, height: 180)
                            .overlay(
                                ZStack{
                                    AnimatedBackground()
                                        .opacity(0.75)
                                        .cornerRadius(15)
                                    
                                    Blur(style: .extraLight)
                                        .frame(width: UIScreen.main.bounds.width-40, height: 180)
                                        .cornerRadius(15)
                                    
                                    VStack{
                                        HStack{
                                            Text("1500 ₽")
                                                .font(.system(size: 33, weight: .semibold, design: .rounded))
                                            
                                            
                                            Spacer()
                                        }
                                        
                                        Spacer()
                                        
                                        HStack{
                                            
                                            Spacer()
                                            
                                            
                                            Button(action: {
                                              
                                                
                                            }) {
                                                
                                                
                                                ZStack{
                                                    Circle()
                                                        .fill(Color.secondary.opacity(0.2))
                                                        .frame(width: 45, height: 45)
                                                    
                                                    Image(systemName: "qrcode")
                                                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                                                        .foregroundColor(.black)
                                                }
                                            }
                                            .frame(height: 50)
                                            .buttonStyle(ScaleButtonStyle())
                                            .clipShape(CustomShape(corner: .allCorners, radii: 10))
                                            
                                        }
                                    }.padding()
                                }
                            ).padding(.vertical, 10)
                            
                        
                        HStack(){
                            Text("Магазин")
                                .font(.system(size: 25, weight: .semibold, design: .rounded))
                            
                            Spacer()
                        }
                        .padding(.bottom , 10)
                        
                        HStack(){
                            Text("Как потратить бонусы?")
                                .foregroundColor(.secondary)
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.forward")
                                .foregroundColor(.secondary)
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .padding(.trailing, 5)
                        }
                        .padding(.bottom , 8)
                        
                        HStack(){
                            Text("Чат с поддержкой")
                                .foregroundColor(.secondary)
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.forward")
                                .foregroundColor(.secondary)
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .padding(.trailing, 5)
                        }
                        .padding(.bottom , 8)
                        
                        HStack(){
                            Text("Мои заказы")
                                .foregroundColor(.secondary)
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.forward")
                                .foregroundColor(.secondary)
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .padding(.trailing, 5)
                        }
                        .padding(.bottom , 10)
                        
                        
                        HStack(){
                            Text("Настройки")
                                .font(.system(size: 25, weight: .semibold, design: .rounded))
                            
                            Spacer()
                        }
                        .padding(.bottom , 10)
                        
                        
                        HStack(){
                            Text("Уведомления")
                                .foregroundColor(.secondary)
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                            
                            Spacer()
                            
                            Toggle("", isOn: $notifications)
                                .padding(.trailing, 5)
                                
                        }
                        .padding(.bottom , 5)
                        
                        
                        
                        Spacer()
                        
                        Button(action: {
                            
                        }) {
                            
                            
                            HStack{
                                Spacer()
                                Text("Выйти из аккаунта")
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color.secondary.opacity(0.2))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            
                        }
                        .frame(height: 50)
                        .buttonStyle(ScaleButtonStyle())
                        .clipShape(CustomShape(corner: .allCorners, radii: 10))
                    }
                }
            }
            .padding([.trailing, .leading], 20)
            .padding(.bottom, 10)
            .clipShape(CustomShape(corner: [.bottomLeft, .bottomRight], radii: 20))
            .shadow(color: .dropShadow, radius: 15, x: 10, y: 10)
            .shadow(color: .dropLight, radius: 15, x: -10, y: -10)

           
        
            
            
            
            
           
        }
        
        .navigationBarTitle("hidden_layer")
        .navigationBarHidden(self.nav_bar_hide)
        
        .onAppear {
            self.nav_bar_hide = true
            self.bottom.hide = true
        }
        
        .onDisappear{
            if (open_item == false){
                self.bottom.objectWillChange.send()
                self.bottom.hide = false
            }
        }
    }
}

public struct SMS: View {

var maxDigits: Int = 4

@State var pin: String = ""
@State var showPin = true
var handler: (String, (Bool) -> Void) -> Void
public var body: some View {
    VStack {
        
        HStack(){
            Text("Верификация")
                .font(.system(size: 25, weight: .semibold, design: .rounded))
            
            Spacer()
        }
        .padding(.bottom , 5)
        
        
        HStack(){
            Text("Мы отправили Вам смс код, на указанный Вами номер телефона. Введите данный код в поле ввода ниже. Никому не сообщайте данный код.")
                .foregroundColor(.secondary)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .lineLimit(3)
                Spacer()
        }
        .frame(height: 60)
        .frame(width: UIScreen.main.bounds.width-30)
        
        
        ZStack {
            pinDots
            backgroundField
        }.padding(.vertical, 20)
    }
}
private var pinDots: some View {
    HStack {
        Spacer()
        ForEach(0..<maxDigits) { index in
            self.getImageName(at: index)
            Spacer()
        }
    }
}

private func getImageName(at index: Int) -> AnyView {
    if index >= self.pin.count {
        return AnyView(
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.secondary.opacity(0.3))
                .frame(width: 60, height: 60)
        )
    }
    if self.showPin {
        
        return AnyView(
            ZStack{
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.secondary.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Text("\(self.pin.digits[index].numberString)")
                    .foregroundColor(.black)
                    .font(.system(size: 24, weight: .medium, design: .rounded))
            }
        )
        
    }
    
    return AnyView(
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(.secondary.opacity(0.3))
            .frame(width: 60, height: 60)
    )
}

private var backgroundField: some View {
    let boundPin = Binding<String>(get: { self.pin }, set: { newValue in
        self.pin = newValue
        self.submitPin()
    })
    
    return TextField("", text: boundPin, onCommit: submitPin)
        .accentColor(.clear)
        .foregroundColor(.clear)
        .keyboardType(.numberPad)
        .introspectTextField { textField in
            textField.becomeFirstResponder()
        }
}


private var showPinButton: some View {
    Button(action: {
        self.showPin.toggle()
    }, label: {
        self.showPin ?
            Image(systemName: "eye.slash.fill").foregroundColor(.primary) :
            Image(systemName: "eye.fill").foregroundColor(.primary)
    })
}

private func submitPin() {
    if pin.count == maxDigits {
        handler(pin) { isSuccess in
            if isSuccess {
                print("pin matched, go to next page, no action to perfrom here")
            } else {
                pin = ""
                print("this has to called after showing toast why is the failure")
              }
           }
        }
    }
}
extension String {
var digits: [Int] {
    var result = [Int]()
    for char in self {
        if let number = Int(String(char)) {
            result.append(number)
        }
    }
    return result
   }
}

extension Int {

var numberString: String {
    
    guard self < 10 else { return "0" }
    
    return String(self)
   }
}


struct AnimatedBackground: View {
    @State var start = UnitPoint(x: 0, y: -2)
    @State var end = UnitPoint(x: 4, y: 0)
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    let colors = [Color.init(hex: "2ECC71"),
                  Color.init(hex: "27AE60"),
                  Color.init(hex: "16A085"),
                  Color.init(hex: "1ABC9C"),
                  Color.init(hex: "3498DB"),
                  Color.init(hex: "2980B9"),
                  Color.init(hex: "2980B9"),
                  Color.init(hex: "8E44AD"),
                  Color.init(hex: "9B59B6"),
                  Color.init(hex: "E74C3C"),
                  Color.init(hex: "F1C40F"),
                  Color.init(hex: "D35400")]
    
    var body: some View {
        
        LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
            .animation(Animation.easeInOut(duration: 6).repeatForever())
            .onReceive(timer, perform: { _ in
                
                self.start = UnitPoint(x: 4, y: 0)
                self.end = UnitPoint(x: 0, y: 2)
                self.start = UnitPoint(x: -4, y: 20)
                self.start = UnitPoint(x: 4, y: 0)
            })
    }
}
