//
//  ViewController.swift
//  AspectCollectionView
//
//  Created by Dalton Claybrook on 3/29/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

struct Image {
    let url: URL
    let size: CGSize
    
    init(size: CGSize) {
        self.size = size
        let urlString = "https://picsum.photos/\(Int(size.width))/\(Int(size.height))"
        self.url = URL(string: urlString)!
    }
}

class ViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    private var collectionViewLayout: AspectCollectionViewLayout!
    var images = [Image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createImages()
        collectionViewLayout = AspectCollectionViewLayout(dataSource: self)
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.reloadData()
    }
    
    @IBAction func columnsButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Columns", message: "Set number of columns", preferredStyle: .alert)
        alert.addTextField { (field) in
            field.keyboardType = .numberPad
            field.placeholder = "Columns"
            field.text = "2"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (action) in
            let field = alert.textFields!.first!
            let columns = max(Int(field.text ?? "") ?? 0, 2)
            self?.collectionViewLayout.numberOfColumns = columns
        }))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Private
    
    private func createImages() {
        for _ in (0..<100) {
            let width = CGFloat(arc4random_uniform(500) + 500)
            let height = CGFloat(arc4random_uniform(500) + 500)
            images.append(Image(size: CGSize(width: width, height: height)))
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseID, for: indexPath) as! ImageCell
        cell.configure(withURL: images[indexPath.item].url)
        return cell
    }
}

extension ViewController: AspectLayoutDataSource {
    
    func aspectLayout(_ layout: AspectCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return images[indexPath.item].size
    }
}
