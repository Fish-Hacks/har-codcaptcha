//
//  CAPTCHAValidationManager.swift
//  CodCaptcha
//
//  Created by Jia Chen Yee on 20/1/24.
//

import Foundation
import SwiftUI

class CAPTCHAValidationManager: ObservableObject {
    
    @Published var failedAttempts: Int = 0
    
    @Published var numberOfKilobytes: Int = 0
    var challengeCount: Int {
        numberOfKilobytes / 1024
    }
    @Published var currentChallengeIndex: Int = 0
    
    @Published var currentCaptcha: CAPTCHAType = .selectPhoto
    
    @Published var validationState = ValidationState.unverified
    
    init(numberOfKilobytes: Int = 10) {
        self.numberOfKilobytes = numberOfKilobytes
    }
    
    func loadNextCaptcha(didSucceed: Bool) {
        print(currentChallengeIndex)
        print(challengeCount)
        
        if currentChallengeIndex < challengeCount - 1 || !didSucceed {
            withAnimation {
                var newCaptcha = CAPTCHAType.random()
                
                while currentCaptcha == newCaptcha {
                    newCaptcha = .random()
                }
                currentCaptcha = newCaptcha
                
                if didSucceed {
                    currentChallengeIndex += 1
                } else {
                    failedAttempts += 1
                }
            }
        } else if didSucceed {
            withAnimation {
                validationState = .success
            }
        }
    }
}

enum ValidationState {
    case unverified
    case verifying
    case success
}
