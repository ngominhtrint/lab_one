//
//  PhotosViewController.swift
//  LabOne
//
//  Created by TriNgo on 6/15/17.
//  Copyright © 2017 Huvvit. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var photos: [NSDictionary]?
    override func viewDidLoad() {
        super.viewDidLoad()

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
                            if let photoData = responseDictionary["data"] as? [NSDictionary] {
                                self.photos = photoData
                                self.tableView.reloadData()
                            }
                        }
                    }
            })
            task.resume()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PhotosViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension PhotosViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

