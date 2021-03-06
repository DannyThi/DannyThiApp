//
//  AwardsView.swift
//  DannyThiApp
//
//  Created by Hai Long Danny Thi on 2020/12/20.
//

import SwiftUI

struct AwardsView: View {
   static let tag: String? = "Awards"
   
   @EnvironmentObject var dataController: DataController
   @State private var selectedAward = Award.example
   @State private var showingAwardDetails = false
   
   var colums: [GridItem] {
      [GridItem(.adaptive(minimum: 100, maximum: 100))]
   }
   
   var body: some View {
      NavigationView {
         ScrollView {
            LazyVGrid(columns: colums) {
               ForEach(Award.allAwards) { award in
                  Button {
                     self.selectedAward = award
                     self.showingAwardDetails = true
                  } label: {
                     Image(systemName: award.image)
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(width: 100, height: 100)
                        .foregroundColor(dataController.hasEarned(award: award) ? Color(award.color) : Color.secondary.opacity(0.5))
                  }
                  .accessibilityLabel(
                      Text(dataController.hasEarned(award: award) ? "Unlocked: \(award.name)" : "Locked")
                  )
                  .accessibilityHint(Text(award.description))
               }
            }
         }
         .navigationTitle("Awards")
         .alert(isPresented: $showingAwardDetails) {
            if dataController.hasEarned(award: selectedAward) {
               return Alert(title: Text("Unlocked \(selectedAward.name)"),
                            message: Text("\(selectedAward.description)"),
                            dismissButton: .default(Text("OK")))
            } else {
               return Alert(title: Text("Locked"),
                            message: Text("\(Text(selectedAward.description))"),
                            dismissButton: .default(Text("OK")))
            }
         }
      }
   }
}


struct AwardsView_Previews: PreviewProvider {
   static let dataController = DataController.preview
   static var previews: some View {
      AwardsView()
         .environmentObject(dataController)
   }
}
