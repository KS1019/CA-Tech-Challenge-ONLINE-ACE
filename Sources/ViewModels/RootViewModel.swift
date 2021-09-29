//
//  RootViewModel.swift
//  App
//
//  Created by Kotaro Suto on 2021/09/28.
//

import Combine

class RootViewModel: ObservableObject {
    @Published var tabSelection = Tabs.calendar
}
