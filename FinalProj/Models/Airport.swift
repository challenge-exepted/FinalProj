//
//  Airport.swift
//  FinalProj
//
//  Created by Lucy Chebotar on 5/29/18.
//  Copyright © 2018 Lucy Chebotar. All rights reserved.
//

import Foundation

class Airport{
    var name: String = ""
    var country: String = ""
    var city: String = ""
    var code: String = ""
    
    init(name:String, country:String, city:String, code: String) {
        self.name = name
        self.city = city
        self.country = country
        self.code = code
    }
    init(){}
}
