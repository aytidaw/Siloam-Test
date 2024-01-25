//
//  DetailViewController.swift
//  TestingTest
//
//  Created by Aditya on 24/01/24.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var detailVM = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.defaultBlockLoading()
        detailVM.fetchDetailData()
        detailVM.delegate = self
    }
    
    func populateData(data: MealModel) {
        if let imageURL = URL(string: data.strMealThumb ?? "") {
            imageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: ""))
        }
    
        titleLabel.text = data.strMeal ?? "-"
        descriptionLabel.text = data.strInstructions ?? "-"
        categoryLabel.text = data.strCategory ?? "-"
        tagsLabel.text = "Tags: \(data.strTags ?? "-")"
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController: DetailViewModelDelegate {
    func success(data: MealModel) {
        Helper.stopLoading()
        populateData(data: data)
    }
    
    func failedReq(message: String) {
        print(message)
    }
}
