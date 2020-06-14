//
//  NewsController.swift
//  RSS Reader
//
//  Created by Михаил Маслов on 12.06.2020.
//  Copyright © 2020 Михаил Маслов. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash

class NewsController: UITableViewController {
    
    var news = [String]() ///  Новости
    var dateNews = [String]() /// Даты новостей
    var newsFullText = [String]() /// Полный текст новостей
    var imageNews: String? /// Изображение новости
    var arrImages = [String]() /// Изоюражения новостей
    var arrCategory = [String]() /// Категории новосткй
    var category: String? /// Категория новости
    
    let myrefreshcontrol: UIRefreshControl = {
        let refreshcontol = UIRefreshControl()
        refreshcontol.addTarget(self, action: #selector(refreshNews(sender:)), for: .valueChanged)
        refreshcontol.tintColor = .blue
        return refreshcontol
    }()
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNews()
        table.refreshControl = myrefreshcontrol
    }
    
    // MARK: - Table view data source
    
    
    @objc private func refreshNews(sender: UIRefreshControl) {
        getNews()
        sender.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCellId", for: indexPath) as! NewsCell
        cell.textNews.text = news[indexPath.row]
        cell.dateNews.text = dateNews[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewsDetail" {
            let indexPath = tableView.indexPathForSelectedRow
            let newVC: DetailNewsController = segue.destination as! DetailNewsController
            newVC.news = news[indexPath!.row]
            newVC.fullNews = newsFullText[indexPath!.row]
            newVC.urlNews = arrImages[indexPath!.row]
        }
    }
    
    /// Очистка кэш URL запросов
    func clearURLCache(){
    URLCache.shared.removeAllCachedResponses()
    }
    
    // MARK: - Фильтр по категории спорт
    @IBAction func filterSport(_ sender: UIButton) {
        news = [String]()
        clearURLCache()
        let _ = Alamofire.request("http://www.vesti.ru/vesti.rss", method: .get).response {
            response in
            if let data = response.data {
                let xml = SWXMLHash.parse(data)
                for elem in xml["rss"]["channel"]["item"].all {
                    let elem = elem
                        .filterChildren { _, index in index == 3 || index == 5
                    }
                    let elemCat = elem["category"].element!.text
                    if (elemCat.contains("Спорт")) {
                        self.category = elem["description"].element?.text
                        
                        self.news.append(self.category ?? "")
                    }
                }
                self.table.reloadData()
            }
        }
    }
    
    // MARK: - Запрос и получение данных
    
    func getNews(){
        clearURLCache()
        /// Запрос к источнику с новостями
        let _ = Alamofire.request("http://www.vesti.ru/vesti.rss", method: .get).response {
            response in
            if let data = response.data {
                let xml = SWXMLHash.parse(data)
                do {
                    let dt: String = try xml["rss"]["channel"]["item"]["pubDate"].value()
                    print(dt)
                }
                catch {
                    print("Error")
                }
                
                /// Получение заголовка новости
                self.news = (xml["rss"]["channel"]["item"].all.map{ elem in
                    elem["title"].element!.text
                })
                
                /// Получение полного текста новости
                self.newsFullText = (xml["rss"]["channel"]["item"].all.map{ elem in
                    elem["yandex:full-text"].element!.text
                })
                
                /// Получение даты публикации новости
                self.dateNews = (xml["rss"]["channel"]["item"].all.map{ elem in
                    try! elem["pubDate"].value()
                })
                
                /// Получение изображения новости
                for elem in xml["rss"]["channel"]["item"].all {
                    for i in elem["enclosure"].all {
                        self.imageNews = i.element?.attribute(by: "url")?.text
                        self.arrImages.append(self.imageNews ?? "")
                    }
                }
                self.table.reloadData()
            }
            
        }
    }
}

extension Date: XMLElementDeserializable, XMLAttributeDeserializable {
    public static func deserialize(_ element: XMLElement) throws -> Date {
        let date = stringToDate(element.text)
        
        guard let validDate = date else {
            throw XMLDeserializationError.typeConversionFailed(type: "Date", element: element)
        }
        
        return validDate
    }
    
    public static func deserialize(_ attribute: XMLAttribute) throws -> Date {
        let date = stringToDate(attribute.text)
        
        guard let validDate = date else {
            throw XMLDeserializationError.attributeDeserializationFailed(type: "Date", attribute: attribute)
        }
        
        return validDate
    }
    
    private static func stringToDate(_ dateAsString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        return dateFormatter.date(from: dateAsString)
    }
}
