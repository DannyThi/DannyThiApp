//
//  Binding-OnChange.swift
//  DannyThiApp
//
//  Created by Hai Long Danny Thi on 2020/12/16.
//

import SwiftUI

extension Binding {
   func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
      Binding(
         get: { self.wrappedValue },
         set: { newValue in
            self.wrappedValue = newValue
            handler()
         }
      )
   }
}
