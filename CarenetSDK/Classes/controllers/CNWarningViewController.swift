//
//  CNWarningViewController.swift
//  CarenetSDK
//
//  Created by Renato Carvalhan on 09/10/17.
//

import UIKit
import VisualEffectView

class CNWarningViewController: CNBaseViewController {

    @IBOutlet var centerView: UIView!
    
    @IBOutlet var blurView: VisualEffectView!{
        didSet {
            blurView.colorTint = UIColor.black
            blurView.colorTintAlpha = 0.2
            blurView.blurRadius = 5
            blurView.scale = 1
        }
    }
    
    var effect: UIVisualEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        effect = blurView.effect
        blurView.effect = nil
        
        animateIn()
    }
    
    func animateIn(){
        centerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        centerView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.blurView.effect = self.effect
            self.centerView.alpha = 1
            self.centerView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.blurView.effect = nil
            self.centerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.centerView.alpha = 0
            
        }) { (finished) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func close(_ sender: Any) {
        animateOut()
    }
}
