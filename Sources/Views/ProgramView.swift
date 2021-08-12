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
        Color.yellow
    }
}

struct ProgramView_Previews: PreviewProvider {
    static var previews: some View {
        ProgramView(timeTable: TimeTable(id: "1234", title: "Test Title", startAt: 1_627_232_880, endAt: 1_627_237_860, channelId: "9876", labels: ["": false]))
    }
}
