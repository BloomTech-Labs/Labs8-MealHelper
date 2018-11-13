//
//  ExpandableButton.swift
//  SlimeButton
//
//  Created by Simon Elhoej Steinmejer on 06/11/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import UIKit

public protocol ExpandableButtonViewDelegate: class {
    func didTapButton(at position: ExpandableButtonPosition)
}

public class ExpandableButtonView: UIView
{
    //MARK - Private properties
    
    private var buttonSizes = CGSize(width: 50, height: 50)
    
    private var mostLeftCenterX: NSLayoutConstraint?
    private var leftCenterX: NSLayoutConstraint?
    private var mostRightCenterX: NSLayoutConstraint?
    private var rightCenterX: NSLayoutConstraint?
    private var lineViewWidth: NSLayoutConstraint?
    private var lineViewHeight: NSLayoutConstraint?
    
    private var isExpanded = false
    
    private var hideSubButtons = true {
        didSet {
            mostLeftButton.isHidden = hideSubButtons
            leftButton.isHidden = hideSubButtons
            mostRightButton.isHidden = hideSubButtons
            rightButton.isHidden = hideSubButtons
        }
    }
    
    private let mainButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(handleAnimation), for: .touchUpInside)
        
        return button
    }()
    
    private let mostLeftButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.zPosition = -1
        button.isHidden = true
        button.addTarget(self, action: #selector(handleSubButton(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    private let leftButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.zPosition = -1
        button.isHidden = true
        button.addTarget(self, action: #selector(handleSubButton(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    private let mostRightButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.zPosition = -1
        button.isHidden = true
        button.addTarget(self, action: #selector(handleSubButton(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    private let rightButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.zPosition = -1
        button.isHidden = true
        button.addTarget(self, action: #selector(handleSubButton(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    private let lineView: UIView =
    {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    //MARK - Public properties
    
    public weak var delegate: ExpandableButtonViewDelegate?
    
    public func buttonImages(main: UIImage, mostLeft: UIImage, left: UIImage, right: UIImage, mostRight: UIImage) {
        mainButton.setImage(main.withRenderingMode(.alwaysTemplate), for: .normal)
        mostLeftButton.setImage(mostLeft.withRenderingMode(.alwaysTemplate), for: .normal)
        leftButton.setImage(left.withRenderingMode(.alwaysTemplate), for: .normal)
        rightButton.setImage(right.withRenderingMode(.alwaysTemplate), for: .normal)
        mostRightButton.setImage(mostRight.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    public func buttonColors(main: UIColor, mostLeft: UIColor, left: UIColor, right: UIColor, mostRight: UIColor) {
        mainButton.tintColor = main
        mostLeftButton.tintColor = mostLeft
        leftButton.tintColor = left
        rightButton.tintColor = right
        mostRightButton.tintColor = mostRight
    }
    
    public var lineWidth: CGFloat = 0.5 {
        didSet {
            lineViewHeight?.constant = lineWidth
            layoutSubviews()
        }
    }
    
    public var lineColor = UIColor.lightGray {
        didSet {
            lineView.backgroundColor = lineColor
        }
    }
    
    public var isLineHidden = false {
        didSet {
            lineView.isHidden = isLineHidden
        }
    }
    
    public var collapseWhenTapped = true
    
    public convenience init(buttonSizes: CGSize) {
        self.init()
        self.buttonSizes = buttonSizes
        setupViews()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    @objc private func handleAnimation()
    {
        hideSubButtons = false
        self.isUserInteractionEnabled = false
        
        lineViewWidth?.constant = isExpanded ? 0 : self.bounds.width
    
        self.mostLeftCenterX?.constant = self.isExpanded ? 0 : -((self.bounds.width / 2) - (buttonSizes.width / 2))

        self.leftCenterX?.constant = self.isExpanded ? 0 : -(((self.bounds.width / 2) - (buttonSizes.width / 2)) / 2)
    
        self.rightCenterX?.constant = self.isExpanded ? 0 : (((self.bounds.width / 2) - (buttonSizes.width / 2)) / 2)

        self.mostRightCenterX?.constant = self.isExpanded ? 0 : ((self.bounds.width / 2) - (buttonSizes.width / 2))
        
        self.mostLeftButton.layer.add(RotateAnimation(clockwise: isExpanded ? true : false), forKey: "transform.rotation")
        self.leftButton.layer.add(RotateAnimation(clockwise: isExpanded ? true : false), forKey: "transform.rotation")
        self.rightButton.layer.add(RotateAnimation(clockwise: isExpanded ? false : true), forKey: "transform.rotation")
        self.mostRightButton.layer.add(RotateAnimation(clockwise: isExpanded ? false : true), forKey: "transform.rotation")
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.superview?.layoutIfNeeded()
            
        }) { (completed) in
        
            self.isExpanded = self.isExpanded ? false : true
            self.isUserInteractionEnabled = true
            self.hideSubButtons = self.isExpanded ? false : true
        }
    }
    
    @objc private func handleSubButton(sender: UIButton) {
        
        if collapseWhenTapped {
            handleAnimation()
        }
        
        switch sender {
        case mostLeftButton:
            delegate?.didTapButton(at: .mostLeft)
        case leftButton:
            delegate?.didTapButton(at: .left)
        case rightButton:
            delegate?.didTapButton(at: .right)
        case mostRightButton:
            delegate?.didTapButton(at: .mostRight)
        default:
            break
        }
    }
    
    private func setupViews()
    {
        addSubview(mostLeftButton)
        addSubview(leftButton)
        addSubview(mostRightButton)
        addSubview(rightButton)
        addSubview(lineView)
        addSubview(mainButton)
        
        mainButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        mainButton.heightAnchor.constraint(equalToConstant: buttonSizes.height).isActive = true
        mainButton.widthAnchor.constraint(equalToConstant: buttonSizes.width).isActive = true
        
        mostLeftCenterX = mostLeftButton.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor)
        mostLeftCenterX?.isActive = true
        mostLeftButton.bottomAnchor.constraint(equalTo: mainButton.bottomAnchor).isActive = true
        mostLeftButton.widthAnchor.constraint(equalToConstant: buttonSizes.width).isActive = true
        mostLeftButton.heightAnchor.constraint(equalToConstant: buttonSizes.height).isActive = true
        
        leftCenterX = leftButton.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor)
        leftCenterX?.isActive = true
        leftButton.bottomAnchor.constraint(equalTo: mainButton.bottomAnchor).isActive = true
        leftButton.widthAnchor.constraint(equalToConstant: buttonSizes.width).isActive = true
        leftButton.heightAnchor.constraint(equalToConstant: buttonSizes.height).isActive = true
        
        mostRightCenterX = mostRightButton.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor)
        mostRightCenterX?.isActive = true
        mostRightButton.bottomAnchor.constraint(equalTo: mainButton.bottomAnchor).isActive = true
        mostRightButton.widthAnchor.constraint(equalToConstant: buttonSizes.width).isActive = true
        mostRightButton.heightAnchor.constraint(equalToConstant: buttonSizes.height).isActive = true
        
        rightCenterX = rightButton.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor)
        rightCenterX?.isActive = true
        rightButton.bottomAnchor.constraint(equalTo: mainButton.bottomAnchor).isActive = true
        rightButton.widthAnchor.constraint(equalToConstant: buttonSizes.width).isActive = true
        rightButton.heightAnchor.constraint(equalToConstant: buttonSizes.height).isActive = true
        
        lineView.topAnchor.constraint(equalTo: mainButton.bottomAnchor, constant: 1).isActive = true
        lineView.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor).isActive = true
        lineViewHeight = lineView.heightAnchor.constraint(equalToConstant: lineWidth)
        lineViewHeight?.isActive = true
        lineViewWidth = lineView.widthAnchor.constraint(equalToConstant: 0)
        lineViewWidth?.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
