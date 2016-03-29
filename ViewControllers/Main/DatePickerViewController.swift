//
//  DatePickerViewController.swift
//  Reecall
//
//  Created by Joshua Archer on 3/10/16.
//  Copyright © 2016 Joshua Archer. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet weak var datePickerView: DatePickerView!
    @IBOutlet weak var capturedImageView: UIImageView!
    
    var capturedImage: UIImage?
    
    private let timeIntervals: [String] = ["hours", "days", "weeks", "months"]
    private var timeArray: [Int] = (1...7).toArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImageForView()
        // Do any additional setup after loading the view.
    }
    
    private func setImageForView() {
        guard let capturedImage = capturedImage else {return}
        capturedImageView.image = capturedImage
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        datePickerView.selectRow(4, inComponent: 0, animated: false)
        datePickerView.selectRow(1, inComponent: 1, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
//        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nextButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("presentTagFriends", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "presentTagFriends" {
            if let nextVC = segue.destinationViewController as? TagFriendsViewController {
                nextVC.capturedImage = self.capturedImage
                nextVC.dateTuple = (datePickerView.selectedRowInComponent(0),datePickerView.selectedRowInComponent(1))
            }
        }
    }

}

extension DatePickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch (component) {
        case 0:
            return timeArray.count
        case 1:
            return timeIntervals.count
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(timeArray[row])
        } else if component == 1 {
            return timeIntervals[row]
        }
        return "weird"
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(40)
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return CGFloat(60)
        } else if component == 1 {
            return CGFloat(100)
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 {
            switch (row) {
            case 0:
                // hours
                self.timeArray = (1...24).toArray()
            case 1:
                // days
                self.timeArray = (1...7).toArray()
            case 2:
                // weeks
                self.timeArray = (1...4).toArray()
            case 3:
                // months
                self.timeArray = (1...12).toArray()
            default:
                self.timeArray = (1...24).toArray()
            }
            pickerView.reloadComponent(0)
        }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var label: UILabel!
        
        if component == 0 {
            label = UILabel(frame: CGRectMake(10, 0, 40, 50))
            label.text = String(timeArray[row])
            label.textAlignment = .Right
        } else if component == 1 {
            label = UILabel(frame: CGRectMake(10, 0, 80, 50))
            label.text = String(timeIntervals[row])
            label.textAlignment = .Left
        }
        label.textColor = UIColor.recallRed()
        label.font = UIFont.boldSystemFontOfSize(20)
        
        return label
    }
    

}






