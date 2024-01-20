//
//  SelectPhotoView.swift
//  CodCaptcha
//
//  Created by Jia Chen Yee on 20/1/24.
//

import SwiftUI

struct SelectPhotoView: View {
    
    private let targetClass: String
    
    private let targetClassImageURLs: [URL]
    private let decoyClassImageURLs: [URL]
    
    var onCompletion: ((Bool) -> Void)
    
    @State private var targetSquareCoordinates: [CAPTCHACoordinate]
    
    @State private var displayedImageURLs: [[URL]]
    
    init(onCompletion: @escaping ((Bool) -> Void)) {
        let imageDirectory = Bundle.main.url(forResource: "images", withExtension: "")!
        
        let classURLs = try! FileManager.default.contentsOfDirectory(at: imageDirectory, includingPropertiesForKeys: nil)
        
        let shuffledClassURLs = classURLs.shuffled()
        
        let targetClassURL = shuffledClassURLs[0]
        targetClass = targetClassURL.lastPathComponent
        
        let decoyClassURLs = Array(shuffledClassURLs[1...3])
        
        targetClassImageURLs = try! FileManager.default.contentsOfDirectory(at: targetClassURL,
                                                                            includingPropertiesForKeys: nil).shuffled()
        
        decoyClassImageURLs = decoyClassURLs.flatMap { url in
            try! FileManager.default.contentsOfDirectory(at: url,
                                                         includingPropertiesForKeys: nil)
        }.shuffled()
        
        self.onCompletion = onCompletion
        
        var targetSquareCoordinates: [CAPTCHACoordinate] = []
        
        var count = 0
        
        var displayedImageURLs = [
            Array(decoyClassImageURLs[0..<3]),
            Array(decoyClassImageURLs[3..<6]),
            Array(decoyClassImageURLs[6..<9]),
        ]
        
        for x in 0..<3 {
            for y in 0..<3 where .random() && count < 4 {
                targetSquareCoordinates.append(CAPTCHACoordinate(x: UInt8(x), y: UInt8(y)))
                displayedImageURLs[x][y] = targetClassImageURLs[count]
                
                count += 1
            }
        }
        
        _targetSquareCoordinates = State(initialValue: targetSquareCoordinates)
        _displayedImageURLs = State(initialValue: displayedImageURLs)
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
                ForEach(0..<3, id: \.self) { x in
                    VStack {
                        ForEach(0..<3, id: \.self) { y in
                            let coordinate = CAPTCHACoordinate(x: UInt8(x), y: UInt8(y))
                            
                            CAPTCHAImageButton(targetSquareCoordinates: $targetSquareCoordinates,
                                               location: coordinate,
                                               url: displayedImageURLs[x][y]) {
                                guard let index = targetSquareCoordinates.firstIndex(of: coordinate) else { return }
                                
                                if [true, false, false].randomElement()! {
                                    var newImageURL = targetClassImageURLs.randomElement()!
                                    
                                    while newImageURL == displayedImageURLs[x][y] {
                                        newImageURL = targetClassImageURLs.randomElement()!
                                    }
                                    
                                    displayedImageURLs[x][y] = targetClassImageURLs.randomElement()!
                                } else {
                                    targetSquareCoordinates.remove(at: index)
                                    displayedImageURLs[x][y] = decoyClassImageURLs.randomElement()!
                                }
                            } onFailure: {
                                onCompletion(false)
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
            Button {
                onCompletion(targetSquareCoordinates.isEmpty)
            } label: {
                Text("VERIFY")
                    .padding()
                    .padding(.horizontal, 4)
                    .background(.blue)
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(width: 300)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct CAPTCHAImageButton: View {
    
    @Binding var targetSquareCoordinates: [CAPTCHACoordinate]
    
    var location: CAPTCHACoordinate
    var url: URL
    
    var onSuccess: (() -> (Void))
    var onFailure: (() -> (Void))
    
    var body: some View {
        Button {
            if targetSquareCoordinates.contains(location) {
                onSuccess()
            } else {
                onFailure()
            }
        } label: {
            AsyncImage(url: url) { image in
                ZStack {
                    image
                        .resizable()
                        .scaledToFill()
                }
            } placeholder: {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .aspectRatio(1, contentMode: .fit)
        }
        .buttonStyle(.plain)
    }
}

struct CAPTCHACoordinate: Equatable {
    var x: UInt8
    var y: UInt8
}
