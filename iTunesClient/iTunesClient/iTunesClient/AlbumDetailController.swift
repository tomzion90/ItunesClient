//
//  AlbumDetailController.swift
//  iTunesClient
//
//  Created by Screencast on 4/4/17.
//  Copyright © 2017 Treehouse Island. All rights reserved.
//

import UIKit

class AlbumDetailController: UITableViewController {
    
    var album: Album? {
        didSet {
            if let album = album {
                configure(with: album)
                dataSource.update(with: album.songs)
                tableView.reloadData()
            }
        }
    }
    
    lazy var dataSource = AlbumDetailDataSource(songs: [])
    
    @IBOutlet weak var artworkView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var albumGenreLabel: UILabel!
    @IBOutlet weak var albumReleaseDateLabel: UILabel!
    
    var downloader: ArtworkDownloader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let album = album {
            configure(with: album)
        }
        
        tableView.dataSource = dataSource
        
    }
    
    func configure(with album: Album) {
        let viewModel = AlbumDetailViewModel(album: album)
        
        downloader = ArtworkDownloader(album: album)
        
        downloader.completionBlock = {
            if self.downloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                self.artworkView.image = self.downloader.album.artwork
            }
        
        }
        downloader.start()
        albumTitleLabel.text = viewModel.title
        albumGenreLabel.text = viewModel.genre
        albumReleaseDateLabel.text = viewModel.releaseDate
    }
}




















