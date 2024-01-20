//
//  CAPTCHARenderingData.swift
//  CodCaptcha
//
//  Created by Jia Chen Yee on 20/1/24.
//

import Foundation

enum CAPTCHARenderingData {
    case selectPhoto
    case iris
    case scissorsPaperStone
    case speech
    
    var value: CAPTCHAType {
        switch self {
        case .selectPhoto: return .selectPhoto
        case .iris: return .iris
        case .scissorsPaperStone: return .scissorsPaperStone
        case .speech: return .speech
        }
    }
}
