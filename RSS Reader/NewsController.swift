//
//  NewsController.swift
//  RSS Reader
//
//  Created by Михаил Маслов on 12.06.2020.
//  Copyright © 2020 Михаил Маслов. All rights reserved.
//

import UIKit

class NewsController: UITableViewController {

    var request = Requests()
    let myrefreshcontrol: UIRefreshControl = {
        let refreshcontol = UIRefreshControl()
        refreshcontol.addTarget(self, action: #selector(refreshNews(sender:)), for: .valueChanged)
        refreshcontol.tintColor = .blue
        return refreshcontol
    }()
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var filterView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request.getNews()
        reload()
        blurView.bounds = self.view.bounds
        filterView.bounds = CGRect(x: 0, y: 0, width: view.bounds.width * 0.9, height: view.bounds.height * 0.4)
        table.refreshControl = myrefreshcontrol
    }

    
    // MARK: - Pull to update
    
    @objc private func refreshNews(sender: UIRefreshControl) {
        request.getNews()
        reload()
        sender.endRefreshing()
    }
    
    // MARK: - Reload tableview
    
    func reload(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return request.newsArr.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCellId", for: indexPath) as! NewsCell
        cell.textNews.text = request.newsArr[indexPath.row]
        cell.dateNews.text = request.dateNews[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewsDetail" {
            let indexPath = tableView.indexPathForSelectedRow
            let newVC: DetailNewsController = segue.destination as! DetailNewsController
            newVC.news = request.newsArr[indexPath!.row]
            newVC.fullNews = request.newsFullTextArr[indexPath!.row]
            newVC.urlNews = request.imagesArr[indexPath!.row]
        }
    }
    
    // MARK: - Filter by category
    
    @IBAction func filterButton(_ sender: UIButton) {
        showFilter(desireView: blurView)
        showFilter(desireView: filterView)
    }
    
    @IBAction func socFilter(_ sender: UIButton) {
        request.socFilter()
        hideFilter(desireView: blurView)
        hideFilter(desireView: filterView)
        reload()
    }
    
    // MARK: - Show, hide filter
    
    func hideFilter(desireView: UIView) {
        table.isScrollEnabled = true
        UIView.animate(withDuration: 0.3, animations:  {
            desireView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desireView.alpha = 0
        })
    }
    
    func showFilter(desireView: UIView) {
        let background = self.view!
        background.addSubview(desireView)
        table.isScrollEnabled = false
        desireView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desireView.alpha = 0
        desireView.center = background.center
        UIView.animate(withDuration: 0.3, animations:  {
            desireView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desireView.alpha = 1
        })
    }
    
}

