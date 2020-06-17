//
//  Requests.swift
//  RSS Reader
//
//  Created by Михаил Маслов on 17.06.2020.
//  Copyright © 2020 Михаил Маслов. All rights reserved.
//

import Alamofire
import SWXMLHash

class Requests {
    
    var newsArr = [String]() ///  Заголовки новостей
    var news: String? /// Заголовок новости
    var dateNews = [String]() /// Даты новостей
    var newsFullTextArr = [String]() /// Полный текст новостей
    var imageNews: String? /// Изображение новости
    var imagesArr = [String]() /// Изоюражения новостей
    var newsFullText: String? /// Полный текст новости
    
    func clearCache(){
        newsArr = [String]()
        dateNews = [String]()
        imageNews = nil
        imagesArr = [String]()
        newsFullTextArr = [String]()
        URLCache.shared.removeAllCachedResponses()
    }
    
    func getNews(){
        clearCache()
        /// Запрос к источнику с
        let _ = Alamofire.request("http://www.vesti.ru/vesti.rss", method: .get).response {
            response in
            if let data = response.data {
                let xml = SWXMLHash.parse(data)
                
                /// Получение заголовка
                self.newsArr = (xml["rss"]["channel"]["item"].all.map{ elem in
                    elem["title"].element!.text
                })
                
                /// Получение полного текста
                self.newsFullTextArr = (xml["rss"]["channel"]["item"].all.map{ elem in
                    elem["yandex:full-text"].element!.text
                })
                
                /// Получение дат публикаций
                self.dateNews = (xml["rss"]["channel"]["item"].all.map{ elem in
                    try! elem["pubDate"].value()
                })
                
                /// Получение изображений
                for elem in xml["rss"]["channel"]["item"].all {
                    for i in elem["enclosure"].all {
                        self.imageNews = i.element?.attribute(by: "url")?.text
                    }
                    self.imagesArr.append(self.imageNews ?? "")
                }
            }
        }
    }
    
    func socFilter() {
        clearCache()
        let _ = Alamofire.request("http://www.vesti.ru/vesti.rss", method: .get).response {
            response in
            if let data = response.data {
                let xml = SWXMLHash.parse(data)
                for elem in xml["rss"]["channel"]["item"].all {
                    let elem = elem
                        .filterChildren { _, index in index == 3 || index == 5 || index == 4 || index == 6 || index == 7
                    }
                    let elemCat = elem["category"].element!.text
                    if (elemCat.contains("Общество")) {
                        print(elem)
                        self.newsFullText = elem["yandex:full-text"].element?.text
                        self.news = elem["description"].element?.text
                        self.dateNews = (xml["rss"]["channel"]["item"].all.map{ elem in
                            try! elem["pubDate"].value()
                        })
                        for i in elem["enclosure"].all {
                            self.imageNews = i.element?.attribute(by: "url")?.text
                        }
                        
                        self.imagesArr.append(self.imageNews ?? "")
                        self.newsArr.append(self.news ?? "")
                        self.newsFullTextArr.append(self.newsFullText ?? "")
                    }
                }
            }
        }
    }
    
    func sportFilter() {
        clearCache()
        let _ = Alamofire.request("http://www.vesti.ru/vesti.rss", method: .get).response {
            response in
            if let data = response.data {
                let xml = SWXMLHash.parse(data)
                for elem in xml["rss"]["channel"]["item"].all {
                    let elem = elem
                        .filterChildren { _, index in index == 3 || index == 5 || index == 4 || index == 6 || index == 7
                    }
                    let elemCat = elem["category"].element!.text
                    if (elemCat.contains("Спорт")) {
                        print(elem)
                        self.newsFullText = elem["yandex:full-text"].element?.text
                        self.news = elem["description"].element?.text
                        self.dateNews = (xml["rss"]["channel"]["item"].all.map{ elem in
                            try! elem["pubDate"].value()
                        })
                        for i in elem["enclosure"].all {
                            self.imageNews = i.element?.attribute(by: "url")?.text
                        }
                        
                        self.imagesArr.append(self.imageNews ?? "")
                        self.newsArr.append(self.news ?? "")
                        self.newsFullTextArr.append(self.newsFullText ?? "")
                    }
                }
            }
        }
    }
    
