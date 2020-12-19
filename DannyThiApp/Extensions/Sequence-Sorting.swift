//
//  Sequence-Sorting.swift
//  DannyThiApp
//
//  Created by Hai Long Danny Thi on 2020/12/19.
//

import Foundation

extension Sequence {
   func sorted<Value>(by keyPath: KeyPath<Element,Value>,
                      using areInIncreasingOrder: (Value, Value) throws -> Bool) rethrows -> [Element] {
      try self.sorted {
         try areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
      }
   }
   
   func sorted<Value:Comparable>(by keyPath: KeyPath<Element,Value>) -> [Element] {
      return self.sorted(by: keyPath, using: <)
   }
}
