//
//  FeedbackFormViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 11/17/15.
//  Copyright © 2015 Joshua Archer. All rights reserved.
//

import UIKit

class FeedbackFormViewController: UIViewController {
    
    private let introString = "Hey! We'd love to hear your feedback so we can make your Recall experience even better. Please speak your mind and be critical, we love that stuff! \n(all responses will be anonymous)"
    private let boxOneString = "If I could change Recall I would..."
    private let boxTwoString = "Something I don't understand is..."
    private let boxThreeString = "When creating a Recall I wish I could..."
    private let boxFourString = "A feature I wish I Recall had is..."
    
    private var scrollView = UIScrollView.newAutoLayoutView()
    private var feedbackLabel = UILabel.newAutoLayoutView()
    
    private var feedBackOneView = UIView.newAutoLayoutView()
    private var feedBackOneForm = UITextView.newAutoLayoutView()
    
    private var feedBackTwoView = UIView.newAutoLayoutView()
    private var feedBackTwoForm = UITextView.newAutoLayoutView()
    
    private var feedBackThreeView = UIView.newAutoLayoutView()
    private var feedBackThreeForm = UITextView.newAutoLayoutView()
    
    private var feedBackFourView = UIView.newAutoLayoutView()
    private var feedBackFourForm = UITextView.newAutoLayoutView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Feedback"
        layoutViews()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        let feedOne = feedBackOneForm.text
        let feedTwo = feedBackTwoForm.text
        let feedThree = feedBackThreeForm.text
        let feedFour = feedBackFourForm.text
        ParseHelper.saveFeedback(feedOne, two: feedTwo, three: feedThree, four: feedFour)
        showThankYouAlert()
    }
    
    func showThankYouAlert() {
        let message = "We love your feedback, thank you so much for helping Recall become the best app it can be!"
        let alert = UIAlertController(title: "Thank you!", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Awesome", style: .Default) { (alertAction) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func layoutViews() {
        self.view.addSubview(scrollView)
        scrollView.autoPinEdgesToSuperviewEdges()
        scrollView.alwaysBounceVertical = true
        
        scrollView.addSubview(feedbackLabel)
        feedbackLabel.autoPinEdge(.Top, toEdge: .Top, ofView: scrollView, withOffset: 8)
        feedbackLabel.autoAlignAxisToSuperviewAxis(.Vertical)
        feedbackLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 20)
        feedbackLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: 20)
        feedbackLabel.lineBreakMode = .ByWordWrapping
        feedbackLabel.numberOfLines = 0
        feedbackLabel.textAlignment = .Center
        feedbackLabel.font = UIFont(name: feedbackLabel.font.fontName, size: 13)
        feedbackLabel.text = introString
        
        scrollView.addSubview(feedBackOneView)
        //feedbackFormView.autoAlignAxisToSuperviewAxis(.Vertical)
        feedBackOneView.autoPinEdge(.Top, toEdge: .Bottom, ofView: feedbackLabel, withOffset: 10)
        feedBackOneView.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        feedBackOneView.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
        feedBackOneView.autoSetDimension(.Height, toSize: 100)
        
        feedBackOneView.addSubview(feedBackOneForm)
        feedBackOneForm.autoPinEdgesToSuperviewEdges()
        feedBackOneForm.backgroundColor = UIColor.lightGrayColor()
        feedBackOneForm.text = boxOneString
        feedBackOneForm.textColor = UIColor.lightTextColor()
        feedBackOneForm.layer.cornerRadius = 5
        feedBackOneForm.delegate = self
        
        scrollView.addSubview(feedBackTwoView)
        feedBackTwoView.autoPinEdge(.Top, toEdge: .Bottom, ofView: feedBackOneView, withOffset: 10)
        feedBackTwoView.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        feedBackTwoView.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
        feedBackTwoView.autoSetDimension(.Height, toSize: 100)
        
        feedBackTwoView.addSubview(feedBackTwoForm)
        feedBackTwoForm.autoPinEdgesToSuperviewEdges()
        feedBackTwoForm.backgroundColor = UIColor.lightGrayColor()
        feedBackTwoForm.text = boxTwoString
        feedBackTwoForm.textColor = UIColor.lightTextColor()
        feedBackTwoForm.layer.cornerRadius = 5
        feedBackTwoForm.delegate = self
        
        scrollView.addSubview(feedBackThreeView)
        feedBackThreeView.autoPinEdge(.Top, toEdge: .Bottom, ofView: feedBackTwoView, withOffset: 10)
        feedBackThreeView.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        feedBackThreeView.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
        feedBackThreeView.autoSetDimension(.Height, toSize: 100)
        
        feedBackThreeView.addSubview(feedBackThreeForm)
        feedBackThreeForm.autoPinEdgesToSuperviewEdges()
        feedBackThreeForm.backgroundColor = UIColor.lightGrayColor()
        feedBackThreeForm.text = boxThreeString
        feedBackThreeForm.textColor = UIColor.lightTextColor()
        feedBackThreeForm.layer.cornerRadius = 5
        feedBackThreeForm.delegate = self
        
        scrollView.addSubview(feedBackFourView)
        feedBackFourView.autoPinEdge(.Top, toEdge: .Bottom, ofView: feedBackThreeView, withOffset: 10)
        feedBackFourView.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        feedBackFourView.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
        feedBackFourView.autoSetDimension(.Height, toSize: 100)
        
        feedBackFourView.addSubview(feedBackFourForm)
        feedBackFourForm.autoPinEdgesToSuperviewEdges()
        feedBackFourForm.backgroundColor = UIColor.lightGrayColor()
        feedBackFourForm.text = boxFourString
        feedBackFourForm.textColor = UIColor.lightTextColor()
        feedBackFourForm.layer.cornerRadius = 5
        feedBackFourForm.delegate = self
    }

    
    private struct Constants {
        static let insets = Device.type == .iPhone5 ? UIEdgeInsets(top: 46, left: 38, bottom: 14, right: 34) : UIEdgeInsets(top: 54, left: 50, bottom: 16, right: 46)
    }
    
}

extension FeedbackFormViewController: UITextViewDelegate {
    func animateScrollWithYPosition(yPosition: Double) {
        UIView.animateWithDuration(0.7) { () -> Void in
            self.scrollView.contentOffset = CGPoint(x: 0, y: yPosition)
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightTextColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        switch textView {
        case feedBackOneForm:
            animateScrollWithYPosition(Double(feedBackOneView.center.y) - 150.0)
        case feedBackTwoForm:
            animateScrollWithYPosition(Double(feedBackTwoView.center.y) - 150.0)
        case feedBackThreeForm:
            animateScrollWithYPosition(Double(feedBackThreeView.center.y) - 150.0)
        case feedBackFourForm:
            animateScrollWithYPosition(Double(feedBackFourView.center.y) - 150.0)
        default:
            break
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            if textView == feedBackOneForm {
                textView.text = boxOneString
            } else if textView == feedBackTwoForm {
                textView.text = boxTwoString
            } else if textView == feedBackThreeForm {
                textView.text = boxThreeString
            } else if textView == feedBackFourForm {
                textView.text = boxFourString
            }
            
            textView.textColor = UIColor.lightTextColor()
        }
    }
}
