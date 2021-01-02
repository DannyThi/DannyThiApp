//
//  HomeView.swift
//  DannyThiApp
//
//  Created by Hai Long Danny Thi on 2020/12/16.
//

import SwiftUI
import CoreData

struct HomeView: View {
   static let tag: String? = "Home"
   
   @EnvironmentObject var dataController: DataController
   @FetchRequest(entity: Project.entity(),
                 sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)],
                 predicate: NSPredicate(format: "closed = false")) var projects: FetchedResults<Project>
   
   let items: FetchRequest<Item>
   
   var projectRows: [GridItem] {
      return [GridItem(.fixed(100))]
   }
   
   var body: some View {
      NavigationView {
         ScrollView {
            VStack(alignment: .leading) {
               ScrollView(.horizontal, showsIndicators: false) {
                  LazyHGrid(rows: projectRows) {
                     ForEach(projects, content: ProjectSummaryView.init)
                  }
                  .fixedSize(horizontal: false, vertical: true)
               }
               
               VStack(alignment: .leading) {
                  ItemListView(title: "Up next", items: items.wrappedValue.prefix(3))
                  ItemListView(title: "More to explore", items: items.wrappedValue.dropFirst(3))
               }
               .padding(.horizontal)
            }
         }
         .background(Color.systemGroupedBackground.ignoresSafeArea())
         .navigationTitle("Home")
      }
   }
   
   init() {
      let request: NSFetchRequest<Item> = Item.fetchRequest()
      request.predicate = NSPredicate(format: "completed = false")
      request.sortDescriptors = [
         NSSortDescriptor(keyPath: \Item.priority, ascending: false)
      ]
      request.fetchLimit = 10
      items = FetchRequest(fetchRequest: request)
   }
}

struct HomeView_Previews: PreviewProvider {
   static var previews: some View {
      HomeView()
         .environmentObject(DataController.preview)
   }
}
