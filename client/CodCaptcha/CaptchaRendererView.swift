//
//  CaptchaRendererView.swift
//  CodCaptcha
//
//  Created by Jia Chen Yee on 20/1/24.
//

import SwiftUI

struct CaptchaRendererView: View {
    
    @EnvironmentObject var validationManager: CAPTCHAValidationManager
    
    var body: some View {
        switch validationManager.currentCaptcha {
        case .selectPhoto:
            SelectPhotoView { didSucceed in
                validationManager.loadNextCaptcha(didSucceed: didSucceed)
            }
        case .iris:
            EmptyView()
        case .scissorsPaperStone:
            EmptyView()
        case .speech:
            EmptyView()
        }
    }
}

#Preview {
    CaptchaRendererView()
}
