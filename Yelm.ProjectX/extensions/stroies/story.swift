//
//  story.swift
//  Yelm.ProjectX
//
//  Created by Michael on 09.02.2021.
//

import Foundation
import SwiftUI
import VideoPlayer
import CoreMedia
import Yelm_Server


struct story: View {
    
    
    @ObservedObject var timer: timer_story = timer_story(items: GlobalNews.news_single.story.count, interval: 5.0)
    
    @ObservedObject var video : video = GlobalVideo
    @ObservedObject var array : confetti = GlobalConfetti

    
    @ObservedObject var news: news = GlobalNews

    
    @ObservedObject var bottom: bottom = GlobalBottom
    @Environment(\.presentationMode) var presentation
    
    @State var nav_bar_hide: Bool = true
    
    
    @State var disappear : Bool = false
    
    
    
    @State private var autoReplay: Bool = false
    @State private var mute: Bool = false
    
    @State private var time: CMTime = .zero
    
    var body: some View {
        VStack{
            if (self.news.news_single.story.count > 0){
            GeometryReader { geometry in
                
                ZStack(alignment: .bottom){
                    ZStack(alignment: .top) {
                    
                    
                        if (self.news.news_single.story[Int(self.timer.progress)].type == "video"){
                        VideoPlayer(url: URL(string: self.news.news_single.story[Int(self.timer.progress)].url)!, play: self.$video.play, time: $time)
                            .autoReplay(autoReplay)
                            .mute(mute)
                            .onBufferChanged { progress in
                                // Network loading buffer progress changed
                            }
                            .onPlayToEndTime {
                                // Play to the end time.
                            }
                            .onReplay {
                                // Replay after playing to the end.
                            }
                            
                            .onStateChanged { state in
                                switch state {
                                case .loading:
                                    print("loading video")
                                    self.timer.pause()
                                case .playing(let totalDuration):
                                    self.timer.interval = totalDuration
                                    print("playing video")
                                    
                                    self.timer.continue_play()
                                case .error(let error):
                                    self.timer.pause()
                                    print(error)
                                    ShowAlert(title: "Error", message: "Video Play Error")
                                case .paused(playProgress: let playProgress, bufferProgress: let bufferProgress):
                                    break
                                }
                            }
                            
                            .edgesIgnoringSafeArea(.all)
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: nil, alignment: .center)
                            .animation(.none)
                        
                            .onAppear {
                                if (self.disappear == false){
                                    self.video.objectWillChange.send()
                                    self.video.play = true
                                    
                                }
                                
                                
                                print("VIDEO APPEAR")
                            }
                            .onDisappear {
                                self.timer.interval = 5.0
                                self.timer.continue_play()
                            }
                    }
                    
                    
                    if (self.news.news_single.story[Int(self.timer.progress)].type == "image"){
                        URLImage(URL(string: self.news.news_single.story[Int(self.timer.progress)].url)!) { proxy in
                            proxy.image
                                .resizable()
                                .edgesIgnoringSafeArea(.all)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: nil, alignment: .center)
                                .animation(.none)
                            
                                .onAppear {
                                    self.video.objectWillChange.send()
                                    self.video.play = false
                                    
                                    self.timer.interval = 5.0
                                    self.timer.continue_play()
                                }
                            
                                .onDisappear {
                                    self.timer.interval = 5.0
                                    self.timer.pause()
                                }
                                
                        }
                        
                    }
                    HStack(alignment: .center, spacing: 4) {
                        ForEach(self.news.news_single.story.indices) { x in
                            loading_story(progress: min( max( (CGFloat(self.timer.progress) - CGFloat(x)), 0.0) , 1.0) )
                                .frame(width: nil, height: 4, alignment: .leading)
                                .animation(.linear)
                        }
                    }.padding()
                    HStack(alignment: .center, spacing: 0) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.timer.advance(by: -1)
                            }
                        Rectangle()
                            .foregroundColor(.clear)
                            .contentShape(Rectangle())
                            .onTapGesture {
                               
                                self.timer.advance(by: 1)
                            }
                    }
                }
                    
                    HStack{
                        ZStack{
                            Blur(style: .light)
                                .frame(width: UIScreen.main.bounds.width-20, height: 50)
                                .clipShape(CustomShape(corner: .allCorners, radii: 15))
                            
                            HStack{
                                
                                Button(action: {
                                    
                                    self.array.object = "😂"
                                    NotificationCenter.default.post(name: Notification.Name("play_confetti_celebration"), object: Bool.self)
                                }) {
                                    Text("😂")
                                        .font(.system(size: 30))
                                        .frame(maxWidth: .infinity)
                                }
                              
                                .buttonStyle(PlainButtonStyle())
                                
                                
                                Button(action: {
                                    self.array.object = "😍"
                                    NotificationCenter.default.post(name: Notification.Name("play_confetti_celebration"), object: Bool.self)
                                }) {
                                    Text("😍")
                                        .font(.system(size: 30))
                                        .frame(maxWidth: .infinity)
                                }
                              
                                .buttonStyle(PlainButtonStyle())
                                
                                Button(action: {
                                    
                                    self.array.object = "😒"
                                    NotificationCenter.default.post(name: Notification.Name("play_confetti_celebration"), object: Bool.self)
                                    
                                }) {
                                    Text("😒")
                                        
                                        .font(.system(size: 30))
                                        .frame(maxWidth: .infinity)
                                }
                              
                                .buttonStyle(PlainButtonStyle())
                                
                                Button(action: {
                                    
                                    self.array.object = "😡"
                                    NotificationCenter.default.post(name: Notification.Name("play_confetti_celebration"), object: Bool.self)
                                    
                                }) {
                                    Text("😡")
                                        .font(.system(size: 30))
                                        .frame(maxWidth: .infinity)
                                }
                              
                                .buttonStyle(PlainButtonStyle())
                                
                                
                                Button(action: {
                                    self.array.object = "🥶"
                                    NotificationCenter.default.post(name: Notification.Name("play_confetti_celebration"), object: Bool.self)
                                }) {
                                    Text("🥶")
                                        .font(.system(size: 30))
                                        .frame(maxWidth: .infinity)
                                }
                              
                                .buttonStyle(PlainButtonStyle())
                                
                            }
                        }
                               
                    }
                }
                
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onEnded({ value in
                                
                                print(value.translation.height)
                                if value.translation.width < -50 {
                                    // left
                                    print("left")
                                }
                                
                                if value.translation.width > 50 {
                                    // right
                                    print("right")
                                    
                                    self.disappear = true
                                    
                                    self.timer.pause()
                                    self.timer.cancel()
                                    
                                    self.video.objectWillChange.send()
                                    self.video.play = false
                                    
                                    
                                }
                                if value.translation.height < -50 {
                                    // up
                                    print("up")
                                }
                                
                                if value.translation.height > 50 {
                                    // down
                                    print("down")
                                    
                                    self.disappear = true
                                    
                                    self.timer.pause()
                                    self.timer.cancel()
    //
                                    self.video.objectWillChange.send()
                                    self.video.play = false
                                    
                                    
                                    
                                        
    //                                self.presentation.dismiss()
                                }
                            }))
                
                .navigationBarTitle("hidden_layer")
                .navigationBarHidden(self.nav_bar_hide)
                
                .onAppear {
                    
                    
                    
                    
                    self.nav_bar_hide = true
                    self.bottom.hide = true
                    
                    
                    
                    for i in 0...self.news.news_single.story.count-1{
                        if (self.news.news_single.story[i].type == "video"){
                            VideoPlayer.preload(urls: [URL(string: self.news.news_single.story[i].url)!])
                        }
                    }
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                        self.video.objectWillChange.send()
                        self.video.play = true
                        self.timer.start()
                    }
                    
                }
                
                
            }
            }
        }
        
        .onDisappear {
            
            
            
            
            self.video.objectWillChange.send()
            self.video.play = false
//            
//           
//            
            
            if (open_item == false){
                self.bottom.objectWillChange.send()
                self.bottom.hide = false
            }
            
            self.timer.cancel()
        }
    }
}
