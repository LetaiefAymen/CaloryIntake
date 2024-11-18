//
//  Environment.swift
//  CaloryIntake
//
//  Created by Aymen Letaief on 2024-11-10.
//

import Foundation

final class AppEnvironment {
    
    static let shared = AppEnvironment()
    
    let foodItemsUrl: URL = URL(string: "https://jsonblob.com/api/jsonBlob/1305245062454435840")!
}
