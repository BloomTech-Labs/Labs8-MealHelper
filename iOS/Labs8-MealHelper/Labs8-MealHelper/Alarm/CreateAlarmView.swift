//
//  CreateAlarmView.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 27/11/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

protocol CreateAlarmViewDelegate: class {
    func shouldAnimateView()
    func didSetAlarm(with time: String, note: String)
}

class CreateAlarmView: UIView {
    
    weak var delegate: CreateAlarmViewDelegate?
    var isCollapsed = true
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 70, green: 170, blue: 255)
        
        return view
    }()
    
    let addAlarmLabel: UILabel = {
        let label = UILabel()
        label.text = "Schedule meal"
        label.textColor = .white
        label.font = Appearance.appFont(with: 16)
        label.sizeToFit()
        
        return label
    }()
    
    let addAlarmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(addAlarm), for: .touchUpInside)
        
        return button
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.setValue(UIColor.white, forKey: "textColor")
//        datePicker.setValue(Appearance.appFont(with: 16), forKey: "font")
        
        return datePicker
    }()
    
    let colonLabel: UILabel = {
        let label = UILabel()
        label.text = ":"
        label.font = Appearance.appFont(with: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let seperatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.alpha = 0.5
        
        return view
    }()
    
    let noteLabel: UILabel = {
        let label = UILabel()
        label.text = "NOTE"
        label.font = Appearance.appFont(with: 12)
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }()
    
    let noteTextField: LeftIconTextField = {
        let tf = LeftIconTextField()
        tf.leftImage = #imageLiteral(resourceName: "note")
        tf.tintColor = .mountainBlue
        
        return tf
    }()
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = Appearance.appFont(with: 16)
        button.setTitleColor(.white, for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mountainBlue
        layer.cornerRadius = 8
        layer.masksToBounds = true
        setupViews()
    }
    
    @objc func addAlarm() {
        
        if isCollapsed {
            delegate?.shouldAnimateView()
        } else {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.locale = Locale(identifier: "en_GB")
            let timeString = formatter.string(from: datePicker.date)
            let timeValue = timeString.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ":", with: "")
            delegate?.didSetAlarm(with: timeValue, note: noteTextField.text ?? "")
        }
    }
    
    @objc private func handleDone() {
        noteTextField.resignFirstResponder()
    }
    
    private func setupViews() {

        setupHeaderView()
        
        addSubview(datePicker)
        datePicker.anchor(top: headerView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 30, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 200))
        
        addSubview(colonLabel)
        colonLabel.centerYAnchor.constraint(equalTo: datePicker.centerYAnchor).isActive = true
        colonLabel.centerXAnchor.constraint(equalTo: datePicker.centerXAnchor, constant: -5).isActive = true
        
        addSubview(seperatorLine)
        seperatorLine.anchor(top: datePicker.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: CGSize(width: 0, height: 0.5))
        
        addSubview(noteTextField)
        noteTextField.anchor(top: seperatorLine.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 30, left: 30, bottom: 0, right: 30), size: CGSize(width: 0, height: 40))
        
        addSubview(noteLabel)
        noteLabel.anchor(top: nil, leading: noteTextField.leadingAnchor, bottom: noteTextField.topAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 4, bottom: 4, right: 0))
        
        addSubview(doneButton)
        doneButton.anchor(top: noteTextField.bottomAnchor, leading: noteTextField.leadingAnchor, bottom: nil, trailing: noteTextField.trailingAnchor, padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 30))
    }
    
    private func setupHeaderView() {
        
        addSubview(headerView)
        headerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: CGSize(width: 0, height: 60))
        
        headerView.addSubview(addAlarmLabel)
        headerView.addSubview(addAlarmButton)
        
        addAlarmLabel.anchor(top: nil, leading: headerView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        addAlarmLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        addAlarmButton.anchor(top: nil, leading: nil, bottom: nil, trailing: headerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16), size: CGSize(width: 30, height: 30))
        addAlarmButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
