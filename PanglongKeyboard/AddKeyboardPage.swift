//
//  AddKeyboardPage.swift
//  PanglongSettingPage
//
//  Created by NorHsangPha BoonHse on 30/5/2564 BE.
//

import SwiftUI

struct AddKeyboardPage: View {
    
    @State private var promptToOpenSetting = false
    
    var body: some View {
            VStack {
                Image("setupShanKeyboard")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                Button {
                    self.promptToOpenSetting.toggle()
                } label: {
                    Text("Open Settings")
                        .frame(width: 280, height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .cornerRadius(10)
                }
                .alert(isPresented: $promptToOpenSetting) {
                           Alert(
                               title: Text("Panglong Keyboard"),
                               message: Text("သႂ်ႇလွၵ်းမိုဝ်း"),
                               primaryButton: .default(Text("Open")) {
                                   openSetting()
                               },
                            secondaryButton: .cancel()
                           )
                       }
            }
            .navigationBarTitle("Setup keyboard")
    }
}

func openSetting() {
    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
           return
       }

       if UIApplication.shared.canOpenURL(settingsUrl) {
           UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
       }
}

struct AddKeyboardPage_Previews: PreviewProvider {
    static var previews: some View {
        AddKeyboardPage()
    }
}
