//
//  ViewController.swift
//  contact
//
//  Created by Pinkesh Gjr on 04/02/20.
//  Copyright © 2020 Pinkesh Gjr. All rights reserved.
//

import UIKit
import SwiftyJSON
import Contacts

class HomeViewController: UIViewController {
    
    //MARK:- Property
    @IBOutlet weak var tableViewContacts: UITableView!
    
    //MARK:- Variable
    var viewModel = HomeViewModel()
    var arrayContacts = [(key: String, value: [HomeViewModel.homeModelClass])]()

    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
        callGetAllContacts()
    }
    
    //MARK:- Functions
    private func setupUI() {
        tableViewContacts.register(UINib(nibName: ContactListTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ContactListTableViewCell.reuseIdentifier)
        tableViewContacts.register(UINib(nibName: ContactHeaderView.reuseIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: ContactHeaderView.reuseIdentifier)
        tableViewContacts.reloadData()
    }

    private func callGetAllContacts() {
        self.showIndicator(view: self.view)
        ApiManager.sharedInstance.getRequest(endpointURL: webservicesPrefix.getAllContacts) { [weak self] (response, error, message, responseData) in
            if let weakSelf = self {
                weakSelf.hideIndicator(view: weakSelf.view)
                if response != nil{
                    let objectDetails = JSON(responseData as Any)
                    let decoder = JSONDecoder()
                    do {
                        let arrayResult = try decoder.decode([HomeViewModel.homeModelClass].self, from: objectDetails.rawData())
                        weakSelf.getGroupedContacts(arrayResult: arrayResult)
                    } catch {
                        //
                    }
                } else {
                     weakSelf.showAlerControllerWith(title: "Error!", message: error?.localizedDescription ?? "")
                }
            }
        }
    }
    
    private func getGroupedContacts(arrayResult: [HomeViewModel.homeModelClass]) {
        let sortedResult =  arrayResult.compactMap({$0})
        let arrayDictContact = Dictionary(grouping: sortedResult, by: {$0.firstCharacter})
        self.arrayContacts = arrayDictContact.sorted(by: {$0.0 < $1.0})
        tableViewContacts.reloadData()
    }
    
    //MARK: - Actions
    @IBAction func buttonAddTouchUpInside(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: EditContactViewController.storyboardIdentifier) as! EditContactViewController
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - EditContactViewControllerDelegate
extension HomeViewController: EditContactViewControllerDelegate {
    func contactDetailsEdited(objectContact: contactDetailsViewModel.detailsModel) {
       //
    }
    
    func contactDetailsAdded(objectContact: contactDetailsViewModel.detailsModel) {
        callGetAllContacts()
    }
}

//MARK: - ContactDetailsViewControllerDelegate
extension HomeViewController:ContactDetailsViewControllerDelegate {
    func contactDetailsEditted() {
        callGetAllContacts()
    }
}

//MARK: - TableViewDelegate, TableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    //Header
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayContacts.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView =  tableView.dequeueReusableHeaderFooterView(withIdentifier: ContactHeaderView.reuseIdentifier ) as! ContactHeaderView
        let keys = arrayContacts[section]
        headerView.labelLiteral.text = keys.key
        return headerView
    }
    
    //Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let values = arrayContacts[section]
        return values.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactListTableViewCell.reuseIdentifier, for: indexPath) as! ContactListTableViewCell
        let values = arrayContacts[indexPath.section]
        let objectContact = values.value[indexPath.row]
        cell.configureCell(objectContact: objectContact)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let values = arrayContacts[indexPath.section]
        let objectContact = values.value[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ContactDetailsViewController.storyboardIdentifier) as! ContactDetailsViewController
        controller.userContactURL = objectContact.url
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
