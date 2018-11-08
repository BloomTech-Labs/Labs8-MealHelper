//
//  MealTableViewCell.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 08.11.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    
    var meal: String? {
        didSet {
            setupViews()
        }
    }
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 30.0
        return stackView
    }()
    
    private let selectIcon : UIImageView = {
        let iv = UIImageView(image: UIImage(named: "add")!.withRenderingMode(.alwaysTemplate))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .gray
        
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.textAlignment = .center
        label.text = "Meal"
        label.font = UIFont.systemFont(ofSize: 17.0)
        return label
    }()
    
    private let servingQtyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.textAlignment = .center
        label.text = "5 cups"
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupViews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(imageView!)
        mainStackView.addArrangedSubview(labelStackView)
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(servingQtyLabel)
        
        
        
    }

}
