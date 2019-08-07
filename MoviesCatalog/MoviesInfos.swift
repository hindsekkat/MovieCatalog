//
//  MoviesInfos.swift
//  MoviesCatalog
//
//  Created by Hind on 07/08/2019.
//  Copyright © 2019 Hind. All rights reserved.
//

import Foundation

//this class store variables that we will need to access from different classes of the project
class MoviesInfos {
    static let shared = MoviesInfos()
    
    var sTitle = [String](), sOverview = [String](), sReleaseDate = [String](), sPoster = [String](), sBackdrop = [String](), sVote = [String]()
    
    var index = Int()
}

