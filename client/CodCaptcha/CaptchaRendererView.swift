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
        if validationManager.captchaContent?.value != validationManager.currentCaptcha {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            switch validationManager.captchaContent! {
            case .selectPhoto:
                SelectPhotoView()
            case .iris:
                EmptyView()
            case .scissorsPaperStone:
                EmptyView()
            case .speech:
                EmptyView()
            }
        }
    }
}

#Preview {
    CaptchaRendererView()
}
