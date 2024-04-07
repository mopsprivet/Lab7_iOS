import UIKit

struct APIResponse: Codable {
    let total: Int
    let total_pages: Int
    let results: [Result]
}

struct Result: Codable {
    let id: String
    let urls: URLs
}

struct URLs: Codable {
    let full: String
}

class SearchPhotoViewController: UIViewController, UICollectionViewDataSource {
    
    let urlString = "https://api.unsplash.com/search/photos?page=1&query=office&client_id=ig6Hg1UfpgHgFLwt0eJpwSF6EeDlpYq8YIMxymfi4-o"
    
    private var collectionView: UICollectionView?
    
    var results: [Result] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.size.width/2, height: view.frame.size.width/2)
        let collectionView = UICollectionView (frame: .zero, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        view.addSubview(collectionView)
        self.collectionView = collectionView
        fetchPhotos()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    func fetchPhotos() {
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            print("Data recieved!")
            
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                print(jsonResult.results.count)
                DispatchQueue.main.async {
                    self?.results = jsonResult.results
                    
                }
            }
            catch {
                print("!!!!!!!!!!!!!!!!!!!!!!!!!!", error)
            }
        }
        
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageURLString = results[indexPath.row].urls.full
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = .red
        return cell
    }
}
