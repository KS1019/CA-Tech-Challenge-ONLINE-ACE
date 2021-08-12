//
//  CardView.swift
//  ace-c-ios
//
//  Created by Kotaro Suto on 2021/08/12.
//

import SwiftUI

struct CardView: View {
    var body: some View {
        HStack {
            timeText
            programInfo
        }
        
    }
    
    private var programInfo: some View {
        ZStack {
            Color.yellow
            
            Image("")
                .resizable()
                .aspectRatio(contentMode: .fill)
            
        }
    }
    
    private var timeText: some View {
        ZStack {
            Color.white
            VStack {
                Spacer()
                Text("8:00")
                Spacer()
            }
        }
        .frame(width: 30)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
            .previewLayout(.sizeThatFits)
    }
}
