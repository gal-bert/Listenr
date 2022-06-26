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
    func sortBy(type: SortType)
    func showTranscriptionModal()
}
