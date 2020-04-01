//
//  TrackerModel.swift
//  iTorrent
//
//  Created by Daniil Vinogradov on 30.03.2020.
//  Copyright © 2020  XITRIX. All rights reserved.
//

import Foundation

struct TrackerModel {
    var tracker_url: String
    var seeders: Int32
    var peers: Int32
    var leechs: Int32
    var working: Bool
    var verified: Bool
}
