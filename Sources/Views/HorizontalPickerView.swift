//
//  HorizontalPickerView.swift
//  App
//
//  Created by Kotaro Suto on 2021/08/14.
//

import SwiftUI

struct HorizontalPickerView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct HorizontalPickerView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalPickerView()
    }
}

struct PickerButton: View {
    var buttonTextString: String
    @State var isSelected: Bool = false
    var body: some View {
        Button(action: {
            isSelected.toggle()
        }, label: {
            Text(buttonTextString)
                .foregroundColor(.black)
                .bold()
                .background(isSelected ? Color.orange : Color.gray)
        })
    }
}