    func worldFilter() {
        clearCache()
        let _ = Alamofire.request("http://www.vesti.ru/vesti.rss", method: .get).response {
            response in
            if let data = response.data {
                let xml = SWXMLHash.parse(data)
                for elem in xml["rss"]["channel"]["item"].all {
                    let elem = elem
                        .filterChildren { _, index in index == 3 || index == 5 || index == 4 || index == 6 || index == 7
                    }
                    let elemCat = elem["category"].element!.text
                    if (elemCat.contains("В мире")) {
                        print(elem)
                        self.newsFullText = elem["yandex:full-text"].element?.text
                        self.news = elem["description"].element?.text
                        self.dateNews = (xml["rss"]["channel"]["item"].all.map{ elem in
                            try! elem["pubDate"].value()
                        })
                        for i in elem["enclosure"].all {
                            self.imageNews = i.element?.attribute(by: "url")?.text
                        }
                        
                        self.imagesArr.append(self.imageNews ?? "")
                        self.newsArr.append(self.news ?? "")
                        self.newsFullTextArr.append(self.newsFullText ?? "")
                    }
                }
            }
        }
    }
    
    func EcoFilter() {
        clearCache()
        let _ = Alamofire.request("http://www.vesti.ru/vesti.rss", method: .get).response {
            response in
            if let data = response.data {
                let xml = SWXMLHash.parse(data)
                for elem in xml["rss"]["channel"]["item"].all {
                    let elem = elem
                        .filterChildren { _, index in index == 3 || index == 5 || index == 4 || index == 6 || index == 7
                    }
                    let elemCat = elem["category"].element!.text
                    if (elemCat.contains("Экономика")) {
                        print(elem)
                        self.newsFullText = elem["yandex:full-text"].element?.text
                        self.news = elem["description"].element?.text
                        self.dateNews = (xml["rss"]["channel"]["item"].all.map{ elem in
                            try! elem["pubDate"].value()
                        })
                        for i in elem["enclosure"].all {
                            self.imageNews = i.element?.attribute(by: "url")?.text
                        }
                        
                        self.imagesArr.append(self.imageNews ?? "")
                        self.newsArr.append(self.news ?? "")
                        self.newsFullTextArr.append(self.newsFullText ?? "")
                    }
                }
            }
        }
    }
    func inciFilter() {
        let _ = Alamofire.request("http://www.vesti.ru/vesti.rss", method: .get).response {
            response in
            if let data = response.data {
                let xml = SWXMLHash.parse(data)
                for elem in xml["rss"]["channel"]["item"].all {
                    let elem = elem
                        .filterChildren { _, index in index == 3 || index == 5 || index == 4 || index == 6 || index == 7
                    }
                    let elemCat = elem["category"].element!.text
                    if (elemCat.contains("Происшествия")) {
                        print(elem)
                        self.newsFullText = elem["yandex:full-text"].element?.text
                        self.news = elem["description"].element?.text
                        self.dateNews = (xml["rss"]["channel"]["item"].all.map{ elem in
                            try! elem["pubDate"].value()
                        })
                        for i in elem["enclosure"].all {
                            self.imageNews = i.element?.attribute(by: "url")?.text
                        }
                        
                        self.imagesArr.append(self.imageNews ?? "")
                        self.newsArr.append(self.news ?? "")
                        self.newsFullTextArr.append(self.newsFullText ?? "")
                    }
                }
            }
        }
    }
    
    func techFilter() {
        clearCache()
        let _ = Alamofire.request("http://www.vesti.ru/vesti.rss", method: .get).response {
            response in
            if let data = response.data {
                let xml = SWXMLHash.parse(data)
                for elem in xml["rss"]["channel"]["item"].all {
                    let elem = elem
                        .filterChildren { _, index in index == 3 || index == 5 || index == 4 || index == 6 || index == 7
                    }
                    let elemCat = elem["category"].element!.text
                    if (elemCat.contains("Hi-Tech")) {
                        print(elem)
                        self.newsFullText = elem["yandex:full-text"].element?.text
                        self.news = elem["description"].element?.text
                        self.dateNews = (xml["rss"]["channel"]["item"].all.map{ elem in
                            try! elem["pubDate"].value()
                        })
                        for i in elem["enclosure"].all {
                            self.imageNews = i.element?.attribute(by: "url")?.text
                        }
                        
                        self.imagesArr.append(self.imageNews ?? "")
                        self.newsArr.append(self.news ?? "")
                        self.newsFullTextArr.append(self.newsFullText ?? "")
                    }
                }
            }
        }
    }
}
