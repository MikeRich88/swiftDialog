//
//  ContentView.swift
//  dialog
//
//  Created by Bart Reardon on 9/3/21.
//

import SwiftUI
import Cocoa

struct ContentView: View {

    var titlePadding       = CGFloat(10)

    @ObservedObject var observedData: DialogUpdatableContent

    init (observedDialogContent: DialogUpdatableContent) {
        self.observedData = observedDialogContent
        if observedDialogContent.args.bannerImage.present {
            writeLog("Banner Image is present")
            titlePadding = 0
        }
    }
//
//    // set up timer to read data from temp file
//    let updateTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect() // tick every 1 second
//
    var body: some View {

        ZStack {
            if observedData.args.watermarkImage.present {
                    WatermarkView(observedContent: observedData)
            }

            // this stack controls the main view. Consists of a VStack containing all the content, and a HStack positioned at the bottom of the display area
            VStack {
                if observedData.args.bannerImage.present {
                    BannerImageView(observedDialogContent: observedData)
                        .border(observedData.appProperties.debugBorderColour, width: 2)
                }

                if observedData.args.titleOption.value != "none" && !observedData.args.bannerTitle.present {
                    // Dialog title
                    TitleView(observedData: observedData)
                        .border(observedData.appProperties.debugBorderColour, width: 2)
                        .padding(.top, titlePadding)
                        //.frame(minWidth: observedData.args.windowWidth.value.floatValue(), minHeight: observedData.appProperties.titleHeight, alignment: .center)
                        .frame(minHeight: observedData.appProperties.titleHeight, alignment: .center)

                    // Horozontal Line
                    Divider()
                        .padding(.leading, appDefaults.sidePadding)
                        .padding(.trailing, appDefaults.sidePadding)
                        .frame(height: 2)
                } else {
                    Spacer()
                        .frame(height: appDefaults.sidePadding)
                }

                DialogView(observedDialogContent: observedData)

                Spacer()

                // Buttons
                ButtonView(observedDialogContent: observedData)
                    .padding(.leading, appDefaults.sidePadding)
                    .padding(.trailing, appDefaults.sidePadding)
                    .padding(.bottom, appDefaults.bottomPadding)
                    .border(observedData.appProperties.debugBorderColour, width: 2)
            }

            if observedData.appProperties.authorised {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "lock.circle")
                        //.resizable()
                            .font(Font.title.weight(.light))
                            .symbolRenderingMode(.monochrome)
                            .foregroundColor(.yellow)
                            .opacity(0.5)
                    }
                    Spacer()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $observedData.showSheet, content: {
            ErrorView(observedContent: observedData)
                .background(WindowAccessor { window in
                    window?.canBecomeVisibleWithoutLogin = true
                })
        })
    }


}

