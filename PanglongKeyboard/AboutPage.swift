//
//  AboutPage.swift
//  PanglongSettingPage
//
//  Created by NorHsangPha BoonHse on 31/5/2564 BE.
//

import SwiftUI

struct AboutPage: View {
    var body: some View {
            VStack {
                Image(systemName: "keyboard")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 180, height: 180)
                Text("Panglong Keyboard")
                    .padding()
                    .font(.system(size: 32, weight: .medium, design: .default))
                Text("Version: 1.0")
                    .foregroundColor(.gray)
                Spacer()
                Button {
                    UIApplication.shared.open(URL(string: "https://noernova.com")!)
                }
                label: {
                    Text("Contact Me")
                }
                Spacer()
            }
    }
}

struct AboutPage_Previews: PreviewProvider {
    static var previews: some View {
        AboutPage()
    }
}
