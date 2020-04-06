//
//  ViewController.swift
//  AudioKitBug
//
//  Created by Craig Grummitt on 6/4/20.
//  Copyright © 2020 InteractiveCoconut. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class TempViewController: UIViewController {
    var recorder: AKNodeRecorder!
    var micBooster: AKBooster!
    var mainMixer: AKMixer!
    var timer: Timer?

    let mic = AKMicrophone()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)


        do {
            try AKSettings.setSession(category: .playAndRecord, with: .allowBluetoothA2DP)
        } catch {
            AKLog("Could not set session category.")
        }

        AKSettings.defaultToSpeaker = true
        micBooster = AKBooster(mic)

        do {
            recorder = try AKNodeRecorder(node: micBooster)
        } catch {
            AKLog("Couldn't create Recorder")
        }

        mainMixer = AKMixer(micBooster)

        AudioKit.output = mainMixer
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(repeatRecorder), userInfo: nil, repeats: true)
        do {
            try recorder.record()
        } catch { AKLog("Error on first record")}
    }

    @objc func repeatRecorder() {
        do {
            try self.recorder.reset()
            try self.recorder.record()
        } catch { AKLog("Errored recording.") }
    }
}
