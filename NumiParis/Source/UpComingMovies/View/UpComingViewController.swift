//
//  UpComingViewController.swift
//  NumiParis
//
//  Created by imran shaik on 02/04/21.
//

import UIKit

class UpComingViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var upComingMoviesTableView: UITableView!
    //MARK:- Variables and Constants
    var refreshControl = UIRefreshControl()
    var model = [UpcomingResults]()
    var viewModel = UpComingMoviesViewModel()
    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        upComingMoviesTableView.refreshControl = refreshControl
        registerTableViewNib(table: upComingMoviesTableView) { (status) in
            DispatchQueue.main.async {
                self.upComingMoviesTableView.reloadData()
            }
            self.upComingMoviesTableView.reloadData()
        }
        apiCallForUpComingMovies()
    }
    override func viewWillAppear(_ animated: Bool) {
        apiCallForUpComingMovies()
    }
    //MARK:- Action for refresh controller
    @objc func refresh(sender:AnyObject){
        registerTableViewNib(table: upComingMoviesTableView) { (status) in
            self.upComingMoviesTableView.reloadData()
        }
        apiCallForUpComingMovies()
        
    }
    //MARK:- Registering the tableViewCell
    func registerTableViewNib(table: UITableView, completion: @escaping(_ status: Bool) -> ()){
        table.register(UINib(nibName: "TopRatedMoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "TopRatedMoviesTableViewCell")
        table.dataSource = self
        table.delegate = self
        completion(true)
    }
    //MARK:- Func for Up Coming Movies Api Call
    func apiCallForUpComingMovies(){
        self.viewModel.apiForGetUpComingMovies([:]) { (status, upcomingMoviesResult) in
            if status == .Success{
                if let upcomingMoviesResult = upcomingMoviesResult{
                    self.model.append(contentsOf: upcomingMoviesResult)
                    self.upComingMoviesTableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
                DispatchQueue.main.async {
                    self.upComingMoviesTableView.reloadData()
                }
            } else {
                self.view.makeToast(self.viewModel.errorMessage, duration: 2.0, position: .center)
            }
        }
    }
    
}
//MARK:- Func for Top Rated Movies Api Call
extension UpComingViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopRatedMoviesTableViewCell") as? TopRatedMoviesTableViewCell else {
            return UITableViewCell()
        }
        cell.cellConfigureUpComingMovies(data: model[indexPath.row])
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
        vc.headerTitleText = "Up Coming Movies"
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
