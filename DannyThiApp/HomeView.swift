//
//  HomeView.swift
//  DannyThiApp
//
//  Created by Hai Long Danny Thi on 2020/12/16.
//

import SwiftUI

struct HomeView: View {
   @EnvironmentObject var dataController: DataController
   
   static let tag: String? = "Home"
   
   var body: some View {
      NavigationView {
         VStack {
            Button("Add Data") {
               dataController.deleteAll()
               try? dataController.createSampleData()
            }
         }
         .navigationTitle("Home")
      }
   }
}

struct HomeView_Previews: PreviewProvider {
   static var previews: some View {
      HomeView()
   }
}
