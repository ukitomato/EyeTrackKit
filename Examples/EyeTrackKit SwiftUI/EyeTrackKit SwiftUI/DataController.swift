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

        try! csv.write(row: EyeTrackInfo.CSV_COLUMNS)
        for info in data {
            try! csv.write(row: info.toCSV)
        }
        csv.stream.close()
    }
}
