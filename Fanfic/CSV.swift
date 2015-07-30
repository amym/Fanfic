//
//  CSV.swift
//  SwiftCSV
//
//  Created by naoty on 2014/06/09.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import Foundation

public class CSV {
    public var headers: [String] = []
    public var rows: [Dictionary<String, String>] = []
    public var columns = Dictionary<String, [String]>()
    var delimiter = NSCharacterSet(charactersInString: ",")
    
    public init?(contentsOfFile url: String, delimiter: NSCharacterSet, error: NSErrorPointer) {
        let csvString = String(contentsOfFile: url, encoding: NSUTF8StringEncoding, error: error);
        if let csvStringToParse = csvString {
            self.delimiter = delimiter
            
            let newline = NSCharacterSet.newlineCharacterSet()
            var lines: [String] = []
            csvStringToParse.stringByTrimmingCharactersInSet(newline).enumerateLines { line, stop in lines.append(line) }
            
            self.headers = self.parseHeaders(fromLines: lines)
            self.rows = self.parseRows(fromLines: lines)
            self.columns = self.parseColumns(fromLines: lines)
        }
    }
    
    public convenience init?(contentsOfFile url: String, error: NSErrorPointer) {
        let comma = NSCharacterSet(charactersInString: ",")
        self.init(contentsOfFile: url, delimiter: comma, error: error)
    }
    
    func parseHeaders(fromLines lines: [String]) -> [String] {
        return lines[0].componentsSeparatedByCharactersInSet(self.delimiter)
    }
    
    func parseRows(fromLines lines: [String]) -> [Dictionary<String, String>] {
        var rows: [Dictionary<String, String>] = []
        
        for (lineNumber, line) in enumerate(lines) {
            if lineNumber == 0 {
                continue
            }
            
            var row = Dictionary<String, String>()
            let values = line.componentsSeparatedByCharactersInSet(self.delimiter)
            for (index, header) in enumerate(self.headers) {
                let value = values[index]
                var num = value.toInt()
                if num > 0{
                    var formatter: NSNumberFormatter = NSNumberFormatter()
                    formatter.locale = NSLocale.systemLocale()
                    formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
                    row[header] = formatter.stringFromNumber(formatter.numberFromString(value)!)
                }
                else{
                    if value == "" {
                        row[header] = "N/A"
                    }
                    else if value == "E" {
                        row[header] = ""
                    }
                    else {
                        row[header] = value
                    }
                }
            }
            rows.append(row)
        }
        
        return rows
    }
    
    func parseColumns(fromLines lines: [String]) -> Dictionary<String, [String]> {
        var columns = Dictionary<String, [String]>()
        
        for header in self.headers {
            let column = self.rows.map { row in row[header]! }
            columns[header] = column
        }
        
        return columns
    }
}
