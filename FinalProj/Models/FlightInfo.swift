//
//  FlightInfo.swift
//  FinalProj
//
//  Created by Lucy Chebotar on 6/5/18.
//  Copyright © 2018 Lucy Chebotar. All rights reserved.
//

import Foundation
import RealmSwift
import Realm


class FlightInfo: Object{
    @objc dynamic var flightCode: String = ""
    @objc dynamic var originAirport: String = ""
    @objc dynamic var originCountry: String = ""
    @objc dynamic var originCity: String = ""
    @objc dynamic var originAirportCode: String = ""
    
    @objc dynamic var destinationAirport: String = ""
    @objc dynamic var destinationCity: String = ""
    @objc dynamic var destinationCountry: String = ""
    @objc dynamic var destinationAirportCode: String = ""
    
    @objc dynamic var timeStart: String = ""
    @objc dynamic var timeEnd: String = ""
    
    @objc dynamic var status: String = ""
    @objc dynamic var airline: String = ""
    @objc dynamic var departOrArrive: String = ""
    
   
    init(flightCode: String, originAirport: String, timeStart: String, departOrArrive: String) {
        self.flightCode = flightCode
        self.originAirport = originAirport
        self.timeStart = timeStart
        self.departOrArrive = departOrArrive
        
         super.init()
    }
    
    init(flightCode: String, originAirport: String, originCountry: String,
         originCity: String, originAirportCode: String, destinationAirport: String,
         destinationCity: String, destinationCountry: String, destinationAirportCode: String,
         timeStart: String, timeEnd: String, status: String, airline: String, departOrArrive: String){
            self.flightCode = flightCode
            self.originAirport = originAirport
            self.originCountry = originCountry
            self.originCity = originCity
            self.originAirportCode = originAirportCode
            self.destinationAirport = destinationAirport
            self.destinationCity = destinationCity
            self.destinationCountry = destinationCountry
            self.destinationAirportCode = destinationAirportCode
            self.timeStart = timeStart
            self.timeEnd = timeEnd
            self.status = status
            self.airline = airline
            self.departOrArrive = departOrArrive
        
         super.init()
    }
    
    required init(){
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}
