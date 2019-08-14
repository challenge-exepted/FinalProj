//
//  InformationViewController.swift
//  FinalProj
//
//  Created by Lucy Chebotar on 6/8/18.
//  Copyright © 2018 Lucy Chebotar. All rights reserved.
//

import UIKit
import RealmSwift
import Realm


class InformationViewController: UIViewController {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var airlineLabel: UILabel!
    @IBOutlet weak var timeStartLabel: UILabel!
    @IBOutlet weak var timeEndLabel: UILabel!
    @IBOutlet weak var departureWord: UILabel!
    @IBOutlet weak var arrivalWord: UILabel!
    @IBOutlet weak var originAirportCodeLabel: UILabel!
    @IBOutlet weak var originCityLabel: UILabel!
    @IBOutlet weak var originCountryLabel: UILabel!
    @IBOutlet weak var destinationAirportCodeLabel: UILabel!
    @IBOutlet weak var destinationCityLabel: UILabel!
    @IBOutlet weak var destinationCountryLabel: UILabel!
    @IBOutlet weak var starLabel: UIButton!

    var flightInformation = FlightInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        do{
            let realm =  try Realm()
            let favObjects = Array(realm.objects(FlightInfo.self))
            if favObjects.contains(where: {flight in return flight.flightCode == flightInformation.flightCode}){
                starLabel.isHighlighted = true
            }else{
                self.starLabel.isHighlighted = false
            }
        }catch{
            print(error)
        }
    }

    private func  setupUI(){
        setGradientBackground()
        title = "Flight Information"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont(name: "GillSans", size: 20)!]
        statusLabel.text = "Status: \(flightInformation.status)"
        airlineLabel.text = "Airline: \(flightInformation.airline)"
        timeStartLabel.text = flightInformation.timeStart
        timeEndLabel.text = flightInformation.timeEnd
        originAirportCodeLabel.text = flightInformation.originAirportCode
        originCityLabel.text = flightInformation.originCity
        originCountryLabel.text = flightInformation.originCountry
        destinationAirportCodeLabel.text = flightInformation.destinationAirportCode
        destinationCityLabel.text = flightInformation.destinationCity
        destinationCountryLabel.text = flightInformation.destinationCountry
    }
   
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 0.7).cgColor
        let colorBottom = UIColor(red: 255/255, green: 94/255, blue: 58/255, alpha: 0.7).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }

    @IBAction func toStar(_ sender: Any) {
        print("!!!!!!\(Realm.Configuration.defaultConfiguration.fileURL)")
        do{
            let realm =  try Realm()
            let objects = Array(realm.objects(FlightInfo.self))
            let flights = objects.filter({ flight in return flight.flightCode == flightInformation.flightCode })
            if objects.contains(where: {flight in return flight.flightCode == flightInformation.flightCode}){
                try realm.write {
                    realm.delete(flightInformation)
                }
            }else{
                try realm.write {
                    realm.add(flightInformation)
                }
            }
        }catch{
            print(error)
        }
    }

}

