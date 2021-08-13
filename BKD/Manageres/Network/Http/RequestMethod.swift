//
//  RequestMethod.swift
//  MimoBike
//
//  Created by Albert on 15.05.21.
//

import UIKit

enum RequestMethod: String {
    case put = "PUT"
    case post = "POST"
    case get = "GET"
    case delete = "DELETE"
    case patch = "PATCH"
}


enum SearchOperation: String {
    case equals = "EQUALS"
    case more = "MORE"
    case less = "LESS"
    case after = "AFTER"
    case before = "BEFORE"
    case between = "BETWEEN"
    case interval = "INTERVAL"
    case like = "LIKE"
    case exist = "EXIST"
    case In = "IN"
}
