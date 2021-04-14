//
//  feed_item.swift
//  Yelm.ProjectX
//
//  Created by Michael Safir on 12.04.2021.
//

import Foundation
import SwiftUI
import Yelm_Server



struct Feed_Item: View {
        
    var body: some View{

        VStack(alignment: .leading, spacing: 10){
            
            ZStack(alignment: .topTrailing){
                Image("feed_2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .cornerRadius(15)
                
                Image(systemName: "arrow.up.backward.and.arrow.down.forward.circle.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 22))
                    .padding(10)
            }
            VStack(alignment: .leading, spacing: 6){
                
                
                HStack(spacing: 0){
                    
                    Image("user")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 25, height: 25)
                        .clipShape(Circle())
                        .padding(.trailing, 5)
                       
                    Text("Михаил Сафир · ")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    
                    Text("20 минут назад")
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.secondary)
                        
                }
                
                Text("Какие фрукты заказывать в апреле?")
                    .font(.system(size: 18, weight: .bold, design: .default))
                    
                
              
            }.padding(.vertical, 5)
            
            Text("В апреле балуем вас экзотикой из жарких стран и потихоньку открываем новый ягодный сезон. Расскажем, откуда нам привозят самые вкусные и спелые фрукты для ваших заказов.")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
            
            HStack{
                
                Button(action: {
                    
                }) {
                    HStack(spacing: 5){
                        Image(systemName: "suit.heart")
                            .font(.system(size: 16))
                            .foregroundColor(.pink)
                        Text("230")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                }
              
                .buttonStyle(PlainButtonStyle())
                
                
                
                Button(action: {
                    
                }) {
                    HStack(spacing: 5){
                        
                        Image(systemName: "repeat")
                            .font(.system(size: 16))
                            .foregroundColor(.green)
                        
                        Text("34")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                       
                    }
                }
              
                .buttonStyle(PlainButtonStyle())
                
                
                Spacer()
                
                
                Button(action: {
                    
                }) {
                    HStack(spacing: 5){
                        Image(systemName: "eye")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                        Text("4601")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                }
              
                .buttonStyle(PlainButtonStyle())
                
            }
        }
    }
       
}
