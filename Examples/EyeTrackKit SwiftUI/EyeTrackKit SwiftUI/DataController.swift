//
//  DataController.swift
//  EyeTrackKit SwiftUI
//
//  Created by Yuki Yamato on 2020/10/01.
//

import Foundation
import CSV
import EyeTrackKit
import SwiftUI

enum DataStatus {
    case INITIALIZED
    case RECORDING
    case FINISHED
}

public class DataController: ObservableObject {
    @Published var status: DataStatus = .INITIALIZED
    @Published var data: [EyeTrackInfo] = []
    //ファイルの場所
    let DOCUMENT_DIRECTORY_PAYH = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!

    public func start() {
        self.status = .RECORDING
    }

    public func add(info: EyeTrackInfo) {
        if self.status == .RECORDING {
            self.data.append(info)
        }
    }

    public func stop() {
        print("Acquired \(data.count) frames")
        self.status = .FINISHED
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

    public func export(name: String) -> Void {
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

    public func reset() {
        self.data.removeAll()
        self.status = .INITIALIZED
    }



}
