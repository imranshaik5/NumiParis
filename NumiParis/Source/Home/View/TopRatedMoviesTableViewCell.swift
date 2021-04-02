//
//  TopRatedMoviesTableViewCell.swift
//  NumiParis
//
//  Created by imran shaik on 01/04/21.
//

import UIKit

class TopRatedMoviesTableViewCell: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var movieIcon: UIImageView!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var popularity: UILabel!
    @IBOutlet weak var voteAvg: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.shadowView.layer.applySketchShadow(color: #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1), alpha: 0.1, x: 0, y: 1, blur: 14, spread: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    //MARK:- Configure the view for the selected state
    func cellConfigure(data:Results){
        self.movieIcon.setImage(with: "https://image.tmdb.org/t/p/w500\(data.poster_path ?? "")", placeHolder: nil)
        titleName.text = data.title
        language.text = data.original_language
        releaseDate.text = data.release_date
        popularity.text = "\(data.popularity ?? 0)"
        voteAvg.text = "\(data.vote_average ?? 0)"
        voteCount.text = "\(data.vote_count ?? 0)"
        
    }
    
    func cellConfigureUpComingMovies(data: UpcomingResults){
        self.movieIcon.setImage(with: "https://image.tmdb.org/t/p/w500\(data.poster_path ?? "")", placeHolder: nil)
        titleName.text = data.title
        language.text = data.original_language
        releaseDate.text = data.release_date
        popularity.text = "\(data.popularity ?? 0)"
        voteAvg.text = "\(data.vote_average ?? 0)"
        voteCount.text = "\(data.vote_count ?? 0)"
        
    }
    
}
