//
//  File.swift
//  
//
//  Created by Victor Rolando Sanchez Jara on 7/13/20.
//

import Foundation

public extension FloatingPoint {
    var isInteger: Bool { rounded() == self }
}
