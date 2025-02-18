//
//  Structs.swift
//  ReKeeper
//
//  Created by Theeratdolchat Chatchai on 16/2/2568 BE.
//

import Foundation
import PhotosUI
import UIKit


struct Place: Identifiable, Codable {
    var id = UUID()
    var name: String
    var icon: String
    var categories: [Category]
}

struct Category: Identifiable, Codable{
    var id = UUID()
    var name : String
    var icon: String
    var items : [Item]
}

struct Item: Identifiable, Codable {
    var id = UUID()
    var name: String
    var receivedDate: Date
    var expiryDate: Date
    var imageData: Data?  // To hold image data if needed
}

