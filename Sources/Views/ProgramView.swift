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
    let onCommit: (String) -> Void
    var body: some View {
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
                            onCommit(timeTable.id)
                            print("Send API Request here")
                        }
                      ),
                      secondaryButton: .cancel())
            }

        }
        .padding()
        .background(Color("Color"))
        .cornerRadius(8.0)

    }

    private var programDetailView: some View {
        VStack {
            Text(timeTable.title)
                .font(.title)
            Text(timeTable.content)
                .font(.headline)
        }
    }
}

struct ProgramView_Previews: PreviewProvider {
    static var previews: some View {
        ProgramView(timeTable: MockTimeTable()) { _ in }
            .previewLayout(.sizeThatFits)
    }
}
