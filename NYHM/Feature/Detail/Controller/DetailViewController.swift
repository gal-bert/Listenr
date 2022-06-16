//
//  DetailController.swift
//  NYHM
//
//  Created by Hafizh Mo on 12/06/22.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var detailView: DetailView!
    
    var transcription: Transcriptions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailView.setup(data: transcription!, delegate: self)
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
    }
    
}
