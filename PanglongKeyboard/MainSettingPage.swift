//
//  ContentView.swift
//  PanglongKeyboard
//
//  Created by NorHsangPha BoonHse on 31/5/2564 BE.
//

import SwiftUI

struct MainSettingPage: View {
    
    @State private var presentedLicense = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("SETUP")) {
                        NavigationLink(
                            destination: AddKeyboardPage(),
                            label: {
                                SettingButton(useSystemImage: true, buttonImage: "keyboard", buttonTitle: "Add Keyboard", isNavigationButton: true)
                            })
                    }
                    Section(header: Text("SOURCE")) {
                        Button {
                            UIApplication.shared.open(URL(string: "https://github.com/NoerNova/PanglongKeyboard-iOS")!)
                        }
                        label: {
                            NavigationLink(
                                destination: Text("Destination"),
                                label: {
                                    SettingButton(useSystemImage: false, buttonImage: "GitHub", buttonTitle: "Source Code", isNavigationButton: true)
                                }
                            )
                        }
                        Button {
                            self.presentedLicense.toggle()
                        }
                        label: {
                            NavigationLink(
                                destination: Text("MIT License, Copyright (c) 2021 NoerNova"),
                                label: {
                                    SettingButton(useSystemImage: false, buttonImage: "MIT", buttonTitle: "License", isNavigationButton: true)
                                })
                        }
                    }
                    Section(header: Text("About")) {
                        NavigationLink(
                            destination: AboutPage(),
                            label: {
                                SettingButton(useSystemImage: true, buttonImage: "info.circle.fill", buttonTitle: "About", isNavigationButton: true)
                            })
                        HStack {
                            Text("Version")
                                
                                .foregroundColor(.gray)
                            Spacer()
                            Text("1.1")
                                .foregroundColor(.gray)
                        }
                        .frame(height: 60)
                    }
                    Text("Copyright © 2022 Noernova")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.gray)
                }
                
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Panglong Keyboard")
            .sheet(isPresented: $presentedLicense) {
                LicensePage()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainSettingPage()
    }
}

struct SettingButton: View {
    
    var useSystemImage: Bool
    var buttonImage: String
    var buttonTitle: String
    var isNavigationButton: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        HStack {
            useSystemImage ?
                Image(systemName: buttonImage)
                .resizable()
                .padding()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                :
                Image(buttonImage)
                .resizable()
                .padding()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
            Text(buttonTitle)
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
        }
        
    }
}

