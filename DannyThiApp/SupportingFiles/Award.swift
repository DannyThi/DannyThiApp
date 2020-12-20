//
//  Award.swift
//  DannyThiApp
//
//  Created by Hai Long Danny Thi on 2020/12/20.
//

import Foundation

struct Award: Decodable, Identifiable {
   var id: String { return name }
   let name: String
   let description: String
   let color: String
   let criterion: String
   let value: Int
   let image: String
   
   static let allAwards = Bundle.main.decode(type: [Award].self, from: "Awards.json")
   static let example = allAwards[0]
}
