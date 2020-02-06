//
//  EditContactViewController.swift
//  contact
//
//  Created by Pinkesh Gjr on 05/02/20.
//  Copyright © 2020 Pinkesh Gjr. All rights reserved.
//

import UIKit
import SwiftyJSON

//MARK:- EditContactViewControllerDelegate
protocol EditContactViewControllerDelegate {
    func contactDetailsEdited(objectContact: contactDetailsViewModel.detailsModel)
    func contactDetailsAdded(objectContact: contactDetailsViewModel.detailsModel)
}

class EditContactViewController: UIViewController {

    //MARK:- Property
    @IBOutlet weak var tableViewDetails: UITableView!
    
    //MARK:- Variable
    var delegate: EditContactViewControllerDelegate?
    var objectContactDetails: contactDetailsViewModel.detailsModel?
    var structValues = EditViewModel.fieldValues()
    var isEditingObject = false
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    //MARK:- Functions
    private func setupUI(){
        tableViewDetails.register(UINib(nibName: EditHeaderView.reuseIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: EditHeaderView.reuseIdentifier)
        tableViewDetails.register(UINib(nibName: EditListTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: EditListTableViewCell.reuseIdentifier)
        tableViewDetails.reloadData()
    }
    
    private func setupData(){
        if isEditingObject{
            structValues.firstName = objectContactDetails?.firstName ?? ""
            structValues.lastName = objectContactDetails?.lastName ?? ""
            structValues.mobile = objectContactDetails?.phoneNumber ?? ""
            structValues.email = objectContactDetails?.email ?? ""
            structValues.favourite = objectContactDetails?.favourite ?? false
        }
        tableViewDetails.reloadData()
    }
    
    private func checkIfAllValid() -> Bool {
        if structValues.firstName.trimmingCharacters(in: .whitespaces).count == 0{
            self.showAlerControllerWith(title: "Alert!", message: EditViewModel.validationMessage.emptyFirstName.rawValue)
            return false
        }else if structValues.lastName.trimmingCharacters(in: .whitespaces).count == 0{
            self.showAlerControllerWith(title: "Alert!", message: EditViewModel.validationMessage.emptyLastName.rawValue)
            return false
        }else if structValues.mobile.trimmingCharacters(in: .whitespaces).count == 0{
            self.showAlerControllerWith(title: "Alert!", message: EditViewModel.validationMessage.emptyMobile.rawValue)
            return false
        }else if structValues.email.trimmingCharacters(in: .whitespaces).count == 0{
            self.showAlerControllerWith(title: "Alert!", message: EditViewModel.validationMessage.emptyEmail.rawValue)
            return false
        }
        return true
    }
    
    //MARK: - Actions
    @IBAction func buttonCancelTouchUpInside(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonDoneTouchUpInside(_ sender: Any) {
        self.view.endEditing(true)
        if checkIfAllValid(){
            let jsonDictionary = ["first_name" : structValues.firstName,
                                  "last_name": structValues.lastName,
                                  "email" : structValues.email,
                                  "phone_number" : structValues.mobile,
                                  "favorite": structValues.favourite] as [String : Any]
            if isEditingObject{
                updateContactDetails(parameters: jsonDictionary)
            }else{
                addContactDetails(parameters: jsonDictionary)
            }
        }
    }
}

//MARK: - API Management
extension EditContactViewController {
    private func updateContactDetails(parameters: [String:Any]) {
        self.showIndicator(view: self.view)
        let webURL = webservicesPrefix.updateContact + "\(objectContactDetails?.id ?? 0).json"
        ApiManager.sharedInstance.putRequest(endpointURL: webURL, parameters: parameters) { [weak self](response, error, message, responseData) in
            if let weakSelf = self {
                weakSelf.hideIndicator(view: weakSelf.view)
                if response != nil {
                    let objectDetails = JSON(responseData as Any)
                    let decoder = JSONDecoder()
                    do {
                        let details = try decoder.decode(contactDetailsViewModel.detailsModel.self, from: objectDetails.rawData())
                        weakSelf.delegate?.contactDetailsEdited(objectContact: details)
                        self?.navigationController?.popViewController(animated: true)
                    } catch {
                        //
                    }
                } else {
                     weakSelf.showAlerControllerWith(title: "Error!", message: error?.localizedDescription ?? "")
                }
            }
        }
    }
    
    private func addContactDetails(parameters: [String:Any]) {
        self.showIndicator(view: self.view)
        let webURL = webservicesPrefix.getAllContacts
        ApiManager.sharedInstance.postRequest(endpointURL: webURL, parameters: parameters) { [weak self](response, error, message, responseData) in
            if let weakSelf = self {
                weakSelf.hideIndicator(view: weakSelf.view)
                if response != nil {
                    let objectDetails = JSON(responseData as Any)
                    let decoder = JSONDecoder()
                    do {
                        let details = try decoder.decode(contactDetailsViewModel.detailsModel.self, from: objectDetails.rawData())
                        weakSelf.delegate?.contactDetailsAdded(objectContact: details)
                        self?.navigationController?.popViewController(animated: true)
                    } catch {
                        //
                    }
                } else {
                     weakSelf.showAlerControllerWith(title: "Error!", message: error?.localizedDescription ?? "")
                }
            }
        }
    }
}

//MARK: - TableViewDelegate, TableViewDataSource
extension EditContactViewController: UITableViewDelegate, UITableViewDataSource {
    //Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 186
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView =  tableView.dequeueReusableHeaderFooterView(withIdentifier: EditHeaderView.reuseIdentifier ) as! EditHeaderView
        return headerView
    }
    
    //Row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditViewModel.fields.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditListTableViewCell.reuseIdentifier, for: indexPath) as! EditListTableViewCell
        switch EditViewModel.fields(rawValue: indexPath.row)!{
            
        case .firstName:
            cell.configureCell(key: "First Name", value: structValues.firstName)
            cell.textFieldValue.keyboardType = .default
        case .lastName:
            cell.configureCell(key: "Last Name", value: structValues.lastName)
            cell.textFieldValue.keyboardType = .default
        case .mobile:
            cell.configureCell(key: "Mobile", value: structValues.mobile)
            cell.textFieldValue.keyboardType = .phonePad
        case .email:
            cell.configureCell(key: "Email", value: structValues.email)
            cell.textFieldValue.keyboardType = .emailAddress
        }
        cell.textFieldValue.tag = indexPath.row
        cell.textFieldValue.delegate = self
        return cell
    }
}

//MARK: - TextFieldDelegate
extension EditContactViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch EditViewModel.fields(rawValue: textField.tag)! {
        case .firstName:
            structValues.firstName = textField.text ?? ""
        case .lastName:
            structValues.lastName = textField.text ?? ""
        case .mobile:
            structValues.mobile = textField.text ?? ""
        case .email:
            structValues.email = textField.text ?? ""
        }
    }
}
