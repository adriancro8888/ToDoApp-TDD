//
//  String+Extensions.swift
//  ToDoApp_TDD
//
//  Created by Felix Titov on 6/27/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Foundation

extension String {
    var percentEncoded: String {
        let allowedCharacters = CharacterSet(charactersIn: "~!@#$%^&*()-+=[]\\}{,./?><").inverted
        guard let encodedString = self.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
            fatalError()
        }
        
        return encodedString
    }
}
