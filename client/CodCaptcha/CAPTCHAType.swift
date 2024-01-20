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
//    case speech
    case waldo
    
    static func random() -> Self {
        Self.allCases.randomElement()!
    }
    
    var description: String {
        switch self {
        case .selectPhoto: "Select Photo"
        case .iris: "Iris"
        case .scissorsPaperStone: "Scissors Paper Stone"
//        case .speech: "Speech"
        case .waldo: "Waldo"
        }
    }
}
