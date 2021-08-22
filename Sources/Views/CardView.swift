//
//  CardView.swift
//  ace-c-ios
//
//  Created by Kotaro Suto on 2021/08/12.
//

import SwiftUI

struct CardView<T: TimeTableProtocol>: View {
    let timeTable: T
    let onCommit: (String) -> Void
    var body: some View {
        HStack {
            timeText
            ProgramView(timeTable: timeTable, onCommit: { programId in
                onCommit(programId)
            })
        }
        .padding([.top, .bottom, .trailing], 8.0)
    }

    private var timeText: some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return
            ZStack {
                Color.white
                VStack {
                    Spacer()
                    Text(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(timeTable.startAt))))
                    Text("~")
                    Text(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(timeTable.endAt))))
                    Spacer()
                }
            }
            .frame(width: 60)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(timeTable: MockTimeTable()) { _ in }
            .previewLayout(.sizeThatFits)
    }
}
