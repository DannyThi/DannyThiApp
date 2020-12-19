//
//  ItemRowView.swift
//  DannyThiApp
//
//  Created by Hai Long Danny Thi on 2020/12/19.
//

import SwiftUI

struct ItemRowView: View {
   @ObservedObject var project: Project
   @ObservedObject var item: Item
   
   var icon: some View {
      if item.completed {
         return Image(systemName: "checkmark.circle")
            .foregroundColor(Color(project.projectColor))
      } else if item.priority == 3 {
         return Image(systemName: "exclamationmark.triangle")
            .foregroundColor(Color(project.projectColor))
      } else {
         return Image(systemName: "checkmark.circle")
            .foregroundColor(Color(.clear))
      }
   }
   
   var body: some View {
      NavigationLink(destination: EditItemView(item: item)) {
         Label {
            Text(item.itemTitle)
         } icon: {
            icon
         }
      }
   }
}

struct ItemRowView_Previews: PreviewProvider {
   static let dataController = DataController.preview
   static var previews: some View {
      ProjectsView(showClosedProjects: false)
         .environment(\.managedObjectContext, dataController.container.viewContext)
         .environmentObject(dataController)
   }
}
