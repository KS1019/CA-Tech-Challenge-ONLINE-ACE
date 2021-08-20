//
//  HorizontalPickerView.swift
//  App
//
//  Created by Kotaro Suto on 2021/08/14.
//

import SwiftUI

struct HorizontalPickerView<T: RandomAccessCollection>: View where T.Element: Hashable, T.Index: Hashable {
    @Binding var selection: Int
    var selections: T
    init(selection: Binding<Int>, selections: T) where T.Element == String {
        self._selection = selection
        self.selections = selections
    }

    init(selection: Binding<Int>, selections: T) where T.Element == Date {
        self._selection = selection
        self.selections = selections
    }

    private init() {
        self._selection = .constant(0)
        self.selections = [] as! T
        self._selection = .constant(0)
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(selections.indices, id: \.self) { index in
                    if type(of: selections[index]) == Date.self {
                        PickerButton(item: selections[index] as! Date, index: index as! Int, selectedIndex: $selection) {
                            selection = index as! Int
                        }
                        .padding(0)
                    } else if type(of: selections[index]) == String.self {
                        PickerButton(item: selections[index] as! String, index: index as! Int, selectedIndex: $selection) {
                            selection = index as! Int
                        }
                        .padding(0)
                    }
                }
            }
        }
    }
}

struct HorizontalPickerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HorizontalPickerView(selection: .constant(0), selections: ["A", "B", "C", "D", "E", "F", "GGGG"])
                .previewLayout(.sizeThatFits)

            // swiftlint:disable force_unwrapping line_length
            HorizontalPickerView(selection: .constant(0), selections: [Date(), Calendar.current.date(byAdding: .day, value: 1, to: Date())!, Calendar.current.date(byAdding: .day, value: 2, to: Date())!])
                .previewLayout(.sizeThatFits)

            PickerButton(item: "A", index: 1, selectedIndex: .constant(1)) {
                print("Test String")
            }
            .previewLayout(.sizeThatFits)

            PickerButton(item: Date(), index: 1, selectedIndex: .constant(1)) {
                print("Test Date")
            }
            .previewLayout(.sizeThatFits)
        }
    }
}

struct PickerButton<T>: View {
    private var buttonTextString: String = ""
    private var buttonSubTextString: String = ""
    var item: T
    var index: Int
    @Binding var selectedIndex: Int
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            VStack {
                Text(buttonSubTextString)
                    .font(.system(size: 15, weight: .regular, design: .monospaced))
                    .foregroundColor(.black)
                Spacer()
                    .frame(width: 45, height: 10, alignment: .center)

                Text(buttonTextString)
                    .foregroundColor(.black)
                    .font(.system(size: 40, weight: .bold, design: .default))

            }
            .padding(.top, 5)
            .padding([.bottom, .leading, .trailing], 10)
            .background(index == selectedIndex ? Color.orange : Color.gray)
        }
    }
}

extension PickerButton where T == Date {
    init(item: T, index: Int, selectedIndex: Binding<Int>, action: @escaping () -> Void) {
        self.item = item
        self.action = action
        self._selectedIndex = selectedIndex
        self.index = index
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        buttonTextString = formatter.string(from: item)

        if Calendar.current.isDateInToday(item) {
            buttonSubTextString = "TODAY"
        } else {
            formatter.dateFormat = "EEE"
            buttonSubTextString = formatter.string(from: item)
        }
    }
}

extension PickerButton where T == String {
    init(item: T, index: Int, selectedIndex: Binding<Int>, action: @escaping () -> Void) {
        self.item = item
        self.action = action
        self._selectedIndex = selectedIndex
        self.index = index
        buttonTextString = self.item
        buttonSubTextString = "Channel"
    }
}
