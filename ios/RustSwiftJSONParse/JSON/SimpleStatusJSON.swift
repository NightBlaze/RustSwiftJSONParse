//
//  SimpleStatusJSON.swift
//  RustSwiftJSONParse
//
//  Created by Alexander Timonenkov on 04.11.2023.
//

import Foundation

let simpleStatusJSONData = """
{"status": "ok"}
""".data(using: .utf8)!

struct SimpleStatusNative: Decodable {
    let status: String
}
