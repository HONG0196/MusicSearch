//
//  VibeViewController.swift
//  MusicYHC
//
//  Created by 양홍찬 on 2023/06/02.
//

import UIKit
import WebKit

class VibeViewController: UIViewController {
   
    
    
    @IBOutlet weak var vibe: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString = "https://vibe.naver.com/today"
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        vibe.load(request)
    }
    

 

}


