//
//  ProgramView.swift
//  ace-c-ios
//
//  Created by Kotaro Suto on 2021/08/12.
//

import SwiftUI

struct ProgramView: View {
    let timeTable: TimeTable
    var body: some View {
        ZStack {
            Color.yellow
            // TODO: サムネイルについて対応が決まったら追加
            //            Image("")
            //                .resizable()
            //                .aspectRatio(contentMode: .fill)

            programDetailView
        }
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
