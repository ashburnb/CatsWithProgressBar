//
//  CatViewModel.swift
//  Progress
//
//  Created by Brad Ashburn on 10/19/23.
//

import Foundation
import SwiftUI

@MainActor class CatViewModel: ObservableObject {
  @Published var catsFromAPI = [Cat]()
  
  init() {
    Task {
      do {
        try await fetchCatsFromAPI()
      } catch {
        print("Error fetching data from API")
      }
    }
  }
  
  func downloadBytes(progress: Binding<Float>) async throws {
    let configuration = URLSessionConfiguration.default
    let session = URLSession(configuration: configuration)
    guard let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=10") else { return }
    
    let (asyncBytes, response) = try await session.bytes(from: url)
    let contentLength = Float(response.expectedContentLength)
    print(contentLength)
    var data = Data(capacity: Int(contentLength))
    
    for try await byte in asyncBytes {
      data.append(byte)
      let currentProgress = Float(data.count) / contentLength
      if Int(progress.wrappedValue * 100) != Int(currentProgress * 100) {
        progress.wrappedValue = currentProgress
      }
    }
  }
  
  
  func fetchCatsFromAPI() async throws {
    guard let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=10") else { return }
    
    let configuration = URLSessionConfiguration.default
    // wait for connectivity or fail immediately
    configuration.waitsForConnectivity = true
    // unit is seconds
    configuration.timeoutIntervalForRequest = 10
    // set to false to prevent cellular network access
    configuration.allowsCellularAccess = true
    // set to false to prevent expensive network access
    configuration.allowsExpensiveNetworkAccess = true
    // set to false to prevent network access in Low Data Mode
    configuration.allowsConstrainedNetworkAccess = true
    
    let session = URLSession(configuration: configuration)
    
    let (data, response) = try await session.data(from: url)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else { return }
    self.catsFromAPI = try JSONDecoder().decode([Cat].self, from: data)
  }
  
}
