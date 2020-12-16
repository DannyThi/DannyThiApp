//
//  ProjectsView.swift
//  DannyThiApp
//
//  Created by Hai Long Danny Thi on 2020/12/16.
//

import SwiftUI

struct ProjectsView: View {
   let showClosedProjects: Bool
   let projects: FetchRequest<Project>
   
   var body: some View {
      NavigationView {
         List {
            ForEach(projects.wrappedValue) { project in
               Section(header: Text(project.title ?? "")) {
                  ForEach(project.items?.allObjects as? [Item] ?? []) { item in
                     Text(item.title ?? "")
                  }
               }
            }
         }
         .listStyle(InsetGroupedListStyle())
         .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
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
