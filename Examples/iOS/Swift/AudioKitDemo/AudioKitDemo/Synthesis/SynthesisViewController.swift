//
//  ViewController.swift
//  AudioKitDemo
//
//  Created by Nicholas Arner on 3/1/15.
//  Copyright (c) 2015 AudioKit. All rights reserved.
//

import CoreMotion // Adding tilt parameters
var motionManager = CMMotionManager()
var destX:CGFloat  = 0.0
var destY:CGFloat  = 0.0

class SynthesisViewController: UIViewController {
    
    @IBOutlet var fmSynthesizerTouchView: UIView!
    @IBOutlet var tambourineTouchView: UIView!
    
    let tambourine    = Tambourine()
    let fmSynthesizer = FMSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the vFMSynthesizeriew, typically from a nib.
        AKOrchestra.addInstrument(tambourine)
        AKOrchestra.addInstrument(fmSynthesizer)
        
        // Adding CMMotionManager
        if motionManager.accelerometerAvailable == true {
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler:{
                data, error in
                
                destX = CGFloat((0.5*data.acceleration.y + 0.5)*4000)
                destY = CGFloat((0.5*data.acceleration.y + 0.5)*0.25)
                
            })
            
        }
        
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }

 
    @IBAction func tapTambourine(sender: UITapGestureRecognizer) {
        
        let touchPoint = sender.locationInView(tambourineTouchView)
        let scaledX = touchPoint.x / tambourineTouchView.bounds.size.height
        let scaledY = 1.0 - touchPoint.y / tambourineTouchView.bounds.size.height
        
        let intensity = Float(scaledY*4000 + 20)
        let dampingFactor = Float(scaledX / 2.0)
        
        let note = TambourineNote(intensity: intensity, dampingFactor: dampingFactor)
        tambourine.playNote(note)
    }
    
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if motion == .MotionShake {
            let intensity = Float(destX)
            let dampingFactor = Float(destY)
            
            let note = TambourineNote(intensity: intensity, dampingFactor: dampingFactor)
            tambourine.playNote(note)
        }
    }
    @IBAction func tapFMOscillator(sender: UITapGestureRecognizer) {
        
        let touchPoint = sender.locationInView(fmSynthesizerTouchView)
        let scaledX = touchPoint.x / fmSynthesizerTouchView.bounds.size.height
        let scaledY = 1.0 - touchPoint.y / fmSynthesizerTouchView.bounds.size.height
        
        let frequency = Float(scaledY*400)
        let color = Float(scaledX)
        
        let note = FMSynthesizerNote(frequency: frequency, color: color)
        fmSynthesizer.playNote(note)
    }
}
