//
//  UIApplication+Extensions.swift
//  App
//
//  Created by TanakaHirokazu on 2021/08/15.
//

import SwiftUI

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
