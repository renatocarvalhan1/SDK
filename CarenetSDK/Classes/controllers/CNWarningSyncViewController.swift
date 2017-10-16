//
//  CNWarningSyncViewController.swift
//  CarenetSDK
//
//  Created by Renato Carvalhan on 07/10/17.
//

import UIKit
import VisualEffectView

enum StatusSync {
    case Progress
    case Success
    case Error
    case NotFound
}

class CNWarningSyncViewController: CNBaseViewController {
    
    @IBOutlet var centerView: UIView!
    @IBOutlet var viewWithOneButton: UIView!
    @IBOutlet var viewWithTwoButtons: UIView!
    @IBOutlet var firstButton: UIButton!
    @IBOutlet var secondButton: UIButton!
    @IBOutlet var syncLabel: UILabel!
    @IBOutlet var logoView: UIImageView!
    @IBOutlet var deviceNameLabel: UILabel!
    @IBOutlet var syncView: UIImageView!
    @IBOutlet var loading: UIActivityIndicatorView!
    
    var statusSync: StatusSync!
    var connection: CNConnection!
    
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
        statusSync = .Progress
        
        logoView.sd_setImage(with: URL(string: connection.deviceIconURL!), completed: nil)
        deviceNameLabel.text = connection.deviceDisplayName!
        loading.hidesWhenStopped = true
        
        setLayout()
        animateIn()
    }
    
    func setLayout() {
        switch statusSync {
        case .Progress:
            loading.startAnimating()
            syncLabel.text = "Sincronizando..."
            firstButton.setTitle("Cancel", for: .normal)
            firstButton.addTarget(self, action: #selector(close(_:)), for: .touchUpInside)
            viewWithTwoButtons.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.statusSync = .Success
                self.setLayout()
            })
            return
        case .Success:
            loading.stopAnimating()
            syncLabel.text = "Sincronizado com sucesso"
            syncView.image = UIImage.init(named: "icon-checked", in: CarenetSDK.shared.bundle, compatibleWith: nil)
            firstButton.setTitle("OK, obrigado!", for: .normal)
            return
        case .Error:
            firstButton.setTitle("Cancel", for: .normal)
            viewWithTwoButtons.isHidden = true
            return
        default:
            return
        }
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
