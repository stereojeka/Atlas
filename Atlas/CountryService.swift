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
    typealias SingleCountryResult = (Country, String) -> ()
    
    var countries: [Country] = []
    var singleCountry: Country!
    var errorMessage = ""
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    fileprivate func makeRequest(url: URL, onCompletion: @escaping (Data?, Error?) -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                onCompletion(data, error)
            } else {
                onCompletion(nil, error)
            }
        }
    }
    
    func getCountries(_ url: String, onCompletion: @escaping CountriesResult) {
        dataTask?.cancel()
        if let urlComponents = URLComponents(string: url) {
            guard let url = urlComponents.url else { return }
            makeRequest(url: url) { [unowned self] data, error in
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data {
                    self.updateCountries(data)
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        onCompletion(self.countries, self.errorMessage)
                    }
                } else {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        onCompletion(nil, self.errorMessage)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    func getCountryByCode(_ code: String, completion: @escaping SingleCountryResult) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: "https://restcountries.eu/rest/v2/alpha/\(code)") {
            guard let url = urlComponents.url else { return }
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            dataTask = defaultSession.dataTask(with: url) { [unowned self] data, response, error in
                defer { self.dataTask = nil }
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.updateCountry(data)
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        completion(self.singleCountry, self.errorMessage)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    fileprivate func updateCountries(_ data: Data) {
        var response: JSONArray?
        countries.removeAll()
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONArray
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        for item in response! {
            if let flagURLString = item["flag"] as? String,
                let name = item["name"] as? String,
                let nativeName = item["nativeName"] as? String,
                let alpha3Code = item["alpha3Code"] as? String {
                countries.append(Country(name: name, nativeName: nativeName, flag: flagURLString, alpha3Code: alpha3Code))
            } else {
                errorMessage += "Problem parsing countryDictionary\n"
            }
        }
        
    }
    
    fileprivate func updateCountry(_ data: Data) {
        var response: [String: Any]?
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        var currenciesResult: [String] = []
        var languagesResult: [String] = []
        
        if let flagURLString = response?["flag"] as? String,
            let name = response?["name"] as? String,
            let nativeName = response?["nativeName"] as? String,
            let alpha3Code = response?["alpha3Code"] as? String,
            let latlng = response?["latlng"] as? [Double],
            let borders = response?["borders"] as? [String],
            let currencies = response?["currencies"] as? [[String: Any]],
            let languages = response?["languages"] as? [[String: Any]] {
            for currency in currencies {
                currenciesResult.append(currency["name"] as! String)
            }
            for language in languages {
                languagesResult.append(language["name"] as! String)
            }
            singleCountry = Country(name: name, nativeName: nativeName, flag: flagURLString, latlng: latlng, currencies: currenciesResult, languages: languagesResult, borders: borders, alpha3Code: alpha3Code)
        } else {
            errorMessage += "Problem parsing countryDictionary\n"
        }
    }
    
    
}
