//
//  DeepBreathsViewController.swift
//  Caramel
//
//  Created by James Sun on 2014-11-02.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit
import AudioToolbox

class DeepBreathsViewController: UIViewController {

    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var bubbleLabel: UILabel!
    @IBOutlet weak var breathLabel: UILabel!
    
    var bubbleCounter = 1
    var shrinkingDelay = 0.0
    var breathOutCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bubbleLabel.text = String(bubbleCounter)
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Univers-Light-Bold", size: 18)!]
    }
    
    override func viewDidAppear(animated: Bool) {
        self.bubbleCallback()
    }
    
    private func bubbleCallback() -> Void {
        UIView.animateWithDuration(
            3,
            delay: self.shrinkingDelay,
            options: nil,
            animations: {
                if self.breathOutCounter % 2 == 0 {
                    self.breathLabel.text = "Breath Out"
                }
                else {
                    self.breathLabel.text = "Breath In"
                }
                self.breathOutCounter += 1
                self.bubbleView.transform = CGAffineTransformMakeScale(0.5, 0.5)
                self.vibratePhone()
            }, completion: {
                finished in UIView.animateWithDuration(
                    3,
                    delay: 1,
                    options: .AllowUserInteraction,
                    animations: {
                        if self.breathOutCounter % 2 == 0 {
                            self.breathLabel.text = "Breath Out"
                        }
                        else {
                            self.breathLabel.text = "Breath In"
                        }
                        self.breathOutCounter += 1
                        self.bubbleView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                        self.vibratePhone()
                    }, completion: {finished in
                        if self.bubbleCounter < 3 {
                            self.shrinkingDelay = 1.0
                            self.bubbleCounter++
                            self.bubbleLabel.text = String(self.bubbleCounter)
                            self.bubbleCallback()
                        }
                        else {
                            UIView.animateWithDuration(3, animations: {
                                self.bubbleView.transform = CGAffineTransformMakeScale(0.5,0.5)
                                self.breathLabel.text = "Great! You are now focused."
                            })
                        }
                    }
                )
            }
        )
    }
    
    private func vibratePhone() {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
