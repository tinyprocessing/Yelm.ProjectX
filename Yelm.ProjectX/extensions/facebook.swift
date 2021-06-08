//
//  facebook.swift
//  Yelm.ProjectX
//
//  Created by Michael Safir on 03.06.2021.
//

import Foundation
import FBSDKCoreKit



func logPurchase(price: Double, currency: String, parameters: [String: Any]) {
    if (fb){
        AppEvents.logPurchase(price, currency: currency, parameters: parameters)
    }
}
func logLocation() {
    if (fb){
        AppEvents.logEvent(.findLocation)
    }
}

func logAddToCartEvent(
    contentData: String,
    contentId: String,
    contentType: String,
    currency: String,
    price: Double
) {
    if (fb){
        let parameters = [
            AppEvents.ParameterName.content.rawValue: contentData,
            AppEvents.ParameterName.contentID.rawValue: contentId,
            AppEvents.ParameterName.contentType.rawValue: contentType,
            AppEvents.ParameterName.currency.rawValue: currency
        ]

        AppEvents.logEvent(.addedToCart, valueToSum: price, parameters: parameters)
    }
}

func logSearchEvent(
    contentType: String,
    contentData: String,
    contentId: String,
    searchString: String,
    success: Bool
) {
    if (fb){
        let parameters = [
            AppEvents.ParameterName.contentType.rawValue: contentType,
            AppEvents.ParameterName.content.rawValue: contentData,
            AppEvents.ParameterName.contentID.rawValue: contentId,
            AppEvents.ParameterName.searchString.rawValue: searchString,
            AppEvents.ParameterName.success.rawValue: NSNumber(value: success ? 1 : 0)
        ] as [String : Any]

        AppEvents.logEvent(.searched, parameters: parameters)
    }
}

func logSpendCreditsEvent(
    contentData: String,
    contentId: String,
    contentType: String,
    totalValue: Double
) {
    if (fb){
        let parameters = [
            AppEvents.ParameterName.content.rawValue: contentData,
            AppEvents.ParameterName.contentID.rawValue: contentId,
            AppEvents.ParameterName.contentType.rawValue: contentType
        ]

        AppEvents.logEvent(.spentCredits, valueToSum: totalValue, parameters: parameters)
    }
}


func logInitiateCheckoutEvent(
    contentData: String,
    contentId: String,
    contentType: String,
    numItems: Int,
    paymentInfoAvailable: Bool,
    currency: String,
    totalPrice: Double
) {
    if (fb){
        let parameters = [
            AppEvents.ParameterName.content.rawValue: contentData,
            AppEvents.ParameterName.contentID.rawValue: contentId,
            AppEvents.ParameterName.contentType.rawValue: contentType,
            AppEvents.ParameterName.numItems.rawValue: NSNumber(value:numItems),
            AppEvents.ParameterName.paymentInfoAvailable.rawValue: NSNumber(value: paymentInfoAvailable ? 1 : 0),
            AppEvents.ParameterName.currency.rawValue: currency
        ] as [String : Any]

        AppEvents.logEvent(.initiatedCheckout, valueToSum: totalPrice, parameters: parameters)
    }
}

func logViewContentEvent(
    contentType: String,
    contentData: String,
    contentId: String,
    currency: String,
    price: Double
) {
    if (fb){
        let parameters = [
            AppEvents.ParameterName.contentType.rawValue: contentType,
            AppEvents.ParameterName.content.rawValue: contentData,
            AppEvents.ParameterName.contentID.rawValue: contentId,
            AppEvents.ParameterName.currency.rawValue: currency
        ]

        AppEvents.logEvent(.viewedContent, valueToSum: price, parameters: parameters)
    }
}
