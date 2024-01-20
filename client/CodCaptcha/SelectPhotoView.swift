//
//  SelectPhotoView.swift
//  CodCaptcha
//
//  Created by Jia Chen Yee on 20/1/24.
//

import SwiftUI

struct SelectPhotoView: View {
    
    private let classes = ["bus", "car", "mountain", "anime", "rabbits"]
    
    @State private var targetClass: String
    @State private var decoyClasses: [String]
    
    init() {
        let shuffledClasses = classes.shuffled()
        
        _targetClass = State(initialValue: shuffledClasses[0])
        _decoyClasses = State(initialValue: Array(shuffledClasses[1...3]))
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Select all images with a")
                Text(targetClass)
                    .font(.title)
                    .fontWeight(.bold)
                Text("Click verify once there are none left.")
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.blue)
            
            HStack {
                VStack {
                    Rectangle()
                        .aspectRatio(1, contentMode: .fit)
                    Rectangle()
                        .aspectRatio(1, contentMode: .fit)
                    Rectangle()
                        .aspectRatio(1, contentMode: .fit)
                }
                VStack {
                    Rectangle()
                        .aspectRatio(1, contentMode: .fit)
                    Rectangle()
                        .aspectRatio(1, contentMode: .fit)
                    Rectangle()
                        .aspectRatio(1, contentMode: .fit)
                }
                VStack {
                    Rectangle()
                        .aspectRatio(1, contentMode: .fit)
                    Rectangle()
                        .aspectRatio(1, contentMode: .fit)
                    Rectangle()
                        .aspectRatio(1, contentMode: .fit)
                }
            }
        }
        .frame(width: 300)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    SelectPhotoView()
}
