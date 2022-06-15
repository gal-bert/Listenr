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
    
    @IBOutlet weak var waveformState: UISwitch!
    @IBAction func handleSwitchWaveform(_ sender: UISwitch) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
