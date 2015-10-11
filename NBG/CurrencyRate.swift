//
//  CurrencyRate.swift
//  NBG
//
//  Created by David Chadranyan on 10/5/15.
//  Copyright © 2015 David Chadranyan. All rights reserved.
//

import UIKit


class CurrencyRate : NSObject{
    
    override init()
    {
        
    }
    
    init(currencyName : String , currencyRate : String,currencyCode : String?,currencyRateChangeValue : String?,increase : Bool?){
        self.currencyCode = currencyCode;
        self.currencyName = currencyName;
        self.currencyRate = currencyRate;
        self.currencyRateChangeValue = currencyRateChangeValue;
        self.increase = increase;
    }
    
    var currencyName : String?
    var currencyRate : String?
    var currencyCode : String?
    var currencyRateChangeValue : String?
    var increase : Bool?
}
