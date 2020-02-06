//
//  ContactListTableViewCell.swift
//  contact
//
//  Created by Pinkesh Gjr on 05/02/20.
//  Copyright © 2020 Pinkesh Gjr. All rights reserved.
//

import UIKit
import SDWebImage

class ContactListTableViewCell: UITableViewCell {

    //MARK:- Property
    @IBOutlet weak var imageViewContact: UIImageView!
    @IBOutlet weak var labelContact: UILabel!
    @IBOutlet weak var buttonFavourite: UIButton!
    
    //MARK:- LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Functions
    private func setupUI(){
        imageViewContact.roundedView()
    }
    
    func configureCell(objectContact: HomeViewModel.homeModelClass){
        imageViewContact.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageViewContact.sd_setImage(with: URL(string: webservicesPrefix.baseURL + (objectContact.profilePic ?? "")), placeholderImage: #imageLiteral(resourceName: "ic_placeholder"), options: .refreshCached, completed: nil)
        labelContact.text = (objectContact.firstName ?? "") + " " + (objectContact.lastName ?? "")
        buttonFavourite.isHidden = !objectContact.favourite
    }
}
