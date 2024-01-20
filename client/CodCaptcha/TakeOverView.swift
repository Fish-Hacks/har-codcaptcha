//
//  TakeOverView.swift
//  CodCaptcha
//
//  Created by Jia Chen Yee on 20/1/24.
//

import SwiftUI
import Subsonic

struct TakeOverView: View {
    
    var size: Int
    
    @StateObject var validationManager = CAPTCHAValidationManager()
    
    @State private var showBackgroundBlur = false
    @State private var showPopupSheet = false
    
    @State private var fishOffsetX = 1000.0
    @State private var fishOffsetY = 500.0
    
    @State private var showFinishSheet = true
    
    @StateObject private var sound = SubsonicPlayer(sound: "horrifyingmusic.mov")
    
    @Namespace var namespace
    
    var destroySelf: (() -> Void)
    
    @State private var isDeveloperMenuPresented = false
    
    var body: some View {
        ZStack {
            if showBackgroundBlur {
                Rectangle()
                    .fill(.ultraThinMaterial)
            }
            
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
                            
                            Text("For every 10 kilobytes of data sent or received, you will have to solve a CAPTCHA.")
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
                            withAnimation(.easeInOut(duration: 1)) {
                                showFinishSheet.toggle()
                            }
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                                destroySelf()
                            }
                        }
                        .padding()
                    }
                }
                .frame(width: 300, height: 400, alignment: .topLeading)
                .opacity(showFinishSheet ? 1 : 0)
            }
            
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text("\(Image(systemName: "hammer.fill")) Developer Menu")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 8)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Button {
                        withAnimation {
                            isDeveloperMenuPresented = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                Divider()
                    .padding(.vertical)
                
                Text("Switch CAPTCHA")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                
                ForEach(CAPTCHAType.allCases, id: \.hashValue) { value in
                    Button {
                        withAnimation {
                            isDeveloperMenuPresented = false
                            validationManager.currentCaptcha = value
                        }
                    } label: {
                        Text(value.description)
                    }
                }
                
                Text("Quit App")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                
                Button("Quit Now") {
                    NSApplication.shared.terminate(nil)
                }
            }
            .padding()
            .frame(width: 400, alignment: .topLeading)
            .background(.background)
            .clipShape(.rect(cornerRadius: 16))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black.opacity(0.3))
            .opacity(isDeveloperMenuPresented ? 1 : 0)
            .allowsHitTesting(isDeveloperMenuPresented)
            
            Button {
                withAnimation {
                    isDeveloperMenuPresented = true
                }
            } label: {
                Image(systemName: "hammer.fill")
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .keyboardShortcut(KeyEquivalent("d"), modifiers: .command)
        }
        .onAppear {
            validationManager.numberOfKilobytes = size
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
