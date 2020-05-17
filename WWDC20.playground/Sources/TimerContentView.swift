import UIKit

protocol TimerContentDelegate {
    func brewingFinished()
}

public class TimerContentView: UIView {
    let timerLabel = UILabel()
    let instructionLabel = UILabel()
    let startButton = UIButton()
    let startText = "Start"
    let finishText = "Continue"
    var waterOunces: Double = 12.0
    var coffeeGrams: Double = 7.0
    let bloomTime = 30
    var time = 0
    let maxTime = 180
    var timer = Timer()
    var delegate: TimerContentDelegate?
    
    public override func layoutSubviews() {
        timerLabel.text = "00:00"
        timerLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        timerLabel.textColor = .lightText
        timerLabel.numberOfLines = 0
        timerLabel.lineBreakMode = .byWordWrapping
        timerLabel.textAlignment = .center
        addSubview(timerLabel)
        
        let bloomWaterAmount = waterOunces * 0.2
        let bloomWaterText = String(format: "%.1f", bloomWaterAmount)
        instructionLabel.text = "Pour \(bloomWaterText) ounces while the coffee blooms for \(bloomTime) seconds."
        instructionLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        instructionLabel.textColor = .lightText
        instructionLabel.numberOfLines = 0
        instructionLabel.lineBreakMode = .byWordWrapping
        instructionLabel.textAlignment = .left
        addSubview(instructionLabel)
        
        startButton.setTitle(startText, for: .normal)
        startButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        startButton.layer.borderColor = UIColor.lightText.cgColor
        startButton.layer.borderWidth = 2.0
        startButton.layer.cornerRadius = 10.0
        startButton.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        addSubview(startButton)
        
        setViewConstraints()
    }
        
    func setViewConstraints() {
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timerLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -10.0),
        ])
        
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 10.0),
            instructionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            instructionLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -40.0),
        ])
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 30.0),
            startButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            startButton.widthAnchor.constraint(equalTo: widthAnchor, constant: -100.0),
            startButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0)
        ])
    }
    
    @objc func updateTimeText() {
        if time < bloomTime {
            time += 1
            timerLabel.text = timeString(TimeInterval(time))
        } else {
            timer.invalidate()
            
            UIAccessibility.post(
            notification: UIAccessibility.Notification.announcement,
            argument: "Blooming done!")
            UIView.animate(withDuration: 1.0) {
                let finalWaterAmount = self.waterOunces * 0.8
                let finalWaterText = String(format: "%.1f", finalWaterAmount)
                self.instructionLabel.text = "Pour \(finalWaterText) ounces while the coffee blooms for the remaining \(self.timeString(TimeInterval(self.maxTime - self.bloomTime)))."
                self.startButton.setTitle(self.finishText, for: .normal)
                self.startButton.isUserInteractionEnabled = true
                self.startButton.alpha = 1.0
            }
        }
    }
    
    @objc func updateFinalTime() {
        if time < maxTime {
            time += 1
            timerLabel.text = timeString(TimeInterval(time))
        } else {
            timer.invalidate()
            UIAccessibility.post(
                notification: UIAccessibility.Notification.announcement,
                argument: "Brewing done!")
            delegate?.brewingFinished()
        }
        
    }
    
    func timeString(_ time: TimeInterval) -> String {
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        let minutes = Int(time.truncatingRemainder(dividingBy: 60 * 60) / 60)
        return String(format: "%.2d:%.2d", minutes, seconds)
    }
    
    @objc func startTimer() {
        if time < 30 {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeText), userInfo: nil, repeats: true)
            startButton.isUserInteractionEnabled = false
            startButton.alpha = 0.7
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateFinalTime), userInfo: nil, repeats: true)
            startButton.isUserInteractionEnabled = false
            startButton.alpha = 0.7
        }
    }
}

