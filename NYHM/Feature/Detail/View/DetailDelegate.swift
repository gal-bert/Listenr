//
//  DetailDelegate.swift
//  NYHM
//
//  Created by Hafizh Mo on 15/06/22.
//

import Foundation
import UIKit

protocol DetailDelegate {
    func didTapPlay(sender: UIButton)
    func didTapBackward()
    func didTapForward()
    func didTapTags()
    func didTapShare()
}
