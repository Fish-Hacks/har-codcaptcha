//
//  ScissorsPaperStoneView.swift
//  CodCaptcha
//
//  Created by Jia Chen Yee on 20/1/24.
//

import SwiftUI

struct ScissorsPaperStoneView: View {
    
    @StateObject var handGestureViewModel = HandGestureViewModel()
    
    @State private var countdownTime: Int?
    @State private var computerChoice = ScissorsPaperStoneOption.random()
    @State private var userChoice: ScissorsPaperStoneOption? = nil
    
    var onCompletion: ((Bool) -> Void)
    
    var body: some View {
        VStack(alignment: .center) {
            if countdownTime != nil {
                VStack {
                    if countdownTime != 0 {
                        Text("\(countdownTime!)")
                            .font(.system(size: 128))
                            .contentTransition(.numericText())
                            .fontWeight(.bold)
                            .monospacedDigit()
                            .padding(.bottom)
                    }
                    
                    HStack(alignment: .top) {
                        VStack {
                            if countdownTime != 0 {
                                ProgressView()
                            } else {
                                Text(computerChoice.description)
                                    .font(.system(size: 64, weight: .medium))
                            }
                            
                            Text("Computer Choice")
                                .font(.title)
                            
                            if let userChoice, computerChoice.losesTo != userChoice && countdownTime == 0 {
                                Image(systemName: "medal")
                                    .foregroundStyle(.yellow)
                                    .font(.system(size: 64, weight: .medium))
                                    .padding(.top)
                                    .onAppear {
                                        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                                            onCompletion(false)
                                        }
                                    }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack {
                            if let userChoice {
                                Text(userChoice.description)
                                    .font(.system(size: 64, weight: .medium))
                            }
                            
                            Text("Your Choice")
                                .font(.title)
                            
                            if let userChoice, !(computerChoice.losesTo != userChoice) && countdownTime == 0 {
                                Image(systemName: "medal")
                                    .foregroundStyle(.yellow)
                                    .font(.system(size: 64, weight: .medium))
                                    .padding(.top)
                                    .onAppear {
                                        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                                            onCompletion(true)
                                        }
                                    }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .onChange(of: handGestureViewModel.predictionResult) { newValue in
                        if countdownTime != 0 {
                            userChoice = newValue
                        }
                    }
                }
            } else {
                Text("Scissors Paper Stone")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("To prove you are human, win at scissors paper stone.\nPlace your hand in front of the camera.")
                    .multilineTextAlignment(.center)
                
                Button("Start") {
                    countdownTime = 3
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                        withAnimation {
                            countdownTime! -= 1
                        }
                        if countdownTime == 0 {
                            timer.invalidate()
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
