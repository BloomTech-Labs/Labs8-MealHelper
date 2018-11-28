//
//  AlarmCell.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 28/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class AlarmCell: UITableViewCell {
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Appearance.appFont(with: 30)
        label.sizeToFit()
        label.text = "19:30"
        
        return label
    }()
    
    let noteLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(white: 0.85, alpha: 1)
        label.font = Appearance.appFont(with: 13)
        label.sizeToFit()
        label.text = "Dinner"
        
        return label
    }()
    
    let stateSwitch: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = .mountainBlue
        sw.tintColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        sw.thumbTintColor = .white
        sw.isOn = true
        
        return sw
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupViews()
    }
    
    private func setupViews() {
        addSubview(timeLabel)
        timeLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 0), size: .zero)
        
        addSubview(noteLabel)
        noteLabel.anchor(top: timeLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0), size: .zero)
        
        addSubview(stateSwitch)
        stateSwitch.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12), size: .zero)
        stateSwitch.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
