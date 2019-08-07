//
//  MovieDescriptionViewController.swift
//  MoviesCatalog
//
//  Created by Hind on 07/08/2019.
//  Copyright © 2019 Hind. All rights reserved.
//

import UIKit

class MovieDescriptionViewController: UIViewController {

    var index = Int()
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var backdrop: UIImageView!
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var rate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // index is the index of the movie we selected
        index = MoviesInfos.shared.index
        setImages()
        setLabels()
    }
    
    // since we have now the index of the movie we want we can use the arrays where we stored movies data to fill imageViews and labels
    func setImages(){
        
        let lPosterUrl = URL(string: "https://image.tmdb.org/t/p/w185/\(MoviesInfos.shared.sPoster[index])")
        let lPosterData = try? Data(contentsOf: lPosterUrl!)
        let lBackdropUrl = URL(string: "https://image.tmdb.org/t/p/w500/\(MoviesInfos.shared.sBackdrop[index])")
        let lBackdropData = try? Data(contentsOf: lBackdropUrl!)
        
        poster.image = UIImage(data: lPosterData!)
        backdrop.image = UIImage(data: lBackdropData!)
    }
    
    func setLabels(){
        
        if MoviesInfos.shared.sTitle.count < index {
            movieTitle.text = ""
        }else{
            movieTitle.text = MoviesInfos.shared.sTitle[index]
        }
        if MoviesInfos.shared.sReleaseDate.count < index {
             releaseDate.text = " "
        }else {
            releaseDate.text = MoviesInfos.shared.sReleaseDate[index]
        }
        if MoviesInfos.shared.sOverview.count < index {
            movieDescription.text = "No description is available :/"
        }else{
            movieDescription.text = MoviesInfos.shared.sOverview[index]
        }
        if MoviesInfos.shared.sVote.count < index {
            rate.text = " "
        }else{
            rate.text = MoviesInfos.shared.sVote[index]
        }
        
    }
    
    
    // to go bach to the previous page
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    // To download the movie poster
    @IBAction func savePoster(_ sender: Any) {
        let lImageData = poster.image!.pngData()
        let lConmressedImage = UIImage(data : lImageData!)
        
        UIImageWriteToSavedPhotosAlbum(lConmressedImage!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved", message: "Your image has been saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
   
    
}
