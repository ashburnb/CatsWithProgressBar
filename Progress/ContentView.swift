//
//  ContentView.swift
//  Progress
//
//  Created by Brad Ashburn on 10/19/23.
//

import SwiftUI

struct ContentView: View {
  @StateObject var catVM = CatViewModel()
  @State private var progress: Float = 0.0
  
  var body: some View {
    VStack {
      ProgressView(value: progress) {
        Text("Downloading...")
      } currentValueLabel: {
        Text("\(Int(progress * 100))%")
      }
      .padding(.horizontal, 30)
      .font(.callout)
      
      Spacer()
      
      ScrollView {
        ForEach(catVM.catsFromAPI, id: \.id) { cat in
          AsyncImage(url: URL(string: cat.url))
        }
        .listRowSeparator(.hidden)
      }
    }
    .task {
      do {
        try await catVM.downloadBytes(progress: $progress)
      } catch {
        print(error)
      }
    }
  }
}

#Preview {
  ContentView()
}
