//
//  Result.swift
//  BKD
//
//  Created by Karine Karapetyan on 31-05-21.
//

import UIKit

class State<T>: NSObject {
    
    class Loading: State<T> {}
    
    class Success: State<T> {
        let data: T
        
        init(data: T) {
            self.data = data
        }
    }
    
    class Error: State<T> {
        let message: String
        
        init(message: String) {
            self.message = message
        }
    }
    
    static func loading() -> State<T> {
        return State.Loading()
    }
    
    static func success(data: T) -> State<T> {
        return State.Success(data: data)
    }
    
    static func error(message: String) -> State<T> {
        return State.Error(message: message)
    }
}
