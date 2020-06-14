//
//  DetailNewsController.swift
//  RSS Reader
//
//  Created by Михаил Маслов on 12.06.2020.
//  Copyright © 2020 Михаил Маслов. All rights reserved.
//

import UIKit
import Kingfisher

class DetailNewsController: UIViewController {
    
    @IBOutlet weak var textNews: UILabel!
    
    var news = String()
    var fullNews = String()
    var urlNews = String()
    
    @IBOutlet weak var imageNews: UIImageView!
    
    @IBOutlet weak var fullTextNews: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textNews.text = news
        fullTextNews.text = fullNews
        let url = URL(string: urlNews)
        imageNews.kf.setImage(with: url)
        
    }
}
