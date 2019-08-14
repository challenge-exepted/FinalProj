//
//  SearchViewController.swift
//  FinalProj
//
//  Created by Lucy Chebotar on 5/27/18.
//  Copyright © 2018 Lucy Chebotar. All rights reserved.
//

import UIKit
import Lottie

class SearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
   
    @IBOutlet private weak var airportTextField: UITextField!
    @IBOutlet private weak var cityTextField: UITextField!
    @IBOutlet private weak var countryTextField: UITextField!
    @IBOutlet private weak var greetingLabel: UILabel!
    @IBOutlet private weak var okButton: UIButton!

    private let pickerViewAirport = UIPickerView()
    private let pickerViewCity = UIPickerView()
    private let pickerViewCountry = UIPickerView()

    let airportArray = AirportDataProvider.AirportsData
    
    var countriesArray = [String]()
    var citiesArray = [String]()
    var airportsArray = [String]()
    
    var selectedCountry: String = ""
    var selectedCity: String = ""
    var selectedAirport: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countriesArray = getSetOfCountries()
        setupUI()
    }

    private func setupUI(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        countryTextField.placeholder = "Select country"
        cityTextField.placeholder = "Select city"
        airportTextField.placeholder = "Select airport"
        
        cityTextField.isUserInteractionEnabled = false
        airportTextField.isUserInteractionEnabled = false

        pickerViewAirport.backgroundColor = .white
        pickerViewCity.backgroundColor = .white
        pickerViewCountry.backgroundColor = .white
        
            
        //Transparent navigation bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        
        //Gradient backround of the view controller
        setGradientBackground()
        
        airportTextField.inputView = pickerViewAirport
        pickerViewAirport.delegate = self
        
        cityTextField.inputView = pickerViewCity
        pickerViewCity.delegate = self
        
        countryTextField.inputView = pickerViewCountry
        pickerViewCountry.delegate = self
        
        airportTextField.delegate = self
        cityTextField.delegate = self
        countryTextField.delegate = self
        
        countryTextField.inputAccessoryView = makeToolbar(type: .next, tag: TextField.country.rawValue, title: "Choose country")
        cityTextField.inputAccessoryView = makeToolbar(type: .next, tag: TextField.city.rawValue, title: "Choose city")
        airportTextField.inputAccessoryView = makeToolbar(type: .done, tag: TextField.airport.rawValue, title: "Choose airport")

        let animationView = LOTAnimationView(name: "airplane_flying")
        var frameForIphone = CGRect()
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1334: //"iPhone 6/6S/7/8"
                frameForIphone = CGRect(x: 100, y: 180, width: 180, height: 180)
            case 1920, 2208: //iPhone 6+/6S+/7+/8+
                frameForIphone = CGRect(x: 110, y: 220, width: 200, height: 200)
            case 2436: //iPhone X
                frameForIphone = CGRect(x: 80, y: 220, width: 230, height: 230)
            default: //no animation on a small screen, too sad
                frameForIphone = CGRect(x: 0, y: 0, width: 0, height: 0)
            }
        }
        animationView.frame = frameForIphone
        animationView.contentMode = .scaleAspectFill
        view.addSubview(animationView)
        animationView.play()
        animationView.loopAnimation = true
    }
    
    private func makeToolbar(type: TypingResultButtonType, tag: Int, title: String) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.barTintColor = .white
        
        let doneButton = UIBarButtonItem(title: type.rawValue, style: .done, target: nil, action: #selector(doneAction))
        doneButton.tag = tag
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.sizeToFit()
        let titleBarButtomItem = UIBarButtonItem.init(customView: titleLabel)
        toolbar.items = [titleBarButtomItem, flexibleItem, doneButton]
        toolbar.sizeToFit()
        return toolbar
   }
    
    @objc private func doneAction(sender: UIBarButtonItem) {
        guard let textField = TextField(rawValue: sender.tag) else { return }
        switch textField {
            case .country:
                let row = pickerViewCountry.selectedRow(inComponent: 0)
                countryTextField.text = countriesArray[row]
                selectedCountry = countriesArray[row]
                citiesArray = getSetOfCities()
                cityTextField.isUserInteractionEnabled = true
                cityTextField.text = ""
                airportTextField.text = ""

                view.endEditing(true)
            case .city:
                let row = pickerViewCity.selectedRow(inComponent: 0)
                cityTextField.text = citiesArray[row]
                selectedCity = citiesArray[row]
                airportsArray = getSetOfAirports()
                airportTextField.isUserInteractionEnabled = true
                 airportTextField.text = ""

                view.endEditing(true)
            case .airport:
                let row = pickerViewAirport.selectedRow(inComponent: 0)
                airportTextField.text = airportsArray[row]
                selectedAirport = airportsArray[row]
                view.endEditing(true)
        }
    }
    
    //Gradient backround of the view controller
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255/255, green: 94/255, blue: 58/255, alpha: 0.9).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func alert (title: String, message: String){
        let alert = UIAlertController(title: title, message: message , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - UI Picker View Delegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView{
        case pickerViewAirport:
            return airportsArray[row]
        case pickerViewCity:
            return citiesArray[row]
        case pickerViewCountry:
            return countriesArray[row]
        default: return ""
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var currentRow: String = ""
        switch pickerView{
        case pickerViewAirport:
            currentRow = airportsArray[row]
        case pickerViewCity:
            currentRow = citiesArray[row]
        case pickerViewCountry:
            currentRow = countriesArray[row]
        default: currentRow = ""
        }
            
        let pickerLabel = UILabel()
        
        if pickerView.selectedRow(inComponent: 0) == row {
            pickerLabel.attributedText = NSAttributedString(string: currentRow, attributes:[NSAttributedStringKey.font:UIFont(name: "GillSans", size: 24.0)!, NSAttributedStringKey.foregroundColor: UIColor.black])
        } else {
            pickerLabel.attributedText = NSAttributedString(string: currentRow, attributes: [NSAttributedStringKey.font:UIFont(name: "GillSans", size: 22.0)!, NSAttributedStringKey.foregroundColor: UIColor.black])
        }
        let color = UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 0.5)
        pickerLabel.textAlignment = .center
        pickerLabel.backgroundColor = color
        return pickerLabel
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView{
        case pickerViewAirport:
            return airportsArray.count
        case pickerViewCity:
            return citiesArray.count
        case pickerViewCountry:
            return countriesArray.count
        default: return 1
        }
    }

    //MARK: - Arrays for picker
    func getSetOfCountries()->[String]{
        var setOfCountries = [String]()
        for airport in airportArray {
            setOfCountries.append(airport.country)
        }
        setOfCountries = Array(Set(setOfCountries))
        return setOfCountries
    }
    
    func getSetOfCities()->[String]{
        var setOfCities = [String]()
        for airport in airportArray{
            if airport.country == selectedCountry{
                setOfCities.append(airport.city)
            }
        }
        setOfCities = Array(Set(setOfCities))
        return setOfCities
    }
    
    func getSetOfAirports()->[String]{
        var setOfAirports = [String]()
        for airport in airportArray{
            if airport.city == selectedCity{
                setOfAirports.append(airport.name)
            }
        }
        setOfAirports = Array(Set(setOfAirports))
        return setOfAirports
    }

    func getAirport()->Airport{
        for airport in airportArray{
            if airport.name == selectedAirport{
                return airport
            }
        }
        return Airport()
    }
     //MARK: - Passing data to the next screnn
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ResultsViewController
        {
            let access  = segue.destination as? ResultsViewController
            access?.titleOfScreen = selectedAirport
            access?.airport = getAirport()
        }
    }
    //MARK: - Actions
    @IBAction func toTheResults(_ sender: Any) {
        if !(airportTextField.text?.isEmpty)! {
        performSegue(withIdentifier: "goToResults", sender: nil)
        } else {
            alert(title: "Oopsy!", message: "Please, fill all fields")
        }
    }
    //MARK: - Enums
    private enum TypingResultButtonType: String {
        case next = "Next"
        case done = "Done"
    }
    private enum TextField: Int {
        case country = 9, city, airport
    }
}

