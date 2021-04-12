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

        VStack(alignment: .leading, spacing: 15){
            
            Image("feed_1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .cornerRadius(10)
            
            Text("Какие фрукты заказывать в апреле")
            
            Text("В апреле балуем вас экзотикой из жарких стран и потихоньку открываем новый ягодный сезон. Расскажем, откуда нам привозят самые вкусные и спелые фрукты для ваших заказов.")
                .foregroundColor(.secondary)
        }
    }
       
}
