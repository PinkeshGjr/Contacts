//
//  DetailsHeaderView.swift
//  contact
//
//  Created by Pinkesh Gjr on 05/02/20.
//  Copyright © 2020 Pinkesh Gjr. All rights reserved.
//

import UIKit

class DetailsHeaderView: UITableViewHeaderFooterView {

    //MARK:- Property
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var buttonMessage: UIButton!
    @IBOutlet weak var buttonCall: UIButton!
    @IBOutlet weak var buttonEmail: UIButton!
    @IBOutlet weak var buttonFavourite: UIButton!
    
    //MARK:- LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    //MARK:- Functions
    func setupUI() {
        imageViewProfile.circularView(isBorderless: true, borderWidth: 3, borderColor: UIColor.white.cgColor)
    }

}
