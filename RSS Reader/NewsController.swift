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
    
    var news = [String]()
    var dateNews = [String]()
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
    
    func getNews(){
        let _ = Alamofire.request("http://www.vesti.ru/vesti.rss", method: .get).response {
            response in
            if let data = response.data {
                let xml = SWXMLHash.parse(data)
                do {
                    let dt: Date = try xml["rss"]["channel"]["item"]["pubDate"].value()
                    print(dt)
                }
                catch {
                    print("Error")
                }
                self.news = (xml["rss"]["channel"]["item"].all.map{ elem in
                    elem["title"].element!.text
                })
                
                self.dateNews = (xml["rss"]["channel"]["item"].all.map{ elem in
                    elem["pubDate"].element!.text
                })
                
            }
                self.table.reloadData()
        }

    }
}
extension UIImageView {
    func loadImage(stringUrl: String) {
        DispatchQueue.global().async { [weak self] in
            if let stringUrl = URL(string: stringUrl) {
                if let data = try? Data(contentsOf: stringUrl) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
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
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        return dateFormatter.date(from: dateAsString)
    }
}
