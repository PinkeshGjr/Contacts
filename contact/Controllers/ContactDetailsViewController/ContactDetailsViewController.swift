//
//  ContactDetailsViewController.swift
//  contact
//
//  Created by Pinkesh Gjr on 05/02/20.
//  Copyright © 2020 Pinkesh Gjr. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

//MARK:- ContactDetailsViewControllerDelegate
protocol ContactDetailsViewControllerDelegate {
    func contactDetailsEditted()
}

class ContactDetailsViewController: UIViewController {
    
    //MARK:- Property
    @IBOutlet weak var tableViewDetails: UITableView!
    
    //MARK:- Variable
    var delegate: ContactDetailsViewControllerDelegate?
    var userContactURL: String?
    var objectContactDetails: contactDetailsViewModel.detailsModel?
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getUserDetails()
    }
    
    //MARK:- Functions
    private func setupUI() {
        tableViewDetails.register(UINib(nibName: DetailsListTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: DetailsListTableViewCell.reuseIdentifier)
        tableViewDetails.register(UINib(nibName: DetailsHeaderView.reuseIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: DetailsHeaderView.reuseIdentifier)
        tableViewDetails.register(UINib(nibName: ContactDeleteTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ContactDeleteTableViewCell.reuseIdentifier)
        tableViewDetails.reloadData()
    }
    
    private func getUserDetails() {
        self.showIndicator(view: self.view)
        ApiManager.sharedInstance.getRequest(endpointURL: userContactURL ?? "") { [weak self] (response, error, message, responseData) in
            if let weakSelf = self {
                weakSelf.hideIndicator(view: weakSelf.view)
                if response != nil {
                    let objectDetails = JSON(responseData as Any)
                    let decoder = JSONDecoder()
                    do {
                        weakSelf.objectContactDetails = try decoder.decode(contactDetailsViewModel.detailsModel.self, from: objectDetails.rawData())
                        weakSelf.tableViewDetails.reloadData()
                    } catch {
                        //
                    }
                } else {
                     weakSelf.showAlerControllerWith(title: "Error!", message: error?.localizedDescription ?? "")
                }
            }
        }
    }
    
    func deleteUser() {
        self.showIndicator(view: self.view)
        let webURL = webservicesPrefix.updateContact + "\(objectContactDetails?.id ?? 0).json"
        ApiManager.sharedInstance.deleteRequest(endpointURL: webURL) { [weak self] (response, error, message, responseData) in
            if let weakSelf = self {
                weakSelf.hideIndicator(view: weakSelf.view)
                if response != nil{
                    weakSelf.delegate?.contactDetailsEditted()
                    weakSelf.navigationController?.popViewController(animated: true)
                } else {
                    weakSelf.showAlerControllerWith(title: "Error!", message: error?.localizedDescription ?? "")
                }
            }
        }
    }
    
    //MARK: - Action
    @IBAction func buttonBackTouchUpInside(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonEditTouchUpInside(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: EditContactViewController.storyboardIdentifier) as! EditContactViewController
        controller.isEditingObject = true
        controller.objectContactDetails = objectContactDetails
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func buttonDeleteTouchUpInside(_ sender: Any){
        let alertController = UIAlertController(title: "Are you sure you want to delete this contact?", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            self.deleteUser()
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

//MARK: - EditContactViewControllerDelegate
extension ContactDetailsViewController: EditContactViewControllerDelegate{
    func contactDetailsEdited(objectContact: contactDetailsViewModel.detailsModel) {
        getUserDetails()
        self.delegate?.contactDetailsEditted()
    }
    
    func contactDetailsAdded(objectContact: contactDetailsViewModel.detailsModel) {
        //
    }
}

//MARK: - TableViewDelegate, TableViewDataSource
extension ContactDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    //Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 299
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView =  tableView.dequeueReusableHeaderFooterView(withIdentifier: DetailsHeaderView.reuseIdentifier ) as! DetailsHeaderView
        headerView.imageViewProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        headerView.imageViewProfile.sd_setImage(with: URL(string: webservicesPrefix.baseURL + (objectContactDetails?.profilePic ?? "")), placeholderImage: #imageLiteral(resourceName: "ic_placeholder"), options: .refreshCached, completed: nil)
        headerView.labelName.text = (objectContactDetails?.firstName ?? "") + " " + (objectContactDetails?.lastName ?? "")
        if objectContactDetails?.favourite ?? false {
            headerView.buttonFavourite.setImage(#imageLiteral(resourceName: "ic_favourite_selected"), for: .normal)
        } else {
            headerView.buttonFavourite.setImage(#imageLiteral(resourceName: "ic_favourite"), for: .normal)
        }
        return headerView
    }
    
    //Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactDetailsViewModel.fields.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch contactDetailsViewModel.fields(rawValue: indexPath.row)! {
        case .mobileNumber:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailsListTableViewCell.reuseIdentifier, for: indexPath) as! DetailsListTableViewCell
            cell.configureCell(key: "mobile", value: objectContactDetails?.phoneNumber ?? "")
            return cell
        case .email:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailsListTableViewCell.reuseIdentifier, for: indexPath) as! DetailsListTableViewCell
            cell.configureCell(key: "email", value: objectContactDetails?.email ?? "")
            return cell
        case .delete:
            let cell = tableView.dequeueReusableCell(withIdentifier: ContactDeleteTableViewCell.reuseIdentifier, for: indexPath) as! ContactDeleteTableViewCell
            cell.buttonDelete.addTarget(self, action: #selector(self.buttonDeleteTouchUpInside(_:)), for: .touchUpInside)
            return cell
        }
    }
}
