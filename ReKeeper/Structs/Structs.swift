//
//  Structs.swift
//  ReKeeper
//
//  Created by Theeratdolchat Chatchai on 16/2/2568 BE.
//

import Foundation
import PhotosUI


struct Place : Identifiable{
    var id = UUID()
    var name: String
    var icon: String
    var categories: [Category]
}

struct Category : Identifiable{
    var id = UUID()
    var name : String
    var icon: String
    var items : [Item]
}

struct Item : Identifiable{
    var id = UUID()
    var name : String
    var image : UIImage
}
