//
//  TakeOverView.swift
//  CodCaptcha
//
//  Created by Jia Chen Yee on 20/1/24.
//

import SwiftUI

struct TakeOverView: View {
    
    @State private var showBackgroundBlur = false
    @State private var showPopupSheet = false
    
    @State private var fishOffsetX = 1000.0
    @State private var fishOffsetY = 500.0
    
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
            
            ZStack {
                if showPopupSheet {
                    VStack(alignment: .leading) {
                        Text("Are you a robot?")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("For every megabyte of data sent or received, you will have to solve a CAPTCHA.")
                            .font(.body)
                        
                        Divider()
                            .padding(.vertical)
                        
                        Text("1 of 30")
                        
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .background(.background)
                    .clipShape(.rect(cornerRadius: 16))
                }
                
                Image(.fish)
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(.degrees(20))
                    .frame(width: 150)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .offset(x: fishOffsetX, y: fishOffsetY)
                
            }
            .aspectRatio(1, contentMode: .fit)
            .frame(width: 600, height: 600)
        }
        .onAppear {
            withAnimation {
                showPopupSheet = true
            }
            withAnimation(.easeOut(duration: 1)) {
                fishOffsetX = 100
                fishOffsetY = 0
            } completion: {
                withAnimation(.easeInOut(duration: 1)) {
                    showBackgroundBlur = true
                }
            }
        }
    }
}

#Preview {
    TakeOverView()
}
