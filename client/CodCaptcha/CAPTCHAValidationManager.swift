//
//  CAPTCHAValidationManager.swift
//  CodCaptcha
//
//  Created by Jia Chen Yee on 20/1/24.
//

import Foundation
import SwiftUI

class CAPTCHAValidationManager: ObservableObject {
    @Published var numberOfKilobytes: Int = 0
    @Published var currentChallengeIndex: Int = 0
    
    @Published var currentCaptcha: CAPTCHAType = .selectPhoto {
        didSet {
            
        }
    }
    
    init(numberOfKilobytes: Int = 10) {
        self.numberOfKilobytes = numberOfKilobytes
    }
    
    func loadNextCaptcha(didSucceed: Bool) {
        withAnimation {
            currentCaptcha = .random()
            
            if didSucceed {
                currentChallengeIndex += 1
            }
        }
    }
}
