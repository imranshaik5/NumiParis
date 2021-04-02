//
//  TopRatedMooviesViewController.swift
//  NumiParis
//
//  Created by imran shaik on 01/04/21.
//

import UIKit

class TopRatedMooviesViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var topRatedMoviesTableView: UITableView!
    //MARK:- Variables and Constants
    var viewModel = TopRatedMoviesViewModel()
    var model = [Results]()
    var refreshControl = UIRefreshControl()
    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        topRatedMoviesTableView.refreshControl = refreshControl
        registerTableViewNib(table: topRatedMoviesTableView) { (status) in
            self.topRatedMoviesTableView.reloadData()
        }
        apiForGetTopRatedMovies()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        apiForGetTopRatedMovies()
    }
    //MARK:- Action for refresh controller
    @objc func refresh(sender:AnyObject){
        registerTableViewNib(table: topRatedMoviesTableView) { (status) in
            self.topRatedMoviesTableView.reloadData()
        }
        apiForGetTopRatedMovies()
        
    }
    //MARK:- Registering the tableViewCell
    func registerTableViewNib(table: UITableView, completion: @escaping(_ status: Bool) -> ()){
        table.register(UINib(nibName: "TopRatedMoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "TopRatedMoviesTableViewCell")
        table.dataSource = self
        table.delegate = self
        completion(true)
    }
    //MARK:- Func for Top Rated Movies Api Call
    func apiForGetTopRatedMovies(){
        self.viewModel.apiForGetTopRating([:]) { (status, result) in
            if status == .Success{ // success block
                if let result = result{
                    self.model.append(contentsOf: result)
                    self.topRatedMoviesTableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
                DispatchQueue.main.async {
                    self.topRatedMoviesTableView.reloadData()
                    
                }
            } else { // failure block
                self.view.makeToast(self.viewModel.errorMessage, duration: 2.0, position: .center)
            }
        }
    }
    
}
//MARK:- Func for Top Rated Movies Api Call
extension TopRatedMooviesViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopRatedMoviesTableViewCell") as? TopRatedMoviesTableViewCell else {
            return UITableViewCell()
        }
        cell.cellConfigure(data: model[indexPath.row])
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        data(indexPath: indexPath.row)
        debugPrint("tap\(indexPath.row)")
    }
    func data(indexPath:Int){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OverViewViewController") as! OverViewViewController
        vc.headerTitleText = "Top Rated Movies"
        vc.posterImage = model[indexPath].backdrop_path ?? ""
        vc.titleText = model[indexPath].title ?? ""
        vc.overViewText = model[indexPath].overview ?? ""
        vc.voteAvg = "\(model[indexPath].vote_average ?? 0)"
        vc.voteCountText = "\(model[indexPath].vote_count ?? 0)"
        vc.releaseDateText = model[indexPath].release_date ?? ""
        vc.popularityCountText = "\( model[indexPath].popularity ?? 0)"
        vc.languageText = model[indexPath].original_language ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
