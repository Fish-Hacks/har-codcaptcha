//
//  SpeechToTextView.swift
//  CodCaptcha
//
//  Created by Jia Chen Yee on 21/1/24.
//

import SwiftUI

struct SpeechToTextView: View {
    
    var onCompletion: ((Bool) -> Void)
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Speak")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("Put your eye to your device's camera to scan your iris.")
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 120
            
            let session = URLSession(configuration: configuration)
            
            let url = URL(string: "http://127.0.0.1:5000/iris")!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = """
{
    "text": "i feel that this project should win"
}
""".data(using: .utf8)
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
