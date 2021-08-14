//
//  GenreView.swift
//  App
//
//  Created by Kotaro Suto on 2021/08/14.
//

import SwiftUI

struct GenreFilterView: View {
    @Binding var selectedGenres: [String: Bool]
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(Array(selectedGenres.keys), id: \.self) { genre in
                    GenreView(genreName: genre, selectedGenres: $selectedGenres)
                }
            }
        }
        .padding()
    }
}

struct GenreView_Previews: PreviewProvider {
    static var previews: some View {
        GenreFilterView(selectedGenres: .constant(["Test": false, "Test2": false, "TEST3": false]))
            .frame(height: 80)
            .previewLayout(.sizeThatFits)
    }
}

struct GenreView: View {
    var genreName: String
    @State var isSelected: Bool = false
    @Binding var selectedGenres: [String: Bool]

    var body: some View {
        Button(action: {
            isSelected.toggle()
            selectedGenres[genreName] = isSelected
        }, label: {
            Text(genreName)
                .foregroundColor(.white)
                .padding()
                .background(isSelected ? Color.red : Color.gray)
                .cornerRadius(15)

        })
    }
}
