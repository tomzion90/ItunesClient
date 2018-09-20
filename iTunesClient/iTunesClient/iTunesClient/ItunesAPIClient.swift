//
//  ItunesAPIClient.swift
//  iTunesClient
//
//  Created by Tom Zion on 18/09/2018.
//  Copyright © 2018 Treehouse Island. All rights reserved.
//

import Foundation

class ItunesAPIClient {
    let downloader = JSONDownloader()
    
    func searchForArtists(withTerm term: String, completion: @escaping ([Artist], ItunesError?) -> Void) {
        let endpoint = Itunes.search(term: term, media: .music(entity: .musicArtist, attribute: .artistTerm))
        
        preformRequest(with: endpoint) { results, error in
            guard let results = results else {
                completion([], error)
                return
            }
            
        let artists = results.flatMap { Artist(json: $0) }
        
            completion(artists, nil)
        }
    }
    
    func lookupArtist(withId id: Int, completion: @escaping (Artist?, ItunesError?) -> Void) {
        
        let endpoint = Itunes.lookup(id: id, entity: MusicEntity.album)
        
        preformRequest(with: endpoint) { results, error in
            guard let results = results else {
                completion(nil, error)
                return
            }
        
            guard let artistInfo = results.first else {
                completion(nil, .jsonParsingFailure(message: "Results does not contain artist information"))
                return
            }
            
            guard let artist = Artist(json: artistInfo) else {
                completion(nil, .jsonParsingFailure(message: "Could not parce artist information"))
                return
            }
            
            let albumResults = results[1..<results.count]
            let albums = albumResults.flatMap { Album(json: $0) }
            
            artist.albums = albums
            
            completion(artist, nil)
        }
    }
        
      func lookupAlbum(withId id: Int, completion: @escaping (Album?, ItunesError?) -> Void) {
          let endpoint = Itunes.lookup(id: id, entity: MusicEntity.song)
        
          preformRequest(with: endpoint) { results, error in
            guard let results = results else {
                completion(nil, error)
                return
            }
            guard let albumInfo = results.first else {
                completion(nil, .jsonParsingFailure(message: "Results does not contain album information"))
                return
            }
            
            guard let album = Album(json: albumInfo) else {
                completion(nil, .jsonParsingFailure(message: "Could not parce album information"))
                return
            }
            
            let songResults = results[1..<results.count]
            let songs = songResults.flatMap { Song(json: $0) }
            
            album.songs = songs
            completion(album,nil)
        }
    }

    typealias Results = [[String: Any]]
    
     private func preformRequest(with endpoint: Endpoint, completion: @escaping (Results?, ItunesError?) -> Void) {
        let task = downloader.jsonTask(with: endpoint.request) { json, error in
            DispatchQueue.main.async {
                guard let json = json else {
                    completion (nil, error)
                    return
                }
                
                guard let results = json["results"] as? [[String: Any]] else {
                    completion(nil, .jsonParsingFailure(message: "JSON data does not contain results"))
                    return
                }
                
                completion(results, nil)
            }
        }
        
        task.resume()
    }
}































