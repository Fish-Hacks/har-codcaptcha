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
    @Published var captchaContent: CAPTCHARenderingData? = .selectPhoto
    
    init(numberOfKilobytes: Int = 10) {
        self.numberOfKilobytes = numberOfKilobytes
    }
    
    func loadNextCaptcha(didSucceed: Bool) {
        withAnimation {
            currentCaptcha = .random()
//            captchaContent =
            
            if didSucceed {
                currentChallengeIndex += 1
            }
        }
    }
}
