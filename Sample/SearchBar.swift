//
//  SearchBar.swift
//  App
//
//  Created by TanakaHirokazu on 2021/08/15.
//

import SwiftUI

struct SearchBar: View {
    @Binding var query: String
    @Binding var isEditing: Bool

    var onCommit: () -> Void

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("キーワードを検索してください", text: $query,

                          onEditingChanged: { begin in

                            isEditing = begin

                          },
                          // リターンキーが押された時の処理
                          onCommit: {
                            onCommit()
                          })
                    .foregroundColor(.primary)
                Button(action: {
                    query = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(query == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)

            if isEditing {
                Button("Cancel") {
                    query = ""
                    UIApplication.shared.closeKeyboard()
                }
            }

        }
        .padding(.horizontal)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static func getInfo() {
        print("テスト")
    }
    static var previews: some View {

        SearchBar(query: .constant(" "), isEditing: .constant(false), onCommit: getInfo)
    }
}
