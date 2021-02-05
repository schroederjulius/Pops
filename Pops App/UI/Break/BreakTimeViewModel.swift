
import Foundation
import UIKit
import CoreMotion
import AudioToolbox
import AVFoundation

protocol BreakTimeViewModelDelegate: class {
    func moveToProductivity()
    func moveToSessionEnded()
    var characterMessageHeader: UILabel {get set}
    var characterMessageBody: UILabel {get set}
    var progressBar: UILabel {get set}
    var settingsButton: UIButton {get set}
    var dismissIcon: UIButton {get set}
}

protocol BreakTimeViewModelProgressBarDelegate: class {
    var progressBarWidthAnchor: NSLayoutConstraint! {get set}
}

protocol DisplayBreakTimerDelegate: class {
    var breakTimerLabel: UILabel {get set}
    var settingsTimerCounter: Int {get set}
}

final class BreakTimeViewModel {
    //let settingsButton = UIButton()
    let dataStore = DataStore.singleton
    let motionManager = CMMotionManager()
    weak var delegate: BreakTimeViewModelDelegate!
    weak var progressBarDelegate: BreakTimeViewModelProgressBarDelegate!
    weak var breakTimerDelegate: DisplayBreakTimerDelegate!
    
    var sessionTimeRemaining: Int = 0
    var breakTimer: Timer
    var breakTimerCounter: Int = 0
    var breakIsOn: Bool = false
    
    var progressBarCounter = 0.0 {
        didSet {
            progressBarDelegate.progressBarWidthAnchor.constant = CGFloat(UIScreen.main.bounds.width * CGFloat(self.progressBarCounter) )
        }
    }
        
    init(delegate: BreakTimeViewModelDelegate, progressBarDelegate: BreakTimeViewModelProgressBarDelegate){
        self.delegate = delegate
        self.progressBarDelegate = progressBarDelegate
        self.breakTimer = dataStore.user.currentSession?.productivityTimer ?? Timer()
    }
    
