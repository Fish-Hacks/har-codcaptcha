//
//  IrisScanningView.swift
//  CodCaptcha
//
//  Created by Jia Chen Yee on 20/1/24.
//

import SwiftUI

struct IrisScanningView: View {
    
    var onCompletion: ((Bool) -> Void)
    
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
        .task {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 120
            
            let session = URLSession(configuration: configuration)
            
            let url = URL(string: "http://127.0.0.1:5000/eye")!
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.timeoutInterval = 120
            
            print(Date.now)
            do {
                let (data, response) = try await session.data(for: request)
                
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Bool],
                      let succeeded = jsonObject["succeeded"] else { return }
                
                await MainActor.run {
                    onCompletion(succeeded)
                }
                
            } catch {
                print(Date.now)
                print(error.localizedDescription)
            }
            
            print(Date.now)
        }
    }
}
