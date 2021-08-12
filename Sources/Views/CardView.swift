//
//  CardView.swift
//  ace-c-ios
//
//  Created by Kotaro Suto on 2021/08/12.
//

import SwiftUI

struct CardView: View {
    let timeTable: TimeTable
    var body: some View {
        HStack {
            timeText
            ProgramView(timeTable: timeTable)
        }
        .cornerRadius(8)
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
        CardView(timeTable: TimeTable(id: "1234", title: "Test Title", startAt: 1_627_232_880, endAt: 1_627_237_860, channelId: "9876", labels: ["": false]))
            .previewLayout(.sizeThatFits)
    }
}
