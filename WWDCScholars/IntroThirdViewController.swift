//
//  IntroThirdViewController.swift
//  WWDCScholars
//
//  Created by Sam Eckert on 08.05.17.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import UIKit

internal class IntroThirdViewController: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.animator = UIDynamicAnimator(referenceView: self.view)
        self.buttonBoundsDynamicItem = APLPositionToBoundsMapping(target: self.nextButton)
        self.pushBehavior = UIPushBehavior(items: [buttonBoundsDynamicItem], mode: .instantaneous)
        
        setupUI()
    }
    
    internal override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI
    private var animator: UIDynamicAnimator!
    private var buttonBoundsDynamicItem: APLPositionToBoundsMapping!
    private var pushBehavior: UIPushBehavior!
    private var attachmentBehavior: UIAttachmentBehavior!
    
    private func setupUI(){
        // Label text and spacing
        headerLabel.text = "You can \nquote us,"
        headerLabel.addTextSpacing(spacing: 0.8)
        
        bodyLabel.text = "disagree with us, glorify or vilify us. About the only thing you can't do is ignore us. Because we change things. We push the human race forward."
        bodyLabel.addTextSpacing(spacing: 0.4)
        
        // Button text and adaption
        backButton.setTitle("Back", for: .normal)
        nextButton.setTitle("Next", for: .normal)
        
        backButton.layer.cornerRadius = 10
        nextButton.layer.cornerRadius = 10
        
        // UIKit Dynamics
        let attachmentBehavior = UIAttachmentBehavior(item: self.buttonBoundsDynamicItem, attachedToAnchor: self.buttonBoundsDynamicItem.center)
        
        self.attachmentBehavior = attachmentBehavior
        self.attachmentBehavior.frequency = 2.0
        self.attachmentBehavior.damping = 0.1
        self.animator!.addBehavior(self.attachmentBehavior)
        
        nextButton.adjustsImageWhenHighlighted = false
        self.nextButton.addTarget(self, action: #selector(IntroThirdViewController.onDown(sender:)), for: UIControlEvents.touchDown)
        self.nextButton.addTarget(self, action: #selector(IntroThirdViewController.onUp(sender:)), for: UIControlEvents.touchCancel)
        self.nextButton.addTarget(self, action: #selector(IntroThirdViewController.onUp(sender:)), for: UIControlEvents.touchUpInside)
        self.nextButton.addTarget(self, action: #selector(IntroThirdViewController.onUp(sender:)), for: UIControlEvents.touchUpOutside)
        
        backButton.adjustsImageWhenHighlighted = false
        self.backButton.addTarget(self, action: #selector(IntroThirdViewController.onDown(sender:)), for: UIControlEvents.touchDown)
        self.backButton.addTarget(self, action: #selector(IntroThirdViewController.onUp(sender:)), for: UIControlEvents.touchCancel)
        self.backButton.addTarget(self, action: #selector(IntroThirdViewController.onUp(sender:)), for: UIControlEvents.touchUpInside)
        self.backButton.addTarget(self, action: #selector(IntroThirdViewController.onUp(sender:)), for: UIControlEvents.touchUpOutside)
    }
    @objc private func onDown(sender: UIButton) {
        self.attachmentBehavior.damping = 0.1
        self.pushBehavior.angle = CGFloat(Double.pi / 4)
        self.pushBehavior.magnitude = 20
        UIView.animate(withDuration: 0.3, delay: 0, options: .beginFromCurrentState, animations: { sender.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }, completion: {_ in})
        
    }
    @objc private func onUp(sender: UIButton) {
        self.pushBehavior.active = false
        self.attachmentBehavior.damping = 100
        UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .beginFromCurrentState, animations: { sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)}, completion: {_ in})
    }
    
    
    @IBAction func unwindToThird(segue: UIStoryboardSegue) {}
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToSecond", sender: self)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}