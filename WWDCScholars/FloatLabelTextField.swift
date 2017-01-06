//
//  FloatLabelTextField.swift
//  FloatLabelFields
//
//  Created by Fahim Farook on 28/11/14.
//  Copyright (c) 2014 RookSoft Ltd. All rights reserved.
//
//  Original Concept by Matt D. Smith
//  http://dribbble.com/shots/1254439--GIF-Mobile-Form-Interaction?list=users
//
//  Objective-C version by Jared Verdi
//  https://github.com/jverdi/JVFloatLabeledTextField
//

import UIKit

@IBDesignable class FloatLabelTextField: UITextField {
	let animationDuration = 0.3
	var title = UILabel()
	
	// MARK:- Properties
	override var accessibilityLabel:String! {
		get {
			if text!.isEmpty {
				return title.text
			} else {
				return text
			}
		}
		set {
			self.accessibilityLabel = newValue
		}
	}
	
	override var placeholder:String? {
		didSet {
			title.text = placeholder
			title.sizeToFit()
		}
	}
	
	override var attributedPlaceholder:NSAttributedString? {
		didSet {
			title.text = attributedPlaceholder?.string
			title.sizeToFit()
		}
	}
	
	var titleFont:UIFont = UIFont.systemFont(ofSize: 12.0) {
		didSet {
			title.font = titleFont
			title.sizeToFit()
		}
	}
	
	@IBInspectable var hintYPadding:CGFloat = 0.0

	@IBInspectable var titleYPadding:CGFloat = 0.0 {
		didSet {
			var r = title.frame
			r.origin.y = titleYPadding
			title.frame = r
		}
	}
	
	@IBInspectable var titleTextColour:UIColor = UIColor.gray {
		didSet {
			if !isFirstResponder {
				title.textColor = titleTextColour
			}
		}
	}
	
	@IBInspectable var titleActiveTextColour:UIColor! {
		didSet {
			if isFirstResponder {
				title.textColor = titleActiveTextColour
			}
		}
	}
	
	// MARK:- Init
	required init(coder aDecoder:NSCoder) {
		super.init(coder:aDecoder)!
		setup()
	}
	
	override init(frame:CGRect) {
		super.init(frame:frame)
		setup()
	}
	
	// MARK:- Overrides
	override func layoutSubviews() {
		super.layoutSubviews()
		setTitlePositionForTextAlignment()
		let isResp = isFirstResponder
		if isResp && !text!.isEmpty {
			title.textColor = titleActiveTextColour
		} else {
			title.textColor = titleTextColour
		}
		// Should we show or hide the title label?
		if text!.isEmpty {
			// Hide
			hideTitle(isResp)
		} else {
			// Show
			showTitle(isResp)
		}
	}
	
	override func textRect(forBounds bounds:CGRect) -> CGRect {
		var r = super.textRect(forBounds: bounds)
		if !text!.isEmpty {
			var top = ceil(title.font.lineHeight + hintYPadding)
			top = min(top, maxTopInset())
			r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0.0, 0.0, 0.0))
		}
		return r.integral
	}
	
	override func editingRect(forBounds bounds:CGRect) -> CGRect {
		var r = super.editingRect(forBounds: bounds)
		if !text!.isEmpty {
			var top = ceil(title.font.lineHeight + hintYPadding)
			top = min(top, maxTopInset())
			r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0.0, 0.0, 0.0))
		}
		return r.integral
	}
	
	override func clearButtonRect(forBounds bounds:CGRect) -> CGRect {
		var r = super.clearButtonRect(forBounds: bounds)
		if !text!.isEmpty {
			var top = ceil(title.font.lineHeight + hintYPadding)
			top = min(top, maxTopInset())
			r = CGRect(x:r.origin.x, y:r.origin.y + (top * 0.5), width:r.size.width, height:r.size.height)
		}
		return r.integral
	}
	
	// MARK:- Public Methods
	
	// MARK:- Private Methods
	fileprivate func setup() {
		borderStyle = UITextBorderStyle.none
		titleActiveTextColour = tintColor
		// Set up title label
		title.alpha = 0.0
		title.font = titleFont
		title.textColor = titleTextColour
		if let str = placeholder {
			if !str.isEmpty {
				title.text = str
				title.sizeToFit()
			}
		}
        
        self.layer.cornerRadius = 5
        
        let paddingView = UIView(frame: CGRect(x: 0,y: 0,width: 10,height: 50))
        self.leftView = paddingView
        self.leftViewMode = UITextFieldViewMode.always
        self.rightView = paddingView
        self.rightViewMode = UITextFieldViewMode.always
        
		self.addSubview(title)
	}

	fileprivate func maxTopInset()->CGFloat {
		return max(0, floor(bounds.size.height - font!.lineHeight - 4.0))
	}
	
	fileprivate func setTitlePositionForTextAlignment() {
		let r = textRect(forBounds: bounds)
		var x = r.origin.x
		if textAlignment == NSTextAlignment.center {
			x = r.origin.x + (r.size.width * 0.5) - title.frame.size.width
		} else if textAlignment == NSTextAlignment.right {
			x = r.origin.x + r.size.width - title.frame.size.width
		}
		title.frame = CGRect(x:x, y:title.frame.origin.y, width:title.frame.size.width, height:title.frame.size.height)
	}
	
	fileprivate func showTitle(_ animated:Bool) {
		let dur = animated ? animationDuration : 0
		UIView.animate(withDuration: dur, delay:0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseOut], animations:{
				// Animation
				self.title.alpha = 1.0
				var r = self.title.frame
				r.origin.y = self.titleYPadding
				self.title.frame = r
			}, completion:nil)
	}
	
	fileprivate func hideTitle(_ animated:Bool) {
		let dur = animated ? animationDuration : 0
		UIView.animate(withDuration: dur, delay:0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseIn], animations:{
			// Animation
			self.title.alpha = 0.0
			var r = self.title.frame
			r.origin.y = self.title.font.lineHeight + self.hintYPadding
			self.title.frame = r
			}, completion:nil)
	}
}
