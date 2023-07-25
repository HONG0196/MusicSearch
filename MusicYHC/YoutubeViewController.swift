//
//  YoutubeViewController.swift
//  MusicYHC
//
//  Created by 양홍찬 on 2023/06/02.
//

import UIKit
import WebKit

class YoutubeViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var musicName = ""
    
    var artistN = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = musicName
        let urlKorString = "https://www.youtube.com/results?search_query=\(artistN) \(musicName)"
        let urlString = urlKorString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        print(urlString)
    }

}
