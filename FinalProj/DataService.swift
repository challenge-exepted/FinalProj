//
//  DataService.swift
//  FinalProj
//
//  Created by Lucy Chebotar on 6/10/18.
//  Copyright © 2018 Lucy Chebotar. All rights reserved.
//

import Foundation
import UIKit

class DataService{
    let baseUrlString: String = "https://api.flightradar24.com/common/v1/airport.json"
    var scheduleDictionary = [String : Any]()
    var airport = Airport()
    
    init(){}

    func getData(completion: @escaping () -> Void){
        let timestamp = NSDate().timeIntervalSince1970
        let urlString = baseUrlString + "?code=\(airport.code)&plugin-setting[schedule][timestamp]=\(timestamp)&page=1&limit=100"
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            if let error = error {
                print(error.localizedDescription)
            }else if let data = data{
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                  guard let jsonDict = json as? [String : Any],
                        let resultDict = jsonDict["result"] as? [String : Any],
                        let responseDict = resultDict["response"] as? [String : Any],
                        let airportDict = responseDict["airport"] as? [String : Any],
                        let pluginDataDict = airportDict["pluginData"] as? [String : Any],
                        let scheduleDict = pluginDataDict["schedule"] as? [String : Any]
                        else {return}
                    self.scheduleDictionary = scheduleDict
                } catch {
                    print(error.localizedDescription)
                }
            }
            completion()
        }.resume()
    }
    
    func getDeparturesData()->[FlightInfo] {
        guard let departuresDict = scheduleDictionary["departures"] as? [String : Any],
            let dataArray = departuresDict["data"] as? [[String : Any]]
            else {return [] }
        var depatruresInfoArray = [FlightInfo]()
        for flightDict in dataArray{
            guard let flight = flightDict["flight"] as? [String : Any],
                let identificationDict = flight["identification"] as? [String : Any],
                let numberDict = identificationDict["number"] as? [String : Any],
                let defaultFlightCode = numberDict["default"] as? String, //FLIGHT CODE HERE!
                let statusDict = flight["status"] as? [String : Any],
                let statusText = statusDict["text"] as? String, //STATUS TEXT HERE!
                let airlineDict = flight["airline"] as? [String : Any],
                let airlineName = airlineDict["name"] as? String, // AIRLINE NAME HERE!
                let airportDict = flight["airport"] as? [String : Any],
                let destinationDict = airportDict["destination"] as? [String : Any],
                let destinationAirportName = destinationDict["name"] as? String, //DESTINATION AIRPORT NAME HERE!
                let codeDict = destinationDict["code"] as? [String : Any],
                let iataAirportCode = codeDict["iata"] as? String, //IATA CODE HERE
                let positionDict = destinationDict["position"] as? [String : Any],
                let countryDict = positionDict["country"] as? [String : Any],
                let destinationCountryName = countryDict["name"] as? String, //DESTINATION COUNTRY NAME HERE!
                let regionDict = positionDict["region"] as? [String : Any],
                let destinationCityName = regionDict["city"] as? String, //DESTINATION CITY NAME HERE!
                let timeDict = flight["time"] as? [String : Any],
                let scheduledDict = timeDict["scheduled"] as? [String : Any],
                let departureTimeDouble = scheduledDict["departure"] as? Double, //DEPARTURE TIME DOUBLE HERE
                let arrivalTimeDouble = scheduledDict["arrival"] as? Double //ARRIVAL TIME DOUBLE HERE
            else {return []}
            let departureInformation = FlightInfo()
            departureInformation.flightCode = defaultFlightCode
            departureInformation.status = statusText
            departureInformation.airline = airlineName
            departureInformation.destinationAirport = destinationAirportName
            departureInformation.destinationAirportCode = iataAirportCode
            departureInformation.destinationCountry = destinationCountryName
            departureInformation.destinationCity = destinationCityName
            let currentDate = Date()
            let calendar = Calendar.current
            let currentComponents = calendar.dateComponents([.day], from: currentDate)
            let currentDay = currentComponents.day
            let departureDate = Date(timeIntervalSince1970: departureTimeDouble)
            let dateComponents = calendar.dateComponents([.day], from: departureDate)
            let departureDay = dateComponents.day
            if departureDay != currentDay{
                continue
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let departureTime = dateFormatter.string(from: departureDate)
            departureInformation.timeStart = departureTime
            let arrivalDate = Date(timeIntervalSince1970: arrivalTimeDouble)
            let arrivalTime = dateFormatter.string(from: arrivalDate)
            departureInformation.timeEnd = arrivalTime
            departureInformation.departOrArrive = "D"
            departureInformation.originCity = airport.city
            departureInformation.originCountry = airport.country
            departureInformation.originAirport = airport.name
            departureInformation.originAirportCode = airport.code
            depatruresInfoArray.append(departureInformation)
        }
        return depatruresInfoArray
    }
    
    func getArrivalsData()->[FlightInfo] {
        guard let arrivalsDict = scheduleDictionary["arrivals"] as? [String : Any],
            let dataArray = arrivalsDict["data"] as? [[String : Any]]
            else {return []}
        var arrivalsInfoArray = [FlightInfo]()
        for flightDict in dataArray{
            guard let flight = flightDict["flight"] as? [String : Any],
                let identificationDict = flight["identification"] as? [String : Any],
                let numberDict = identificationDict["number"] as? [String : Any],
                let defaultFlightCode = numberDict["default"] as? String, //FLIGHT CODE HERE!
                let statusDict = flight["status"] as? [String : Any],
                let statusText = statusDict["text"] as? String, //STATUS TEXT HERE!
                let airlineDict = flight["airline"] as? [String : Any],
                let airlineName = airlineDict["name"] as? String, // AIRLINE NAME HERE!
                let airportDict = flight["airport"] as? [String : Any],
                let originDict = airportDict["origin"] as? [String : Any],
                let originAirportName = originDict["name"] as? String, //ORIGIN AIRPORT NAME HERE!
                let codeDict = originDict["code"] as? [String : Any],
                let iataAirportCode = codeDict["iata"] as? String, //IATA CODE HERE
                let positionDict = originDict["position"] as? [String : Any],
                let countryDict = positionDict["country"] as? [String : Any],
                let originCountryName = countryDict["name"] as? String, //ORIGIN COUNTRY NAME HERE!
                let regionDict = positionDict["region"] as? [String : Any],
                let originCityName = regionDict["city"] as? String, //ORIGIN CITY NAME HERE!
                let timeDict = flight["time"] as? [String : Any],
                let scheduledDict = timeDict["scheduled"] as? [String : Any],
                let departureTimeDouble = scheduledDict["departure"] as? Double, //DEPARTURE TIME DOUBLE HERE
                let arrivalTimeDouble = scheduledDict["arrival"] as? Double //ARRIVAL TIME DOUBLE HERE
            else {return []}
            let arrivalInformation = FlightInfo()
            arrivalInformation.flightCode = defaultFlightCode
            arrivalInformation.status = statusText
            arrivalInformation.airline = airlineName
            arrivalInformation.originAirport = originAirportName
            arrivalInformation.originAirportCode = iataAirportCode
            arrivalInformation.originCountry = originCountryName
            arrivalInformation.originCity = originCityName
            let currentDate = Date()
            let calendar = Calendar.current
            let currentComponents = calendar.dateComponents([.day], from: currentDate)
            let currentDay = currentComponents.day
            let arrivalDate = Date(timeIntervalSince1970: arrivalTimeDouble)
            let dateComponents = calendar.dateComponents([.day], from: arrivalDate)
            let arrivalDay = dateComponents.day
            if arrivalDay != currentDay{
                continue
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let arrivalTime = dateFormatter.string(from: arrivalDate)
            let departureDate = Date(timeIntervalSince1970: departureTimeDouble)
            let departureTime = dateFormatter.string(from: departureDate)
            arrivalInformation.timeStart = departureTime
            arrivalInformation.timeEnd = arrivalTime
            arrivalInformation.departOrArrive = "A"
            arrivalInformation.destinationCountry = airport.country
            arrivalInformation.destinationCity = airport.city
            arrivalInformation.destinationAirport = airport.name
            arrivalInformation.destinationAirportCode = airport.code
            arrivalsInfoArray.append(arrivalInformation)
        }
        return arrivalsInfoArray
    }
}
