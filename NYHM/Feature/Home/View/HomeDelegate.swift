//
//  HomeDelegate.swift
//  NYHM
//
//  Created by Hafizh Mo on 15/06/22.
//

import Foundation
import UIKit

protocol HomeDelegate: AnyObject {
    func chooseLanguage()
    func sortByName()
    func sortByDate()
    func showTranscriptionModal()
}
