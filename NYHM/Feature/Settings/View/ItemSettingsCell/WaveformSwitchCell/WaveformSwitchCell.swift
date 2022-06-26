//
//  WaveformSwitchCell.swift
//  NYHM
//
//  Created by Rizki Faris on 14/06/22.
//

import Foundation
import UIKit


class WaveformSwitchCell : UITableViewCell {
    
    static let identifier = "waveformCellSB"
    
    static func nib() -> UINib {
        return UINib(nibName: "waveformCellSB", bundle: nil)
    }
    
    let isWaveformVisible = UserDefaults.standard.bool(forKey: Constants.IS_WAVEFORM_VISIBLE)
    
    @IBOutlet weak var viewWaveform: UIView!
    @IBOutlet weak var waveformState: UISwitch!
    @IBAction func handleSwitchWaveform(_ sender: UISwitch) {
        UserDefaults.standard.set(waveformState.isOn, forKey: Constants.IS_WAVEFORM_VISIBLE)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewWaveform?.layer.cornerRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        waveformState.setOn(isWaveformVisible, animated: true)
    }
}
