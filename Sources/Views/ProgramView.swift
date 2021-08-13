//
//  ProgramView.swift
//  ace-c-ios
//
//  Created by Kotaro Suto on 2021/08/12.
//

import SwiftUI

struct ProgramView: View {
    let timeTable: TimeTable

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
        ProgramView(timeTable: TimeTable(id: "1234", title: "Test Title", highlight: "Test high light", detailHighlight: "test detailHighlight", startAt: 1_627_232_880, endAt: 1_627_237_860, channelId: "9876", labels: ["": false]))
            .previewLayout(.sizeThatFits)
    }
}
