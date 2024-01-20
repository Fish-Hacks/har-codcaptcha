//
//  CAPTCHAValidationManager.swift
//  CodCaptcha
//
//  Created by Jia Chen Yee on 20/1/24.
//

import Foundation
import SwiftUI

class CAPTCHAValidationManager: ObservableObject {
    @Published var success = false
    
    @Published var numberOfKilobytes: Int = 0
    var challengeCount: Int {
        numberOfKilobytes / 10
    }
    @Published var currentChallengeIndex: Int = 0
    
    @Published var currentCaptcha: CAPTCHAType = .selectPhoto
    
    init(numberOfKilobytes: Int = 10) {
        self.numberOfKilobytes = numberOfKilobytes
    }
    
    func loadNextCaptcha(didSucceed: Bool) {
        if currentChallengeIndex < challengeCount - 1 || !didSucceed {
            withAnimation {
                currentCaptcha = .random()
                
                if didSucceed {
                    currentChallengeIndex += 1
                }
            }
        } else if didSucceed {
            success = true
        }
    }
}
