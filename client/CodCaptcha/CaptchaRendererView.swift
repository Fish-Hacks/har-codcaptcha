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
            IrisScanningView {
                validationManager.loadNextCaptcha(didSucceed: true)
            }
        case .scissorsPaperStone:
            Text("SPS")
            Spacer()
        case .speech:
            Text("Speech")
            Spacer()
        }
    }
}

#Preview {
    CaptchaRendererView()
}
