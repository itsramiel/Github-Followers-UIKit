//
//  GFError.swift
//  GhFollowers
//
//  Created by Rami Elwan on 11.03.24.
//

import Foundation

enum GFError: String, Error {
    case invalidUrl = "The url is invalid"
    case internetCheck = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again"
    case invalidData = "The data received from the server was invalid. Please try again."
}
