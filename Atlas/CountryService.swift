//
//  CountryService.swift
//  Atlas
//
//  Created by Admin on 8/1/17.
//  Copyright © 2017 Admin. All rights reserved.
//
import UIKit
import Foundation

final class CountryService {
    
    static let sharedCountryService = CountryService()
    
    typealias JSONArray = [[String: Any]]
    typealias CountriesResult = ([Country]?, String) -> ()
    typealias SingleCountryResult = (Country?, String) -> ()

    var errorMessage = ""
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    fileprivate func makeRequest(url: URL, onCompletion: @escaping (Data?, String) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        dataTask = defaultSession.dataTask(with: url) { [unowned self] data, response, error in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let error = error {
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                onCompletion(data, self.errorMessage)
            } else {
                onCompletion(nil, self.errorMessage)
            }
        }
    }
    
    func getCountries(_ url: String, onCompletion: @escaping CountriesResult) {
        dataTask?.cancel()
        if let url = URL(string: url) {
            makeRequest(url: url) { [unowned self] data, error in
                defer { self.dataTask = nil }
                if let data = data, let countries = self.parseCountries(data) {
                    DispatchQueue.main.async {
                        onCompletion(countries, self.errorMessage)
                    }
                } else {
                    DispatchQueue.main.async {
                        onCompletion(nil, self.errorMessage)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    func getCountryByCode(_ code: String, completion: @escaping SingleCountryResult) {
        dataTask?.cancel()
        if let url = URL(string: "https://restcountries.eu/rest/v2/alpha/\(code)") {
            makeRequest(url: url) { [unowned self] data, error in
                defer { self.dataTask = nil }
                if let data = data, let country = self.parseCountry(data) {
                    DispatchQueue.main.async {
                        completion(country, self.errorMessage)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, self.errorMessage)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    fileprivate func doSerialization(with data: Data) -> Any? {
        let result: Any?
        do {
            result = try JSONSerialization.jsonObject(with: data, options: [])
            return result!
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return nil
        }
        
    }
    
    fileprivate func parseCountries(_ data: Data) -> [Country]? {
        var result: [Country] = []
        
        if let response = doSerialization(with: data) as? JSONArray {
            for item in response {
                if let flagURLString = item["flag"] as? String,
                    let name = item["name"] as? String,
                    let nativeName = item["nativeName"] as? String,
                    let alpha3Code = item["alpha3Code"] as? String {
                    result.append(Country(name: name, nativeName: nativeName, flag: flagURLString, alpha3Code: alpha3Code))
                } else {
                    errorMessage += "Problem parsing countryDictionary\n"
                }
            }
        }
        return result.isEmpty ? nil : result
    }
    
    
    
    fileprivate func parseCountry(_ data: Data) -> Country? {
        
        if let response = doSerialization(with: data) as? [String: Any] {
            var currenciesResult: [String] = []
            var languagesResult: [String] = []
            
            if let flagURLString = response["flag"] as? String,
                let name = response["name"] as? String,
                let nativeName = response["nativeName"] as? String,
                let alpha3Code = response["alpha3Code"] as? String,
                let latlng = response["latlng"] as? [Double],
                let borders = response["borders"] as? [String],
                let currencies = response["currencies"] as? [[String: Any]],
                let languages = response["languages"] as? [[String: Any]] {
                languagesResult = languages.flatMap { language in language["name"] as? String }
                currenciesResult = currencies.flatMap { currency in currency["name"] as? String }
//                for currency in currencies {
//                    currenciesResult.append(currency["name"] as! String)
//                }
//                for language in languages {
//                    languagesResult.append(language["name"] as! String)
//                }
                return Country(name: name, nativeName: nativeName, flag: flagURLString, latlng: latlng, currencies: currenciesResult, languages: languagesResult, borders: borders, alpha3Code: alpha3Code)
            } else {
                errorMessage += "Problem parsing countryDictionary\n"
            }
        }
        return nil
    }
    
    
}
