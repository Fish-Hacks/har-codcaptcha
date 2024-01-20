//
//  WaldoView.swift
//  CodCaptcha
//
//  Created by Jia Chen Yee on 20/1/24.
//

import SwiftUI

struct WaldoView: View {
    
    var onCompletion: ((Bool) -> Void)
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Select all images with")
                Text("Waldo")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.blue)
            
            ZStack {
                Image(.waldo)
                    .resizable()
                    .scaledToFit()
                
                HStack(spacing: 0) {
                    ForEach(0..<4, id: \.self) { x in
                        VStack(spacing: 0) {
                            ForEach(0..<4, id: \.self) { y in
                                Button {
                                    onCompletion(x == 0 && y == 1)
                                } label: {
                                    Rectangle()
                                        .stroke(.background, lineWidth: 4)
                                        .background(.black.opacity(0.001))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .aspectRatio(1, contentMode: .fit)
            }
            
            Spacer()
        }
        .frame(width: 350)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
