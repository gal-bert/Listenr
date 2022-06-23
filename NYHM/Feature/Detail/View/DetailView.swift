//
//  DetailView.swift
//  NYHM
//
//  Created by Hafizh Mo on 14/06/22.
//

import AVFoundation
import UIKit

class DetailView: UIView {
    
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    @IBOutlet weak var durationLeftLabel: UILabel!
    @IBOutlet weak var durationCurrentLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet var tagToSuperView: NSLayoutConstraint!
    
    var timer: Timer?
    var isInterruptable = false
    var player: AVAudioPlayer?
    var maxLabelWidth: CGFloat?
    
    var helpTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textColor = .white
        return label
    }()
    
    var temporaryData: Transcriptions!
    var popOverButton: UIBarButtonItem = UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis"))
    
    private var delegate: DetailDelegate?
    
    func setup(data: Transcriptions, delegate: DetailDelegate) {
        self.delegate = delegate
//        generatePopOverMenu()
        
        addSubview(helpTimeLabel)
        temporaryData = data
        
        titleTextView.text = data.title
        resultTextView.text = data.result
        
        createdAtLabel.text = data.createdAt?.fixedFormat()
        durationLabel.text = data.duration
        
        maxLabelWidth = tagsLabel.frame.width
        tagsLabel.text = data.tags == "Untagged" ? "Add Tags" : data.tags
        self.delegate?.checkTagTruncate()
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filename = path.appendingPathComponent(data.filename!) // URL
        
        do {
            player = try AVAudioPlayer(contentsOf: filename)
        }
        catch {
            print(error.localizedDescription)
        }
        
        progressBar.progress = 0
        durationLeftLabel.text = "-\(convertToString(by: player!.duration - player!.currentTime) ?? "00:00")"
        
        playButton.setImage(UIImage(systemName: "play.fill")?.middImage(), for: .normal)
        playButton.addTarget(self, action: #selector(clickPlayButton), for: .touchUpInside)
        
        setTouchGestureToProgressBar()
    }
    
    func setTouchGestureToProgressBar() {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(touchProgressBar(sender:)))
        longGesture.minimumPressDuration = 0.01
        progressBar.addGestureRecognizer(longGesture)
    }
    
    @objc func touchProgressBar( sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            isInterruptable = true
            animateProgressBar()
        case .ended:
            isInterruptable = false
            animateProgressBar()
            guard let currentTime = convertToTimeInterval(by: player, progressBar, sender) else { return }
            player?.currentTime = currentTime
            changeView(isFromButton: true, sender: sender)
            
        default:
            changeView(isFromButton: false, sender: sender)
        }
        showHelpTimeLabel(by: sender, text: convertToString(by: player, progressBar, sender))
    }
    
    func animateProgressBar() {
        UIView.animate(withDuration: 0.1) {
            self.progressBar.transform = self.isInterruptable ? CGAffineTransform(scaleX: 1.0, y: 1.6) :  CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    @objc func clickPlayButton() {
        guard let player = player else { return }
        if player.isPlaying {
            stopPlayer()
        } else {
            startPlayer()
        }
    }
    
    func stopPlayer() {
        guard let player = player else { return }
        player.stop()
        timer?.invalidate()
        playButton.setImage(UIImage(systemName: "play.fill")?.middImage(), for: .normal)
    }
    
    func startPlayer() {
        guard let player = player else { return }
        player.play()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerBehavior), userInfo: nil, repeats: true)
        playButton.setImage(UIImage(systemName: "pause.fill")?.middImage(), for: .normal)
    }
    
    @objc func timerBehavior() {
        guard let player = player else { return }
        let percent = player.currentTime/player.duration
        if percent == 0 {
            stopPlayer()
        }
        
        if !isInterruptable {
            changeView(isFromButton: true, sender: nil)
        }
    }
    
    func changeView(isFromButton: Bool, sender: UILongPressGestureRecognizer? ) {
        guard let player = player else { return }
        
        if isFromButton {
            durationCurrentLabel.text = convertToString(by: player.currentTime)
            durationLeftLabel.text = "-\(convertToString(by: player.duration - player.currentTime) ?? "00:00")"
            progressBar.progress = convertToProgressBarPercent(by: player)
        } else {
            durationCurrentLabel.text = convertToString(by: player, progressBar, sender)
            if let progress = convertToTimeInterval(by: player, progressBar, sender) {
                progressBar.progress = Float(progress / player.duration)
            }
        }
    }
    
    @IBAction func didTapBackward(_ sender: UIButton) {
        delegate?.didTapBackward()
        skip(value: -15.0)
    }
    
    @IBAction func didTapForward(_ sender: UIButton) {
        delegate?.didTapForward()
        skip(value: 15.0)
    }
    
    @IBAction func didTapTags(_ sender: Any) {
        delegate?.didTapTags()
    }
    
    private func skip(value: Double) {
        guard let player = player else { return }
        var time = player.currentTime
        time += value
//        if (time > player.duration) {
//            // stop, track skip or whatever you want
//        } else {
            player.currentTime = time;
//        }
        
        changeView(isFromButton: true, sender: nil)
    }
    
    func showHelpTimeLabel(by sender: UILongPressGestureRecognizer, text: String?) {
        var loc = sender.location(in: self)
        loc.x = max(loc.x, progressBar.frame.minX)
        loc.x = min(loc.x, progressBar.frame.maxX)
        
        helpTimeLabel.text = text
        let width = helpTimeLabel.intrinsicContentSize.width
        let height = helpTimeLabel.intrinsicContentSize.height
        
        helpTimeLabel.frame.origin = CGPoint(x: loc.x-(width/2),
                                             y: progressBar.frame.minY-20)
        helpTimeLabel.frame.size = CGSize(width: width, height: height)
        helpTimeLabel.isHidden = isInterruptable ? false : true
    }
    
    @objc func generatePopOverMenu() {
        
        let shareHandle = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), handler: { (_) in
            self.delegate?.didTapShare()
        })
        
        
        let deleteHandle = UIAction(title: "Delete", image: UIImage(systemName: "trash")?.withTintColor(.red, renderingMode: .alwaysOriginal), handler: { (_) in
            self.delegate?.didTapDelete(item: self.temporaryData!)
        })
        
        var menuItems: [UIAction] {
            return [
                shareHandle,
                deleteHandle
            ]
        }
        
        popOverButton.menu = UIMenu(identifier: nil, options: [], children: menuItems)
    }
}
