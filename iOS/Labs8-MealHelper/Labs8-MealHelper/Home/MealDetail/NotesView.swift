//
//  NotesView.swift
//  Labs8-MealHelper
//
//  Created by De MicheliStefano on 12.12.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class NotesView: UITextView {

    var note: String? {
        didSet {
            updateViews()
        }
    }
    var fontSize: CGFloat = 15.0
    private let padding: CGFloat = 15.0
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        self.text = "Add a note"
        self.font = Appearance.appFont(with: fontSize)
        self.textColor = UIColor.lightGray
        self.textContainerInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    private func updateViews() {
        guard let note = note, note != "" else { return }
        self.text = note
        self.textColor = .black
    }
    
}
