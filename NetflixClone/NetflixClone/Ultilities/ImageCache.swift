import Foundation
import UIKit

class ImageLoader: UIImageView {
    let imageCache = NSCache<NSString, AnyObject>()

    func setImageByUrl(url: String) {
        // Retrive image if already available in cache
        if let imageFromCache = imageCache.object(forKey: url as NSString) as? UIImage {
            self.image = imageFromCache
            return
        }
        // Image is not avaiable in cache
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            let apiRepo = APIRepository()
            apiRepo.getImage(url: url) { (result: Result<Data, Error>) in
                switch result {
                case .success(let imageData):
                    DispatchQueue.main.async {
                        guard let imageToCache = UIImage(data: imageData) else { return }
                        self.imageCache.setObject(imageToCache, forKey: url as NSString)
                        self.image = imageToCache
                }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
}
