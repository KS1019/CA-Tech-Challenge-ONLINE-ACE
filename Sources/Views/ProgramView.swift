//
//  ProgramView.swift
//  ace-c-ios
//
//  Created by Kotaro Suto on 2021/08/12.
//

import SwiftUI

struct ProgramView<T: TimeTableProtocol>: View {
    let timeTable: T

    @State private var showReserveAlert = false

    var body: some View {
        // TODO: サムネイルについて対応が決まったら追加
        //            Image("")
        //                .resizable()
        //                .aspectRatio(contentMode: .fill)
        HStack {
            programDetailView
            Spacer()
            Button(action: {
                showReserveAlert = true
            }, label: {
                Image(systemName: "calendar.badge.plus")
                    .foregroundColor(.black)
            })
            .alert(isPresented: $showReserveAlert) {
                Alert(title: Text("この番組を予約しますか"),
                      primaryButton: .default(
                        Text("予約する"),
                        action: {
                            print("Send API Request here")
                        }
                      ),
                      secondaryButton: .cancel())
            }

        }
        .padding()
        .background(Color.blue)
        .cornerRadius(8.0)

    }

    private var programDetailView: some View {
        VStack {
            Text(timeTable.title)
                .font(.title)
            Text(timeTable.highlight)
                .font(.headline)
        }
    }
}

struct ProgramView_Previews: PreviewProvider {
    static var previews: some View {
        ProgramView(timeTable: MockTimeTable())
            .previewLayout(.sizeThatFits)
    }
}
