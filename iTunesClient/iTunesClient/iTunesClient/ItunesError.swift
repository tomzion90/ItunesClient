//
//  ItunesError.swift
//  iTunesClient
//
//  Created by Tom Zion on 18/09/2018.
//  Copyright © 2018 Treehouse Island. All rights reserved.
//

import Foundation

enum ItunesError: Error {
    case requestFailed
    case responseUnsuccessful
    case invalidData
    case jsonConversionFailure
    case jsonParsingFailure(message: String)
}
