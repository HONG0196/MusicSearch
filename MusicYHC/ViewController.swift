//
//  ViewController.swift
//  MusicYHC
//
//  Created by 양홍찬 on 2023/06/02.
//

import UIKit

struct MusicData: Codable {
    let resultCount: Int
    let results: [Music]
}

struct Music: Codable {
    let trackName: String?
    let artistName: String?
    let collectionName: String?
    let artworkUrl100: String?
    let releaseDate: String?
}



class ViewController: UIViewController {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var table: UITableView!
    
    var name: String? = "newjeans"
    var musicData: MusicData?
    var musicURL = "https://itunes.apple.com/search?media=music"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 150
        
        getData()
    }
    

    // MARK: - GetData

    func getData() {
        
        guard let name else { return }
        
        // addingPercentEncoding
        let encodingName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        guard let musicName = URL(string: encodingName) else { return }
        
        guard let url = URL(string: "\(musicURL)&term=\(musicName)") else { return }

        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let JSONdata = data {
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(MusicData.self, from: JSONdata)
                    self.musicData = decodedData
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    // 검색
    @IBAction func clickButton(_ sender: UIButton) {
        
        guard let msName = searchField.text else { return }
        name = msName

        getData()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let desk = segue.destination as? YoutubeViewController else { return }
        
        let myIndexPath = table.indexPathForSelectedRow!
        let row = myIndexPath.row
        desk.musicName = (musicData?.results[row].trackName)!
        desk.artistN = (musicData?.results[row].artistName)!
    }
}





// MARK: - Delegate, DataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicData?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath) as? MusicTableViewCell,
              let musicData = musicData else {
            return UITableViewCell()
        }
        
        let musicList = musicData.results[indexPath.row]
        
        // 이미지 불러오기
        if let urlString = musicList.artworkUrl100, let url = URL(string: urlString) {
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: url) else { return }
                DispatchQueue.main.async {
                    cell.musicImage.image = UIImage(data: data)
                }
            }
        }
        
        cell.songNameLabel.text = musicList.trackName
        cell.artistLabel.text = musicList.artistName
        cell.albumLabel.text = musicList.collectionName
        
        let date = musicList.releaseDate
        
        // "yyyy-MM-dd" 형식으로 변경
        if let isoDate = ISO8601DateFormatter().date(from: date ?? "") {
            
            let myFormatter = DateFormatter()
            myFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = myFormatter.string(from: isoDate)
            
            cell.dateLabel.text = dateString
        }
        
        return cell
    }
    
}
