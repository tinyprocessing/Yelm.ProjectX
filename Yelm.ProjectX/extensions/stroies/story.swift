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


struct story_structure: Identifiable, Hashable  {
    
    public var id : Int = 0
    
    public var type : String = ""
    public var url : String = ""
}


struct story: View {
    
    
    @ObservedObject var timer: timer_story = timer_story(items: 3, interval: 5.0)
    
    @ObservedObject var video : video = GlobalVideo
    @ObservedObject var array : confetti = GlobalConfetti

    
    @ObservedObject var bottom: bottom = GlobalBottom
    @Environment(\.presentationMode) var presentation
    
    @State var nav_bar_hide: Bool = true
    
    @State var objects : [story_structure] = [
        story_structure(id: 0,
                        type: "image",
                        url: "https://images.pexels.com/photos/4264048/pexels-photo-4264048.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"),
        story_structure(id: 1,
                        type: "video",
                        url: "https://s3.eu-north-1.amazonaws.com/yelm.io.2/files/Yelm_Stories.mp4"),
        story_structure(id: 2,
                        type: "image",
                        url: "https://images.pexels.com/photos/5871626/pexels-photo-5871626.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500")]
    
    
    
    @State private var autoReplay: Bool = false
    @State private var mute: Bool = false
    
    @State private var time: CMTime = .zero
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack(alignment: .bottom){
                ZStack(alignment: .top) {
                
                
                if (self.objects[Int(self.timer.progress)].type == "video"){
                    VideoPlayer(url: URL(string: self.objects[Int(self.timer.progress)].url)!, play: self.$video.play, time: $time)
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
                                print(totalDuration)
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
                            self.video.objectWillChange.send()
                            self.video.play = true
                        }
                        .onDisappear {
                            self.timer.interval = 5.0
                            self.timer.continue_play()
                        }
                }
                
                
                if (self.objects[Int(self.timer.progress)].type == "image"){
                    URLImage(URL(string: self.objects[Int(self.timer.progress)].url)!) { proxy in
                        proxy.image
                            .resizable()
                            .edgesIgnoringSafeArea(.all)
                            .scaledToFill()
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
                    ForEach(self.objects.indices) { x in
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
                                self.video.objectWillChange.send()
                                self.video.play = false
                                self.presentation.dismiss()
                            }
                            if value.translation.height < -50 {
                                // up
                                print("up")
                            }
                            
                            if value.translation.height > 50 {
                                // down
                                print("down")
                                self.video.objectWillChange.send()
                                self.video.play = false
                                self.presentation.dismiss()
                            }
                        }))
            
            .navigationBarTitle("hidden_layer")
            .navigationBarHidden(self.nav_bar_hide)
            
            .onAppear {
                
                self.nav_bar_hide = true
                self.bottom.hide = true
                
                
                
                for i in 0...self.objects.count-1{
                    if (self.objects[i].type == "video"){
                        VideoPlayer.preload(urls: [URL(string: self.objects[i].url)!])
                    }
                }
                
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                    self.timer.start()
                }
                
            }
            
            
        }
        
        .onDisappear {
            
            
            self.video.objectWillChange.send()
            self.video.play = false
            
            self.time = CMTimeMake(value: 0, timescale: 1)
            
            
            if (open_item == false){
                self.bottom.objectWillChange.send()
                self.bottom.hide = false
            }
            
            self.timer.cancel()
        }
    }
}
