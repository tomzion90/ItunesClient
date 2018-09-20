//
//  ArtworkDownloader.swift
//  iTunesClient
//
//  Created by Tom Zion on 20/09/2018.
//  Copyright © 2018 Treehouse Island. All rights reserved.
//

import Foundation
import UIKit

class ArtworkDownloader: Operation {
    var album: Album
    
    init(album: Album) {
        self.album = album
        super.init()
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        guard let url = URL(string: album.artworkUrl) else {
            return
        }
        
        let imageData = try! Data(contentsOf: url)
        
        if self.isCancelled {
            return
        }
        
        if imageData.count > 0 {
           album.artwork = UIImage(data: imageData)
           album.artworkState = .downloaded
        } else {
            album.artworkState = .failed
        }
    }
}






























