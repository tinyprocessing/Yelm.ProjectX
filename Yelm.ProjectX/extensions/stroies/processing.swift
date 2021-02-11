//
//  processing.swift
//  Yelm.ProjectX
//
//  Created by Michael on 09.02.2021.
//

import Foundation
import Combine

class timer_story: ObservableObject {
    
    @Published var progress: Double
    @Published public var interval: TimeInterval
    private var max: Int
    private let publisher: Timer.TimerPublisher
    private var cancellable: Cancellable?
    
    @Published var is_pause : Bool = false
    
    init(items: Int, interval: TimeInterval) {
        self.max = items
        self.progress = 0
        self.interval = interval
        self.publisher = Timer.publish(every: 0.1, on: .main, in: .default)
    }
    
    public func pause() {
        self.is_pause = true
    }
    
    public func continue_play() {
        self.is_pause = false
    }
    
    func start() {
        self.cancellable = self.publisher.autoconnect().sink(receiveValue: {  _ in
            if (self.is_pause == false){
                var newProgress = self.progress + (0.1 / self.interval)
                
                if Int(newProgress) >= self.max { newProgress = 0 }
                self.progress = newProgress
                
            }
        })
    }

    func cancel() {
        self.cancellable?.cancel()
    }
    
    func advance(by number: Int) {
       
            let newProgress = Swift.max((Int(self.progress) + number) % self.max , 0)
            self.progress = Double(newProgress)
        
    }
    
}
