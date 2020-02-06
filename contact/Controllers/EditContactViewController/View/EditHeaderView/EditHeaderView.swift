//
//  EditHeaderView.swift
//  contact
//
//  Created by Pinkesh Gjr on 05/02/20.
//  Copyright © 2020 Pinkesh Gjr. All rights reserved.
//

import UIKit

class EditHeaderView: UITableViewHeaderFooterView {

    //MARK:- Property
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var buttonCamera: UIButton!
    
    //MARK:- LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    //MARK:- Functions
    private func setupUI() { 
        imageViewProfile.circularView(isBorderless: true, borderWidth: 3.0, borderColor: UIColor.white.cgColor)
    }

}
