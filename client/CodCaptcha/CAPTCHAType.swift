//
//  CAPTCHAType.swift
//  CodCaptcha
//
//  Created by Jia Chen Yee on 20/1/24.
//

import Foundation

enum CAPTCHAType: CaseIterable {
    case selectPhoto
    case iris
    case scissorsPaperStone
    case speech
    
    static func random() -> Self {
        Self.allCases.randomElement()!
    }
}
