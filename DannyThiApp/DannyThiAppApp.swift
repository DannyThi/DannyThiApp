//
//  DannyThiAppApp.swift
//  DannyThiApp
//
//  Created by Hai Long Danny Thi on 2020/12/09.
//

import SwiftUI

@main
struct DannyThiAppApp: App {
   @StateObject var dataController: DataController
   
   var body: some Scene {
      WindowGroup {
         ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
      }
   }
   
   init() {
      let dataController = DataController()
      _dataController = StateObject(wrappedValue: dataController)
   }
}