    //init(vc: ProductiveTimeViewController){
        //motionManager.accelerometerUpdateInterval = 0.5
        //motionManager.startAccelerometerUpdates()
    //}

    
    
    
    
    
    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //temp
   // func animateCancelToWeak() {
   //     self.TalktoButton.setTitle(" ", for: .normal)
   // }
    
    
    func startTimer() {
        motionManager.startAccelerometerUpdates()
        self.breakTimerCounter = dataStore.user.currentCoach.difficulty.baseBreakLength
        dataStore.defaults.set(Date(), forKey: "breakTimerStartedAt")
    
        dataStore.user.currentSession?.sessionTimer.invalidate()
        dataStore.user.currentSession?.sessionTimerCounter = (dataStore.user.currentSession!.cycleLength * dataStore.user.currentSession!.cyclesRemaining) - dataStore.user.currentSession!.sessionDifficulty.baseProductivityLength
        sessionTimeRemaining = dataStore.user.currentSession!.sessionTimerCounter
        
        breakIsOn = true
        
        breakTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.breakTimerAction()
        })
        dataStore.user.currentSession?.startSessionTimer()
        }
    
    
    
    func breakTimerAction() {
        
        if dataStore.user.currentSession!.sessionTimerCounter <= 1 {
            breakIsOn = false
            breakTimer.invalidate()
            delegate.moveToSessionEnded()
        }
        
        breakTimerCounter -= 1
        print("break timer: \(breakTimerCounter)")
       
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if (1...5).contains(breakTimerCounter) {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            toggleTorch(on: true)
            toggleTorch(on: false)
            toggleTorch(on: true)
            toggleTorch(on: false)
            toggleTorch(on: true)
            toggleTorch(on: false)
            toggleTorch(on: true)
            toggleTorch(on: false)
        }

        //if productivityTimerCounter <= 0 {
            //productivityTimer.invalidate()
            //motionManager.stopAccelerometerUpdates()
        
        if motionManager.accelerometerData!.acceleration.z > 0.25 {
            //userWasPenalized = false
            UIScreen.main.brightness = 0.0 // used to be 0.01
            //delegate.productiveTimeLabel.textColor = UIColor.black
        }
        
        if motionManager.accelerometerData!.acceleration.z < 0.25 {
            UIScreen.main.brightness = 0.3 // used to be 0.75
            //delegate.productiveTimeLabel.textColor = UIColor.white
        }
        
        //if motionManager.accelerometerData!.acceleration.z < 0.25 &&
            //breakTimerCounter > 65 //&&
        
        
        
        
        if breakTimerCounter <= 0 && dataStore.user.currentSession!.sessionTimerCounter > 1 {
            breakIsOn = false
            breakTimer.invalidate()
            dataStore.user.currentSession!.cyclesRemaining -= 1
            
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            if (1...5).contains(breakTimerCounter) {
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                toggleTorch(on: true)
                toggleTorch(on: false)
                toggleTorch(on: true)
                toggleTorch(on: false)
                toggleTorch(on: true)
                toggleTorch(on: false)
                toggleTorch(on: true)
                toggleTorch(on: false)
            }

            //if productivityTimerCounter <= 0 {
                //productivityTimer.invalidate()
                //motionManager.stopAccelerometerUpdates()
            
            if motionManager.accelerometerData!.acceleration.z > 0.25 {
                //userWasPenalized = false
                UIScreen.main.brightness = 0.0 // used to be 0.01
                //delegate.productiveTimeLabel.textColor = UIColor.black
            }
            
            if motionManager.accelerometerData!.acceleration.z < 0.25 {
                UIScreen.main.brightness = 0.3 // used to be 0.75
                //delegate.productiveTimeLabel.textColor = UIColor.white
            }
            
            //if motionManager.accelerometerData!.acceleration.z < 0.25 &&
                //breakTimerCounter > 65 //&&
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            delegate.moveToProductivity()
        }
        
        
        
        
        
        if breakTimerDelegate != nil {
            breakTimerDelegate.breakTimerLabel.text = "\(formatTime(time: breakTimerCounter)) left"
            breakTimerDelegate.settingsTimerCounter -= 1
        }
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if (1...5).contains(breakTimerCounter) {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            toggleTorch(on: true)
            toggleTorch(on: false)
            toggleTorch(on: true)
            toggleTorch(on: false)
            toggleTorch(on: true)
            toggleTorch(on: false)
            toggleTorch(on: true)
            toggleTorch(on: false)
        }

        //if productivityTimerCounter <= 0 {
            //productivityTimer.invalidate()
            //motionManager.stopAccelerometerUpdates()
        
        if motionManager.accelerometerData!.acceleration.z > 0.25 {
            //userWasPenalized = false
            UIScreen.main.brightness = 0.0 // used to be 0.01
            //delegate.productiveTimeLabel.textColor = UIColor.black
            delegate.characterMessageHeader.textColor = UIColor.black
            delegate.progressBar.backgroundColor = UIColor.black
            delegate.characterMessageBody.textColor = UIColor.black
            delegate.settingsButton.setBackgroundImage(#imageLiteral(resourceName: "IC_black"), for: .normal)
            delegate.self.dismissIcon.setBackgroundImage(#imageLiteral(resourceName: "IC_black"), for: .normal)
        }
        
        if motionManager.accelerometerData!.acceleration.z < 0.25 {
            UIScreen.main.brightness = 0.3 // used to be 0.75
            //delegate.productiveTimeLabel.textColor = UIColor.white
            delegate.characterMessageHeader.textColor = UIColor.white
            delegate.progressBar.backgroundColor = UIColor.white
            delegate.characterMessageBody.textColor = UIColor.white
            delegate.settingsButton.setBackgroundImage(#imageLiteral(resourceName: "IC_Settings-White"), for: .normal)
            delegate.self.dismissIcon.setBackgroundImage(#imageLiteral(resourceName: "IC_Quit-Black"),  for: .normal)
        }
        
        //if motionManager.accelerometerData!.acceleration.z < 0.25 &&
            //breakTimerCounter > 65 //&&
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        progressBarCounter += 1.0 / Double(dataStore.user.currentCoach.difficulty.baseBreakLength)
    }
    
    func updateTimers() {
        let timeTimerStarted = dataStore.defaults.value(forKey: "breakTimerStartedAt") as! Date
        let timeSinceTimerStarted = Date().timeIntervalSince(timeTimerStarted)
        
        dataStore.user.currentSession?.sessionTimerCounter = sessionTimeRemaining - Int(timeSinceTimerStarted)
        breakTimerCounter = dataStore.user.currentCoach.difficulty.baseBreakLength - Int(timeSinceTimerStarted)
        
        if dataStore.user.currentSession!.sessionTimerCounter < 0 {
            dataStore.user.currentSession?.sessionTimerCounter = 1
        }
        
        if breakTimerCounter < 0 {
            breakTimerCounter = 1
        }
        
        progressBarCounter = timeSinceTimerStarted / Double(dataStore.user.currentCoach.difficulty.baseBreakLength)
        
    }
}











        //breakTimerCounter < (dataStore.user.currentCoach.difficulty.baseProductivityLength - 60) //&&
        //userWasPenalized = true //used to be true
    //}
    
    //if cancelCountdown > 0 {
        //cancelCountdown -= 1
    //}
    
    //if cancelCountdown <= 25 {
        //delegate.animateCancelToWeak()
    //}
    
    //progressBarCounter += 1.0 / Double(dataStore.user.currentCoach.difficulty.baseProductivityLength)
    
    //if breakTimerCounter <= 65 {
        //delegate.characterMessageHeader.text = "It's almost break time!"
        //delegate.characterMessageBody.text = "Wrap up your final thoughts, your break will start in less than 1 minute."
    //}
        //delegate.moveToBreak()
    //}
//}


func toggleTorch(on: Bool) {

    guard let device = AVCaptureDevice.default(for: .video) else { return }

    if device.hasTorch {
        do {
            try device.lockForConfiguration()
            
            if on == true {
                device.torchMode = .on
            } else {
                device.torchMode = .off
            }
            
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    } else {
        print("Torch is not available")
    }

}

/////////////////////////////////////
/////////////////////////////////////













extension BreakTimeViewModel {
    
    //helper method
    func formatTime(time: Int) -> String {
        if time >= 3600 {
            let hours = time / 3600
            let minutes = time / 60 % 60
            let seconds = time % 60
            return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
            
        } else if time >= 60 {
            
            let minutes = time / 60 % 60
            let seconds = time % 60
            return String(format:"%02i:%02i", minutes, seconds)
            
        } else {
            let seconds = time % 60
            return String(format:"%02i", seconds)
        }
    }
}








