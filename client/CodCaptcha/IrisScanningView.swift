//
//  IrisScanningView.swift
//  CodCaptcha
//
//  Created by Jia Chen Yee on 20/1/24.
//

import SwiftUI

struct IrisScanningView: View {
    
    var onCompletion: (() -> Void)
    
    @State private var irisScannerTop = false
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                Image(systemName: "viewfinder")
                    .font(.system(size: 200))
                Image(systemName: "eye")
                    .font(.system(size: 100))
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(.blue)
                    .frame(width: 300, height: 20)
                    .frame(maxHeight: .infinity, alignment: irisScannerTop ? .top : .bottom)
            }
            .frame(width: 300, height: 200)
            .padding(.bottom)
            
            Text("Scan Your Iris")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("Put your eye to your device's camera to scan your iris.")
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(.linear(duration: 5).repeatForever(autoreverses: true)) {
                irisScannerTop.toggle()
            }
        }
    }
}
