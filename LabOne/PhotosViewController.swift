//
//  PhotosViewController.swift
//  LabOne
//
//  Created by TriNgo on 6/15/17.
//  Copyright © 2017 Huvvit. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var photos = [NSDictionary]()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl.addTarget(self, action: #selector(PhotosViewController.fetchPhotos), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        fetchPhotos()
        tableView.delegate = self
        tableView.dataSource = self
    }

    func fetchPhotos() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/xkcn.info/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        
        if let url = url {
            let request = URLRequest(
                url: url,
                cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
                timeoutInterval: 10)
            let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate: nil,
                delegateQueue: OperationQueue.main)
            let task = session.dataTask(
                with: request,
                completionHandler: { (dataOrNil, response, error) in
                    if let data = dataOrNil {
                        if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            guard let responseData = responseDictionary["response"] as? NSDictionary else { return }
                            if let photoData = responseData["posts"] as? [NSDictionary] {
                                self.photos = photoData
                                self.tableView.reloadData()
                                self.refreshControl.endRefreshing()
                            }
                        }
                    }
            })
            task.resume()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DetailViewController
        var indexPath = tableView.indexPath(for: sender as! PhotoCell)
        
        let postData = photos[(indexPath?.section)!]
        if let urlData = postData["photos"] as? [NSDictionary] {
            if let originalSize = urlData.first?["original_size"] as? NSDictionary {
                if let urlString = originalSize["url"] as? String {
                    vc.urlString = urlString
                }
            }
        }
    }
}

extension PhotosViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as? PhotoCell {
            let postData = photos[indexPath.section]
            if let urlData = postData["photos"] as? [NSDictionary] {
                if let originalSize = urlData.first?["original_size"] as? NSDictionary {
                    if let urlString = originalSize["url"] as? String {
                        let url = URL(string: urlString)!
                        cell.photoImageView.setImageWith(url)
                    }
                }
            }

            return cell
        }
        return UITableViewCell()
    }
}

extension PhotosViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1
        
        let label = UILabel(frame: CGRect(x: 50, y: 10, width: 260, height: 30))
        
        let postData = photos[section]
        if let urlData = postData["photos"] as? [NSDictionary] {
            if let originalSize = urlData.first?["original_size"] as? NSDictionary {
                if let urlString = originalSize["url"] as? String {
                    let url = URL(string: urlString)!
                    profileView.setImageWith(url)
                }
            }
        }
        
        if let slug = postData["slug"] as? String {
            label.text = slug
        }
        
        headerView.addSubview(profileView)
        headerView.addSubview(label)
        headerView.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.7)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
}

