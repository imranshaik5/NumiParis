//
//  OverViewViewController.swift
//  NumiParis
//
//  Created by imran shaik on 01/04/21.
//

import UIKit

class OverViewViewController: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var voteAverage: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var popularityCount: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var headerTitleLabel: UILabel!
    //MARK:- Variables and Constants
    var headerTitleText = String()
    var posterImage = String()
    var titleText = String()
    var overViewText = String()
    var voteAvg = String()
    var voteCountText = String()
    var releaseDateText = String()
    var popularityCountText = String()
    var languageText = String()
    //MARK:- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        headerTitleLabel.text = headerTitleText
        self.moviePosterImageView.setImage(with: "https://image.tmdb.org/t/p/w500\(posterImage)", placeHolder: nil)
        titleLabel.text = titleText
        overViewLabel.text = overViewText
        voteAverage.text = voteAvg
        voteCount.text = voteCountText
        releaseDate.text = releaseDateText
        popularityCount.text = popularityCountText
        language.text = languageText
        
    }
    //MARK:- Back button action
    @IBAction func onBackButtontap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}
