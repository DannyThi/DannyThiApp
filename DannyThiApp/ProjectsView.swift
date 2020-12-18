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
   
   static let openTag: String? = "Open"
   static let closedTag: String? = "Closed"
   
   var body: some View {
      NavigationView {
         List {
            ForEach(projects.wrappedValue) { project in
               Section(header: ProjectHeaderView(project: project)) {
                  ForEach(project.projectItems) { item in
                      ItemRowView(item: item)
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
