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

    public static func convertToUIImage(_ pixelBuffer: CVPixelBuffer) -> UIImage? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
        guard let image = CIContext().createCGImage(ciImage, from: imageRect) else { return nil }
        return UIImage(cgImage: image)
    }

    public static func getDocumentsURL() -> NSURL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        return documentsURL
    }

    public static func createFilePath(filename: String) -> String {
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL!.path
    }

    public static func saveImage (image: UIImage, path: String) -> Bool {
        let jpgImageData = image.jpegData(compressionQuality: 0.9)
        do {
            try jpgImageData!.write(to: URL(fileURLWithPath: path), options: .atomic)
        } catch {
            print(error)
            return false
        }
        return true
    }

    public static func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmssSSSSS"
        return formatter.string(from: Date())
    }
}
