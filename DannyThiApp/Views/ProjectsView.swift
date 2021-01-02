//
//  ProjectsView.swift
//  DannyThiApp
//
//  Created by Hai Long Danny Thi on 2020/12/16.
//

import SwiftUI

struct ProjectsView: View {
   @EnvironmentObject var dataController: DataController
   @Environment(\.managedObjectContext) var managedObjectContext
   @State private var showingSortOrder = false
   @State private var sortOrder = Item.SortOrder.optimised
   
   let projects: FetchRequest<Project>
   let showClosedProjects: Bool
   
   static let openTag: String? = "Open"
   static let closedTag: String? = "Closed"
   
   var body: some View {
      NavigationView {
         Group {
            if projects.wrappedValue.count == 0 {
               Text("There's nothing here right now.")
                  .foregroundColor(.secondary)
            } else {
               List {
                  ForEach(projects.wrappedValue) { project in
                     Section(header: ProjectHeaderView(project: project)) {
                        ForEach(project.projectItems(using: sortOrder)) { item in
                           ItemRowView(project: project, item: item)
                        }
                        .onDelete { offsets in
                           let allItems = project.projectItems(using: sortOrder)
                           
                           for offset in offsets {
                              let item = allItems[offset]
                              dataController.delete(item)
                           }
                           dataController.save()
                        }
                        
                        if showClosedProjects == false {
                           Button {
                              withAnimation {
                                 let item = Item(context: managedObjectContext)
                                 item.project = project
                                 item.creationDate = Date()
                                 dataController.save()
                              }
                           } label: {
                              Label("Add New Item", systemImage: "plus")
                           }
                        }
                     }
                  }
               }
               .listStyle(InsetGroupedListStyle())
               .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
               .toolbar {
                  ToolbarItem(placement: .navigationBarTrailing) {
                     if showClosedProjects == false {
                        Button {
                           withAnimation {
                              let project = Project(context: managedObjectContext)
                              project.closed = false
                              project.creationDate = Date()
                              dataController.save()
                           }
                        } label: {
                           if UIAccessibility.isVoiceOverRunning {
                               Text("Add Project")
                           } else {
                               Label("Add Project", systemImage: "plus")
                           }
                        }
                     }
                  }
                  ToolbarItem(placement: .navigationBarLeading) {
                     Button {
                        showingSortOrder.toggle()
                     } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                     }
                  }
               }
            }
         }
         .actionSheet(isPresented: $showingSortOrder) {
            ActionSheet(title: Text("Sort Items"), message: nil, buttons: [
               .default(Text("Optimised")) { sortOrder = .optimised },
               .default(Text("Creation Date")) { sortOrder = .creationDate },
               .default(Text("Title")) { sortOrder = .title }
            ])
         }
         SelectSomethingView()
      }
   }
   
   init(showClosedProjects: Bool) {
      self.showClosedProjects = showClosedProjects
      let sortDescriptor = NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)
      let predicate = NSPredicate(format: "closed = %d", showClosedProjects)
      projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [sortDescriptor], predicate: predicate)
   }
}


struct ProjectsView_Previews: PreviewProvider {
   static var dataController = DataController.preview
   static var previews: some View {
      ProjectsView(showClosedProjects: false)
         .environment(\.managedObjectContext, dataController.container.viewContext)
         .environmentObject(dataController)
   }
}
