//
//  HorizontalPickerView.swift
//  App
//
//  Created by Kotaro Suto on 2021/08/14.
//

import SwiftUI

struct HorizontalPickerView<T: PickerButtonTrait>: View {
    @Binding var selection: Int
    var selections: [T.Value]
    var onChange: () -> Void
    init(selection: Binding<Int>, selections: [T.Value], onChange: @escaping () -> Void ) {
        self._selection = selection
        self.selections = selections
        self.onChange = onChange
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(selections.indices, id: \.self) { index in
                    T.makePickerButton(item: selections[index], index: index, onChange: onChange, selection: $selection) {
                        selection = index
                        onChange()
                    }
                    .padding(0)
                }
            }
        }
    }
}

struct HorizontalPickerView_Previews: PreviewProvider {

    static func onChange() {
        print(#function)
    }
    static var previews: some View {

        Group {
            HorizontalPickerView<StringPickerButtonTrait>(selection: .constant(0), selections: ["A", "B", "C", "D", "E", "F", "GGGG"], onChange: onChange)
                .previewLayout(.sizeThatFits)

            // swiftlint:disable force_unwrapping line_length
            HorizontalPickerView<DatePickerButtonTrait>(selection: .constant(0), selections: [Date(), Calendar.current.date(byAdding: .day, value: 1, to: Date())!, Calendar.current.date(byAdding: .day, value: 2, to: Date())!], onChange: onChange)
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
    private let buttonTextString: String
    private let buttonSubTextString: String
    let item: T
    let index: Int
    @Binding var selectedIndex: Int
    let action: () -> Void

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

protocol PickerButtonTrait {
    associatedtype Value
    static func makePickerButton(item: Value, index: Int, onChange: @escaping () -> Void, selection: Binding<Int>, action: @escaping () -> Void) -> PickerButton<Value>
}

enum StringPickerButtonTrait: PickerButtonTrait {
    static func makePickerButton(item: String, index: Int, onChange: @escaping () -> Void, selection: Binding<Int>, action: @escaping () -> Void) -> PickerButton<String> {
        PickerButton(item: item, index: index, selectedIndex: selection, action: action)
    }
}

enum DatePickerButtonTrait: PickerButtonTrait {
    static func makePickerButton(item: Date, index: Int, onChange: @escaping () -> Void, selection: Binding<Int>, action: @escaping () -> Void) -> PickerButton<Date> {
        PickerButton(item: item, index: index, selectedIndex: selection, action: action)
    }
}
