//
//  ViewController.swift
//  RustSwiftJSONParse
//
//  Created by Alexander Timonenkov on 03.11.2023.
//

import UIKit
import SwiftProtobuf

extension RustByteSlice {
    func asUnsafeBufferPointer() -> UnsafeBufferPointer<UInt8> {
        UnsafeBufferPointer(start: bytes, count: len)
    }

    func asUnsafeMutableBufferPointer() -> UnsafeMutableBufferPointer<UInt8> {
        let ptr = UnsafeMutablePointer(mutating: bytes)
        return UnsafeMutableBufferPointer(start: ptr, count: len)
    }

    func asString(encoding: String.Encoding = .utf8) -> String? {
        String(bytes: asUnsafeBufferPointer(), encoding: encoding)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let clock = ContinuousClock()
        var elapsed = clock.measure {
            rustParseSimpleStatusJSON()
        }
        print("rust elapsed \(elapsed)")

        elapsed = clock.measure {
            nativeParseSimpleStatusJSON()
        }
        print("native elapsed \(elapsed)")

        elapsed = clock.measure {
            nativeParseBigJSON()
        }
        print("native elapsed \(elapsed)")
    }

    func rustParseSimpleStatusJSON() {
        let result = try! simpleStatusJSONData.withUnsafeBytes<SimpleStatus?> { (pointer: UnsafeRawBufferPointer) -> SimpleStatus? in
            guard
                let baseAddress = pointer.baseAddress,
                let result = rust_parse_simple_status_json(baseAddress, simpleStatusJSONData.count)
            else { return nil }
            let protoData = Data(bytes: result.pointee.bytes, count: result.pointee.len)
            rust_destroy_byte_slice(result)
            return try? SimpleStatus(serializedData: protoData)
        }
        print(result!.status)
    }

    func rustParseBigJSON() {
        let result = try! bigJSONData.withUnsafeBytes<BigJson?> { (pointer: UnsafeRawBufferPointer) -> BigJson? in
            guard
                let baseAddress = pointer.baseAddress,
                let result = rust_parse_big_json(baseAddress, bigJSONData.count)
            else { return nil }
            let protoData = Data(bytes: result.pointee.bytes, count: result.pointee.len)
            rust_destroy_byte_slice(result)
            return try? BigJson(serializedData: protoData)
        }
        print(result!.result.count)
    }

    
    func nativeParseSimpleStatusJSON() {
        let result = try? JSONDecoder().decode(SimpleStatusNative.self, from: simpleStatusJSONData)
        print(result!.status)
    }

    func nativeParseBigJSON() {
        let result = try? JSONDecoder().decode(BigJSONNative.self, from: bigJSONData)
        print(result!.result.count)
    }
}

