//
//  CNMyDevicesCell.swift
//  CarenetSDK
//
//  Created by Renato Carvalhan on 08/10/17.
//

import UIKit

class CNMyDevicesCell: CNBaseCell {

    @IBOutlet var logoView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var syncButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var arrowView: UIImageView!

    var isExpanded: Bool = false

    func performIndicatorAnimation(up: Bool) {
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        if !up {
            anim.fromValue = CGFloat.pi
        }
        
        anim.toValue = up ? CGFloat.pi : CGFloat.pi * 2
        anim.duration = 0.25
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anim.fillMode = kCAFillModeForwards
        anim.isRemovedOnCompletion = false
        arrowView.layer.add(anim, forKey: "rotation_animation")
    }
    
}
