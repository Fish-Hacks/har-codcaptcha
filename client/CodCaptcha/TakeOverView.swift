//
//  TakeOverView.swift
//  CodCaptcha
//
//  Created by Jia Chen Yee on 20/1/24.
//

import SwiftUI
import Subsonic

struct TakeOverView: View {
    
    @StateObject var validationManager = CAPTCHAValidationManager()
    
    @State private var showBackgroundBlur = false
    @State private var showPopupSheet = false
    
    @State private var fishOffsetX = 1000.0
    @State private var fishOffsetY = 500.0
    
    @StateObject private var sound = SubsonicPlayer(sound: "horrifyingmusic.mov")
    
    @Namespace var namespace
    
    var destroySelf: (() -> Void)
    
    var body: some View {
        ZStack {
            if showBackgroundBlur {
                Rectangle()
                    .fill(.ultraThinMaterial)
            }
            
            Button("kill") {
                NSApplication.shared.terminate(nil)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            
            switch validationManager.validationState {
            case .unverified:
                ZStack {
                    Rectangle()
                        .fill(.background)
                        .clipShape(.rect(cornerRadius: 16))
                    
                    VStack(alignment: .center) {
                        Image(.fish)
                            .resizable()
                            .scaledToFit()
                            .matchedGeometryEffect(id: "fish", in: namespace)
                            .rotationEffect(.degrees(20))
                            .frame(width: 150, height: 100)
                            .offset(x: fishOffsetX, y: fishOffsetY)
                            .scaleEffect(x: -1)
                        
                        Text("CAPTCHA Required")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 8)
                            .multilineTextAlignment(.center)
                        
                        Text("Confirm that you are a human to continue using the internet.")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                        Divider()
                            .padding(.vertical)
                        
                        Spacer()
                        
                        Button("Start Verification") {
                            withAnimation(.easeInOut(duration: 2)) {
                                validationManager.validationState = .verifying
                            }
                        }
                    }
                    .padding()
                }
                .frame(width: 300, height: 400, alignment: .topLeading)
            case .verifying:
                ZStack {
                    if showPopupSheet {
                        VStack(alignment: .leading) {
                            Text("Are you a robot?")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.bottom, 8)
                            
                            Text("**`\(validationManager.numberOfKilobytes) KB`** sent and received")
                                .font(.title3)
                            
                            Text("For every megabyte of data sent or received, you will have to solve a CAPTCHA.")
                                .font(.body)
                            
                            Divider()
                                .padding(.vertical)
                            
                            CaptchaRendererView()
                                .environmentObject(validationManager)
                            
                            Text("\(validationManager.currentChallengeIndex + 1) of \(validationManager.challengeCount)")
                                .contentTransition(.numericText())
                                .monospacedDigit()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .background(.background)
                        .clipShape(.rect(cornerRadius: 16))
                    }
                    
                    Image(.fish)
                        .resizable()
                        .scaledToFit()
                        .matchedGeometryEffect(id: "fish", in: namespace)
                        .rotationEffect(.degrees(20))
                        .frame(width: 150)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .offset(x: 100, y: 0)
                    
                }
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 700, height: 700)
            case .success:
                ZStack {
                    Rectangle()
                        .fill(.background)
                        .clipShape(.rect(cornerRadius: 16))
                    
                    VStack(alignment: .center) {
                        Image(.fish)
                            .resizable()
                            .scaledToFit()
                            .matchedGeometryEffect(id: "fish", in: namespace)
                            .rotationEffect(.degrees(20))
                            .frame(width: 150, height: 100)
                            .offset(x: fishOffsetX, y: fishOffsetY)
                            .scaleEffect(x: -1)
                        
                        Text("Success")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 8)
                            .multilineTextAlignment(.center)
                        
                        Text("You've been successfully verified.")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                        Divider()
                            .padding(.vertical)
                        
                        Spacer()
                        
                        Button("Done") {
                            destroySelf()
                        }
                    }
                    .padding()
                }
                .frame(width: 300, height: 400, alignment: .topLeading)
            }
        }
        .onAppear {
            withAnimation {
                showPopupSheet = true
            }
            withAnimation(.easeOut(duration: 1)) {
                fishOffsetX = 0
                fishOffsetY = 0
            }
            sound.volume = 1000
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                withAnimation(.easeInOut(duration: 1)) {
                    showBackgroundBlur = true
                }
            }
        }
        .onChange(of: validationManager.failedAttempts) { newValue in
            if newValue == 2 {
                sound.play()
            }
        }
    }
}
