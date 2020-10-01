//
//  DataController.swift
//  EyeTrackKit SwiftUI
//
//  Created by Yuki Yamato on 2020/10/01.
//

import Foundation
import CSV
import EyeTrackKit

public class DataController {
    //ファイルの場所
    let DOCUMENT_DIRECTORY_PAYH = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
    private var formatter = DateFormatter()
    
    public init() {
        formatter.dateFormat = "yyyyMMddHHmmssSSSSS"
    }
    public func export(name: String, coloumns: [String], rows: [[String]]) -> Void {
        let stream = OutputStream(toFileAtPath: name, append: false)!
        let csv = try! CSVWriter(stream: stream)

        try! csv.write(row: coloumns)
        for row in rows {
            try! csv.write(row: row)
        }
        csv.stream.close()
    }
    
    public func export(name: String, data: [EyeTrackInfo]) -> Void {
        let filePath = DOCUMENT_DIRECTORY_PAYH + "/" + name
        let fileURL = URL(fileURLWithPath: filePath)
        let stream = OutputStream(url: fileURL, append: false)!
        let csv = try! CSVWriter(stream: stream)

        try! csv.write(row: ["timestamp", "frame",
                             "faceRotaion-x", "faceRotaion-y", "faceRotaion-z", "faceRotaion-w",
                             "facePosition-x", "facePosition-y", "facePosition-z",
                             "devicePosition-x", "devicePosition-y", "devicePosition-z",
                             "rightEyePotision-x", "rightEyePotision-y", "rightEyePotision-z",
                             "leftEyePotision-x", "leftEyePotision-y", "leftEyePotision-z",
                             "rightEyeLookAtPosition-x", "rightEyeLookAtPosition-y", "rightEyeLookAtPosition-z",
                             "leftEyeLookAtPosition-x", "leftEyeLookAtPosition-y", "leftEyeLookAtPosition-z",
                             "rightEyeLookAtPoint-x", "rightEyeLookAtPoint-y",
                             "leftEyeLookAtPoint-x", "leftEyeLookAtPoint-y",
                             "centerEyeLookAtPoint-x", "centerEyeLookAtPoint-y",
                             "rightEyeBlink", "leftEyeBlink",
                             "rightEyeDistance", "leftEyeDistance"])
        for info in data {
            try! csv.write(row: info.toCSV())
        }
        csv.stream.close()
    }
    
    public func dateToString(date:Date) -> String {
        return formatter.string(from: Date())
    }
}
