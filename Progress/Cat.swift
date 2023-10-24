//
//  Cat.swift
//  Progress
//
//  Created by Brad Ashburn on 10/19/23.
//

import Foundation

struct Cat: Codable, Identifiable {
  let id: String
  let url: String
  let width: Int
  let height: Int
}
