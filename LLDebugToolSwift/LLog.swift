//
//  LLog.swift
//
//  Copyright (c) 2018 LLDebugTool Software Foundation (https://github.com/HDB-Li/LLDebugToolSwift)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit
import LLDebugTool

public class LLog: NSObject {
    
    /// Log a normal message.
    public static func log(message : String? , file : String = #file , function : String = #function , lineNumber : Int = #line) {
        #if DEBUG
        LLDebugTool.shared().log(inFile: (file as NSString).lastPathComponent, function: function, lineNo: lineNumber, level: LLConfigLogLevel.default, onEvent: nil, message: message)
        #endif
    }
    
    /// Log a normal message with event.
    public static func log(message : String? , event : String? , file : String = #file , function : String = #function , lineNumber : Int = #line) {
        #if DEBUG
        LLDebugTool.shared().log(inFile: (file as NSString).lastPathComponent, function: function, lineNo: lineNumber, level: LLConfigLogLevel.default, onEvent: event, message: message)
        #endif
    }
    
    /// Log a alert message.
    public static func alertLog(message : String? , file : String = #file , function : String = #function , lineNumber : Int = #line) {
        #if DEBUG
        LLDebugTool.shared().log(inFile: (file as NSString).lastPathComponent, function: function, lineNo: lineNumber, level: LLConfigLogLevel.alert, onEvent: nil, message: message)
        #endif
    }

    /// Log a alert message with event.
    public static func alertLog(message : String? , event : String? , file : String = #file , function : String = #function , lineNumber : Int = #line) {
        #if DEBUG
        LLDebugTool.shared().log(inFile: (file as NSString).lastPathComponent, function: function, lineNo: lineNumber, level: LLConfigLogLevel.alert, onEvent: event, message: message)
        #endif
    }
    
    /// Log a warning message.
    public static func warningLog(message : String? , file : String = #file , function : String = #function , lineNumber : Int = #line) {
        #if DEBUG
        LLDebugTool.shared().log(inFile: (file as NSString).lastPathComponent, function: function, lineNo: lineNumber, level: LLConfigLogLevel.warning, onEvent: nil, message: message)
        #endif
    }
    
    /// Log a warning message with event.
    public static func warningLog(message : String? , event : String? , file : String = #file , function : String = #function , lineNumber : Int = #line) {
        #if DEBUG
        LLDebugTool.shared().log(inFile: (file as NSString).lastPathComponent, function: function, lineNo: lineNumber, level: LLConfigLogLevel.warning, onEvent: event, message: message)
        #endif
    }
    
    /// Log a error message.
    public static func errorLog(message : String? , file : String = #file , function : String = #function , lineNumber : Int = #line) {
        #if DEBUG
        LLDebugTool.shared().log(inFile: (file as NSString).lastPathComponent, function: function, lineNo: lineNumber, level: LLConfigLogLevel.error, onEvent: nil, message: message)
        #endif
    }
    
    /// Log a error message with event.
    public static func errorLog(message : String? , event : String? , file : String = #file , function : String = #function , lineNumber : Int = #line) {
        #if DEBUG
        LLDebugTool.shared().log(inFile: (file as NSString).lastPathComponent, function: function, lineNo: lineNumber, level: LLConfigLogLevel.error, onEvent: event, message: message)
        #endif
    }
    
}
