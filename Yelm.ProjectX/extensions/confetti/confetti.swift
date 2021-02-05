//
//  confetti.swift
//  Yelm.ProjectX
//
//  Created by Michael on 04.02.2021.
//

import Foundation
import SwiftUI
import ConfettiView



struct ConfettiCelebrationView: View {

    @Binding var isShowingConfetti: Bool // true while confetti is displayed
    private var timeLimit: TimeInterval // how long to display confetti
    @State private var timer = Timer.publish(every: 0.0, on: .main, in: .common).autoconnect()

    init(isShowingConfetti: Binding<Bool>, timeLimit: TimeInterval = 4.0) {
        self.timeLimit = timeLimit
        _isShowingConfetti = isShowingConfetti
    }

    var body: some View {

        // define confetti cell elements & fadeout transition
        let confetti = ConfettiView( confetti: [
            .text("💖"),
            .text("🧡"),
            .text("💜"),
            .text("💓")
        ]).transition(.slowFadeOut)
        

        return ZStack {
            // show either confetti or nothing
            if isShowingConfetti { confetti } else { EmptyView() }
        }.onReceive(timer) { time in
            // timer beat is one interval then quit the confetti
            self.timer.upstream.connect().cancel()
            self.isShowingConfetti = false
        }.onReceive(NotificationCenter.default.publisher(for: Notification.Name.playConfettiCelebration)) { _ in
            // got notification so do --> reset & play
            self.resetTimerAndPlay()
        }
    }

    // reset the timer and turn on confetti
    private func resetTimerAndPlay() {
        timer = Timer.publish(every: self.timeLimit, on: .main, in: .common).autoconnect()
        isShowingConfetti = true
    }

}

// notification to start timer & display the confetti celebration view
public extension Notification.Name {
    static let playConfettiCelebration = Notification.Name("play_confetti_celebration")
}

// fade in & out transitions for ConfettiView and Play button
extension AnyTransition {
    static var slowFadeOut: AnyTransition {
        let insertion = AnyTransition.opacity
        let removal = AnyTransition.opacity.animation(.easeOut(duration: 1.5))
        return .asymmetric(insertion: insertion, removal: removal)
    }

    static var slowFadeIn: AnyTransition {
        let insertion = AnyTransition.opacity.animation(.easeIn(duration: 1.5))
        let removal = AnyTransition.opacity
        return .asymmetric(insertion: insertion, removal: removal)
    }
}
