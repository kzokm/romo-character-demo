//
//  ViewController.swift
//  RomoCharacterDemo
//
//  Created by Kz OKAMURA on 2014/07/11.
//  Copyright (c) 2014 Techlier Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var romo: RMCharacter?

    override func viewDidLoad() {
        super.viewDidLoad()
        romo = RMCharacter.Romo()
    }

    var picker: UIPickerView?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        romo?.addToSuperview(view)

        picker = ({ (parent: UIView)-> UIPickerView in
            var picker = UIPickerView()
            picker.dataSource = self
            picker.delegate = self
            let frame = picker.frame
            picker.frame = CGRectMake(0, parent.frame.height - frame.height,
                                      frame.width, frame.height)
            parent.addSubview(picker)
            return picker
        })(view)
        
        println(RMCharacterExpressionSad)
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        romo?.removeFromSuperview
    }

    let emotions = [
        "Curious",
        "Excited",
        "Happy",
        "Sad",
        "Scared",
        "Sleepy",
        "Sleeping",
        "Indifferent",
        "Bewildered",
        "Delighted"
    ]

    let expressions = [
        "None",
        "Angry",
        "Bored",
        "Curious",
        "Dizzy",
        "Embarrassed",
        "Excited",
        "Exhausted",
        "Happy",
        "HoldingBreath",
        "Laugh",
        "LookingAround",
        "Love",
        "Ponder",
        "Sad",
        "Scared",
        "Sleepy",
        "Sneeze",
        "Talking",
        "Yawn",
        "Startled",
        "Chuckle",
        "Proud",
        "LetDown",
        "Want",
        "Hiccup",
        "Fart",
        "Bewildered",
        "Yippee",
        "Sniff",
        "Smack",
        "Wee",
        "Struggling",
    ]

    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 2;
    }

    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return component == 0
            ? expressions.count
            : emotions.count
    }

    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return component == 0
            ? expressions[row]
            : emotions[row]
    }

    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            let expression = UInt32(row)
            romo?.setExpression(RMCharacterExpression(expression), withEmotion: romo!.emotion)
        }
        else {
            let emotion = UInt32(row + 1)
            romo?.setExpression(RMCharacterExpressionNone, withEmotion: RMCharacterEmotion(emotion))
        }
    }


    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        let touchLocation = touches.anyObject().locationInView(view)
        lookAtTouchLocation(touchLocation)
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        let touchLocation = touches.anyObject().locationInView(view)
        lookAtTouchLocation(touchLocation)
    }
    
    func lookAtTouchLocation(touchLocation: CGPoint) {
        let w_2 = self.view.frame.size.width / 2
        let h_2 = self.view.frame.size.height / 2
        
        let x = (touchLocation.x - w_2) / w_2
        let y = (touchLocation.y - h_2) / h_2
        let z: CGFloat = 0.0
        let lookPoint = RMPoint3D(x: x, y: y, z: z)
        romo?.lookAtPoint(lookPoint, animated: false)
    }

    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        romo?.lookAtDefault()
        
        var expression = picker!.selectedRowInComponent(0) + 1
        if (expression >= expressions.count) {
            expression = 0
        }
        picker?.selectRow(expression, inComponent: 0, animated: true)
        romo?.setExpression(RMCharacterExpression(UInt32(expression)), withEmotion: romo!.emotion)
    }

    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        romo?.lookAtDefault()
    }

}
