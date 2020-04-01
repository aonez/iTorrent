//
//  Task.swift
//  iTorrent
//
//  Created by Daniil Vinogradov on 01.04.2020.
//  Copyright © 2020  XITRIX. All rights reserved.
//

import Foundation

class Task {
    static func run(_ qos: DispatchQoS.QoSClass, action: @escaping ()->(), main: (()->())? = nil) {
        DispatchQueue.global(qos: qos).async {
            action()
            DispatchQueue.main.async {
                main?()
            }
        }
    }
}
