//
//  ViewController.swift
//  MoviesCatalog
//
//  Created by Hind on 07/08/2019.
//  Copyright © 2019 Hind. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searching = false
    var posterSearch = [String]()
    var indexArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovies()
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        
        searchBar.delegate = self
       
    }


    func getMovies(){
        
        let lUrlString = "https://api.themoviedb.org/3/list/509ec17b19c2950a0600050d?api_key=545fb968e784624362fe1609c449a278"
        
        // make an https request
        Alamofire.request(lUrlString).responseJSON{ response in
            if response.result.isSuccess {
                
                // The response given by Alamofire is not a typical JSON so we transform it into a json format tobe able to parse it using SwiftyJSON
                let lSearchResults:JSON = JSON(response.result.value as Any)
                self.parseMovies(lSearchResults)
                print("count is :: \(MoviesInfos.shared.sPoster.count)")
                self.movieCollectionView.reloadData()
            }
            else{
                print("ERROR :: \(String(describing: response.result.error))")
            }
        }
        
    }
    
    // this function parse a JSON variable and store the result into static arrays to be able to recover the results in the main thread
    func parseMovies(_ pResponse:JSON){
        MoviesInfos.shared.sTitle.removeAll()
        MoviesInfos.shared.sOverview.removeAll()
        MoviesInfos.shared.sReleaseDate.removeAll()
        MoviesInfos.shared.sPoster.removeAll()
        MoviesInfos.shared.sBackdrop.removeAll()
        MoviesInfos.shared.sVote.removeAll()
        
        for (_, value) in pResponse["items"]{
            for (_,_) in value {
                if !MoviesInfos.shared.sTitle.contains(String(describing: value["title"])){
                    MoviesInfos.shared.sTitle.append(String(describing: value["title"]))
                }
                if !MoviesInfos.shared.sOverview.contains(String(describing: value["overview"])){
                    MoviesInfos.shared.sOverview.append(String(describing: value["overview"]))
                    
                }
                if !MoviesInfos.shared.sReleaseDate.contains(String(describing: value["release_date"])){
                    MoviesInfos.shared.sReleaseDate.append(String(describing: value["release_date"]))
                   
                }
                if !MoviesInfos.shared.sPoster.contains(String(describing: value["poster_path"])){
                    MoviesInfos.shared.sPoster.append(String(describing: value["poster_path"]))
                   
                }
                if !MoviesInfos.shared.sBackdrop.contains(String(describing: value["backdrop_path"])){
                    MoviesInfos.shared.sBackdrop.append(String(describing: value["backdrop_path"]))
                }
                if !MoviesInfos.shared.sVote.contains(String(describing: value["vote_average"])){
                    MoviesInfos.shared.sVote.append(String(describing: value["vote_average"]))
                }
            }
        }
    }


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searching {
            return posterSearch.count
        }else {
            return MoviesInfos.shared.sPoster.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "movieCell")
        
        let lCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoviesCollectionViewCell
        
        if searching {
            let lImageUrl = URL(string: "https://image.tmdb.org/t/p/w185/\(posterSearch[indexPath.item])")
            let lData = try? Data(contentsOf: lImageUrl!)
            
            lCell.moviePoster.image = UIImage(data: lData!)
        }else {
            let lImageUrl = URL(string: "https://image.tmdb.org/t/p/w185/\(MoviesInfos.shared.sPoster[indexPath.item])")
            let lData = try? Data(contentsOf: lImageUrl!)
            
            lCell.moviePoster.image = UIImage(data: lData!)
        }
        
        return lCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if searching {
            MoviesInfos.shared.index = indexArray[indexPath.item]
        }else {
            MoviesInfos.shared.index = indexPath.item
        }
        
        performSegue(withIdentifier: "movieDescription", sender: self)
    }
    
    
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        indexArray.removeAll()
        posterSearch.removeAll()
        switch searchBar.selectedScopeButtonIndex {
            case 0:
                if searchText.isEmpty {
                    searching = false
                }else {
                    searching = true
                    var i = -1
                    // We fill the indexArray with the indexes that match the search
                    for value in MoviesInfos.shared.sTitle {
                        i += 1
                        if value.lowercased().contains(searchText.lowercased()){
                            indexArray.append(i)
                        }
                    }
                    // We fill the source of data of the collection view
                    for value in indexArray {
                        if !posterSearch.contains(MoviesInfos.shared.sPoster[value]){
                            posterSearch.append(MoviesInfos.shared.sPoster[value])
                        }
                    }
                }
            
            default:
                searching = false
            }

        movieCollectionView.reloadData()
    }
}
