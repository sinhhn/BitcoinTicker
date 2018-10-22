//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by ホアンゴックシン on 2018/10/21.
//  Copyright © 2018 vnguider. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""
    
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        getBitcoinData(URL: finalURL)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
    func getBitcoinData(URL: String) {
        Alamofire.request(URL, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("Got Bitcoin Data")
                let bitcoinData: JSON = JSON(response.result.value!)
                self.updateBitcoinData(json: bitcoinData)
            } else {
                print("Error \(String(describing: response.result.error))")
                self.bitcoinPriceLabel.text = "Connection Issues"
            }
        }
    }
    
    func updateBitcoinData(json: JSON) {
        if let bitcointResult = json["averages"]["day"].double {
            bitcoinPriceLabel.text = String(bitcointResult)
        } else {
            print("Price Unavailable")
            bitcoinPriceLabel.text = "Price Unavailable"
        }
    }

}

