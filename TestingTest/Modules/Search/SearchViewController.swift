//
//  SearchViewController.swift
//  TestingTest
//
//  Created by Aditya on 24/01/24.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var wrapperSearchTextField: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var widthConstraintButton: NSLayoutConstraint!
    
    var searchVM = SearchViewModel()
    
    var dataSource: [MealModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchVM.delegate = self
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextField.becomeFirstResponder()
    }
    
    func setupView() {
        let cellNib = UINib(nibName: String(describing: SearchTableViewCell.self), bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: String(describing: SearchTableViewCell.self))
    
        wrapperSearchTextField.layer.cornerRadius = 6.0
        searchTextField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = true
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }
    
    @IBAction func clearTapped(_ sender: Any) {
        Helper.defaultBlockLoading()
        searchVM.fetchDataList(query: "")
        clearButton.isHidden = true
        searchTextField.text = ""
    }
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dataSource = searchVM.dataSource
        
        if dataSource.count > 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchTableViewCell.self),
                                                           for: indexPath) as? SearchTableViewCell else {
                return UITableViewCell()
            }
            
            tableView.restore()
            
            let dataSource = searchVM.dataSource[indexPath.row]
            cell.configureCell(data: dataSource)
            cell.delegate = self
            return cell
        } else {
            tableView.setEmptyView(title: Constants.ConstantText.EmptyStateTitle.rawValue,
                                   message: Constants.ConstantText.EmptyStateMessage.rawValue)
        }
        
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataSource = searchVM.dataSource
        if dataSource.count > 0 {
            return searchVM.dataSource.count
        } else {
            return 1
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let validData = searchVM.dataSource[indexPath.row]
        let vc = DetailViewController.loadFromNib()
        let idMeal = Int(validData.idMeal ?? "")
        vc.detailVM.id = idMeal ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SearchViewController: SearchTableViewCellDelegate {
    func zooming(started: Bool) {
        self.tableView.isScrollEnabled = !started
    }
}


// MARK: - HomeViewModelDelegate

extension SearchViewController: SearchViewModelDelegate {
    func success(data: [MealModel]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.searchVM.dataSource = data
            self?.tableView.reloadData()
            Helper.stopLoading()
        }
    }
    
    func failedReq(message: String) {
        Helper.stopLoading()
        self.searchVM.dataSource.removeAll()
        self.tableView.reloadData()
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let searchText = textField.text!.replacingCharacters(in: Range(range, in: textField.text!)!, with: string)
        let firstText = String(searchText.prefix(1))
        
        Helper.defaultBlockLoading()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.searchVM.fetchDataList(query: firstText)
        }

        if searchText.isEmpty {
            clearButton.isHidden = true
            widthConstraintButton.constant = 0
        } else {
            clearButton.isHidden = false
            widthConstraintButton.constant = 20
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

}
