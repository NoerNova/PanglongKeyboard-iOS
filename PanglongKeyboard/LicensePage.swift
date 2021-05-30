//
//  LicensePage.swift
//  PanglongSettingPage
//
//  Created by NorHsangPha BoonHse on 30/5/2564 BE.
//

import SwiftUI

struct LicensePage: View {
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View{
        NavigationView {
            ScrollView {
                VStack {
                    Text(loadLicenseFile(filename: "LICENSE")).frame(maxWidth: .infinity)
                }
            }.padding()
            
            .navigationBarTitle("License")
            .navigationBarItems(trailing: Button("Dismiss"){
                presentationMode.wrappedValue.dismiss()
            })
        }
        
    }
}

func loadLicenseFile(filename: String ) -> String  {
    
    let url = Bundle.main.url(forResource: filename, withExtension: "txt")!
    let data = try! Data(contentsOf: url)
    let string = String(data: data, encoding: .utf8)!
    return string
}

struct LicensePage_Previews: PreviewProvider {
    static var previews: some View {
        LicensePage()
    }
}
