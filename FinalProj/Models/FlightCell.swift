//
//  FlightCell.swift
//  FinalProj
//
//  Created by Lucy Chebotar on 6/5/18.
//  Copyright © 2018 Lucy Chebotar. All rights reserved.
//

import UIKit

class FlightCell: UITableViewCell {

    @IBOutlet weak var flightCode: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var plainDirection: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }


    private func setupUI(){
        backgroundColor = .clear
    }
    func configure(information: FlightInfo){
        flightCode.text = information.flightCode
        if information.departOrArrive == "D"{
            destination.text = information.destinationCity
             let departureImage = UIImage(named: "departure")
            plainDirection.image = departureImage
            time.text = information.timeStart
        } else {
            destination.text = information.originCity
            let arrivalImage = UIImage(named: "arrival")
            plainDirection.image = arrivalImage
            time.text = information.timeEnd
        }
    }
}
    

