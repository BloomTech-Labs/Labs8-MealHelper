//
//  AboutCell.swift
//  Labs8-MealHelper
//
//  Created by Simon Elhoej Steinmejer on 03/12/18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class AboutCell: UICollectionViewCell {
    
    let githubImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "GitHub"))
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let aboutLabel: UILabel = {
        let label = UILabel()
        label.text = "This app was created as part of the Lambda School Labs project. It's purpose is to empower a user to discover what foods make them feel their best."
        label.numberOfLines = 0
        label.font = Appearance.appFont(with: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        
        return label
    }()
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.backgroundColor = .clear
        sv.indicatorStyle = .white
        
        return sv
    }()
    
    let iOSLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS"
        label.font = Appearance.appFont(with: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        
        return label
    }()
    
    let iOSSeperatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0.8, alpha: 0.7)
        
        return view
    }()
    
    lazy var simonLabel: UILabel = {
        let label = UILabel()
        label.attributedText = creditText(with: "Simon Elhoej Steinmejer", github: "GitHub.com/Elhoej")
        label.sizeToFit()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    lazy var stefanoLabel: UILabel = {
        let label = UILabel()
        label.attributedText = creditText(with: "Stefano Demicheli", github: "GitHub.com/stdemicheli")
        label.sizeToFit()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    let webLabel: UILabel = {
        let label = UILabel()
        label.text = "Web & Backend"
        label.font = Appearance.appFont(with: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        
        return label
    }()
    
    let webSeperatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0.8, alpha: 0.7)
        
        return view
    }()
    
    lazy var caseyLabel: UILabel = {
        let label = UILabel()
        label.attributedText = creditText(with: "Casey Baker", github: "GitHub.com/abravebee")
        label.sizeToFit()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    lazy var josephLabel: UILabel = {
        let label = UILabel()
        label.attributedText = creditText(with: "Joseph Bradley", github: "GitHub.com/jmbradley")
        label.sizeToFit()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    lazy var patrickLabel: UILabel = {
        let label = UILabel()
        label.attributedText = creditText(with: "Patrick Thompson", github: "GitHub.com/PatrickTheCodeGuy")
        label.sizeToFit()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    lazy var haywoodLabel: UILabel = {
        let label = UILabel()
        label.attributedText = creditText(with: "Haywood D. Johnson", github: "GitHub.com/LordOrbnauticus")
        label.sizeToFit()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    let pmLabel: UILabel = {
        let label = UILabel()
        label.text = "Project Manager"
        label.font = Appearance.appFont(with: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        
        return label
    }()
    
    let pmSeperatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0.8, alpha: 0.7)
        
        return view
    }()
    
    lazy var keithLabel: UILabel = {
        let label = UILabel()
        label.attributedText = creditText(with: "\"Chief\" Keith H.", github: "GitHub.com/kkhaag")
        label.numberOfLines = 0
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupViews()
        setupGestureRecognizer()
    }
    
    private func setupGestureRecognizer() {
        let tapLinkGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openLink(sender:)))
        tapLinkGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapLinkGestureRecognizer)
    }
    
    @objc private func openLink(sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: scrollView)
        
        if simonLabel.frame.contains(location) {
            UIApplication.shared.open(URL(string: "https://github.com/Elhoej")!, options: [:], completionHandler: nil)
        } else if stefanoLabel.frame.contains(location) {
            UIApplication.shared.open(URL(string: "https://github.com/stdemicheli")!, options: [:], completionHandler: nil)
        } else if caseyLabel.frame.contains(location) {
            UIApplication.shared.open(URL(string: "https://github.com/abravebee")!, options: [:], completionHandler: nil)
        } else if josephLabel.frame.contains(location) {
            UIApplication.shared.open(URL(string: "https://github.com/jmbradley")!, options: [:], completionHandler: nil)
        } else if patrickLabel.frame.contains(location) {
            UIApplication.shared.open(URL(string: "https://github.com/PatrickTheCodeGuy")!, options: [:], completionHandler: nil)
        } else if haywoodLabel.frame.contains(location) {
            UIApplication.shared.open(URL(string: "https://github.com/LordOrbnauticus")!, options: [:], completionHandler: nil)
        } else if keithLabel.frame.contains(location) {
            UIApplication.shared.open(URL(string: "https://github.com/kkhaag")!, options: [:], completionHandler: nil)
        }
    }
    
    private func setupViews() {
        addSubview(aboutLabel)
        aboutLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 20, left: 30, bottom: 0, right: 30))
        
        let width = self.frame.width - 60
        
        addSubview(scrollView)
        scrollView.anchor(top: aboutLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0))
        
        scrollView.addSubview(iOSLabel)
        iOSLabel.anchor(top: scrollView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0), size: CGSize(width: width, height: 0))
        iOSLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        scrollView.addSubview(iOSSeperatorLine)
        iOSSeperatorLine.anchor(top: iOSLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 4, left: 70, bottom: 0, right: 0), size: CGSize(width: width - 80, height: 0.5))
        
        scrollView.addSubview(simonLabel)
        simonLabel.anchor(top: iOSSeperatorLine.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 30, bottom: 0, right: 0), size: CGSize(width: width, height: 0))
        
        scrollView.addSubview(stefanoLabel)
        stefanoLabel.anchor(top: simonLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 30, bottom: 0, right: 0), size: CGSize(width: width, height: 0))
        
        scrollView.addSubview(webLabel)
        webLabel.anchor(top: stefanoLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 50, left: 30, bottom: 0, right: 0), size: CGSize(width: width, height: 0))
        
        scrollView.addSubview(webSeperatorLine)
        webSeperatorLine.anchor(top: webLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 4, left: 70, bottom: 0, right: 0), size: CGSize(width: width - 80, height: 0.5))
        
        scrollView.addSubview(caseyLabel)
        caseyLabel.anchor(top: webSeperatorLine.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 30, bottom: 0, right: 0), size: CGSize(width: width, height: 0))
        
        scrollView.addSubview(josephLabel)
        josephLabel.anchor(top: caseyLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 30, bottom: 0, right: 0), size: CGSize(width: width, height: 0))
        
        scrollView.addSubview(patrickLabel)
        patrickLabel.anchor(top: josephLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 30, bottom: 0, right: 0), size: CGSize(width: width, height: 0))
        
        scrollView.addSubview(haywoodLabel)
        haywoodLabel.anchor(top: patrickLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 30, bottom: 0, right: 0), size: CGSize(width: width, height: 0))
        
        scrollView.addSubview(pmLabel)
        pmLabel.anchor(top: haywoodLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 50, left: 30, bottom: 0, right: 0), size: CGSize(width: width, height: 0))
        
        scrollView.addSubview(pmSeperatorLine)
        pmSeperatorLine.anchor(top: pmLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 4, left: 70, bottom: 0, right: 0), size: CGSize(width: width - 80, height: 0.5))
        
        scrollView.addSubview(keithLabel)
        keithLabel.anchor(top: pmSeperatorLine.bottomAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 0), size: CGSize(width: width, height: 0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creditText(with name: String, github: String) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(name)\n", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: Appearance.appFont(with: 14)])
        attributedText.append(NSAttributedString(string: github, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.underlineColor: UIColor.white, NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: Appearance.appFont(with: 14)]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 3
        
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.string.count))
        
        return attributedText
    }
}

extension AboutCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        return false
    }
}

