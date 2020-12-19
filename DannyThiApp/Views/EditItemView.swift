//
//  EditItemView.swift
//  DannyThiApp
//
//  Created by Hai Long Danny Thi on 2020/12/16.
//

import SwiftUI

struct ItemRowView: View {
    @ObservedObject var item: Item

    var body: some View {
        NavigationLink(destination: EditItemView(item: item)) {
            Text(item.itemTitle)
        }
    }
}

struct EditItemView: View {
   let item: Item
   @EnvironmentObject var dataController: DataController
   
   @State private var title: String
   @State private var detail: String
   @State private var priority: Int
   @State private var completed: Bool
   
   var body: some View {
      Form {
         Section(header: Text("Basic settings")) {
            TextField("Item name", text: $title.onChange(update))
            TextField("Description", text: $detail)
         }
         
         Section(header: Text("Priority")) {
            Picker("Priority", selection: $priority.onChange(update)) {
               Text("Low").tag(1)
               Text("Medium").tag(2)
               Text("High").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
         }
         
         Section {
            Toggle("Mark Completed", isOn: $completed.onChange(update))
         }
      }
      .navigationTitle("Edit Item")
      .onDisappear(perform: dataController.save)
   }
   
   func update() {
      item.title = title
      item.detail = detail
      item.priority = Int16(priority)
      item.completed = completed
      item.project?.objectWillChange.send()
   }
   
   init(item: Item) {
      self.item = item
      
      _title = State(wrappedValue: item.itemTitle)
      _detail = State(wrappedValue: item.itemDetail)
      _priority = State(wrappedValue: Int(item.priority))
      _completed = State(wrappedValue: item.completed)
   }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        ItemRowView(item: Item.example)
    }
}