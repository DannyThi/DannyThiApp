//
//  EditProjectView.swift
//  DannyThiApp
//
//  Created by Hai Long Danny Thi on 2020/12/19.
//

import SwiftUI

struct EditProjectView: View {
   
   @EnvironmentObject var dataController: DataController
   @State private var title: String
   @State private var detail: String
   @State private var color: String
   
   @Environment(\.presentationMode) var presentationMode
   @State private var showingDeleteConfirm = false
   
   let project: Project
   let colorColumns = [GridItem(.adaptive(minimum: 44))]
   
   var body: some View {
      Form {
         Section(header: Text("Basic Settings")) {
            TextField("Project Name", text: $title.onChange(update))
            TextField("Description of project", text: $detail.onChange(update))
         }
         
         Section(header: Text("Custom project color")) {
            LazyVGrid(columns: colorColumns) {
               ForEach(Project.colors, id: \.self, content: colorButton)
            }
            .padding(.vertical)
         }
         
         Section(footer: Text("Closing a project moves it from the Open to Closed tab; deleting it removes the project completely.")) {
            Button(project.closed ? "Reopen this project" : "Close this project") {
               project.closed.toggle()
               update()
            }
            
            Button("Delete this project") {
               self.showingDeleteConfirm.toggle()
            }
            .accentColor(.red)
         }
      }
      .navigationTitle("Edit Project")
      .onDisappear(perform: dataController.save)
      .alert(isPresented: $showingDeleteConfirm) {
         Alert(title: Text("Delete project?"),
               message: Text("Are you sure you want to delete this project? You will also delete all the items it contains."),
               primaryButton: .default(Text("Delete"), action: delete),
               secondaryButton: .cancel()
         )
      }
   }
   
   func colorButton(for item: String) -> some View {
      ZStack {
         Color(item)
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(6)
         if item == color {
            Image(systemName: "checkmark.circle")
               .foregroundColor(.white)
               .font(.largeTitle)
         }
      }
      .onTapGesture {
         color = item
         update()
      }
      .accessibilityElement(children: .ignore)
      .accessibilityAddTraits(item == color ? [.isButton, .isSelected] : .isButton)
      .accessibilityLabel(LocalizedStringKey(item))
   }
   
   func update() {
      project.title = title
      project.detail = detail
      project.color = color
   }
   
   func delete() {
      dataController.delete(project)
      presentationMode.wrappedValue.dismiss()
   }
   
   init(project: Project) {
      self.project = project
      
      _title = State(wrappedValue: project.projectTitle)
      _detail = State(wrappedValue: project.projectDetail)
      _color = State(wrappedValue: project.projectColor)
   }
}

struct EditProjectView_Previews: PreviewProvider {
   static let dataController = DataController.preview
   static var previews: some View {
      EditProjectView(project: Project.example)
         .environmentObject(dataController)
   }
}
