
import UIKit
import PlaygroundSupport
import AVFoundation
import AVKit

class BrewViewController: UIViewController {
    let introductionView = IntroductionView()
    let measureView = MeasureView()
    let timerView = TimerView()
    var waterOunces: Double?
    var coffeeGrams: Double?
    
    override func viewDidLoad() {
        let backgroundImage = #imageLiteral(resourceName: "coffee.jpg")
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.frame = view.frame
        view.addSubview(backgroundImageView)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.frame
        view.addSubview(blurredEffectView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.addSubview(introductionView)
        introductionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            introductionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            introductionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            introductionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            introductionView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        measureView.delegate = self
        
        view.addSubview(measureView)
        measureView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            measureView.heightAnchor.constraint(equalTo: view.heightAnchor),
            measureView.widthAnchor.constraint(equalTo: view.widthAnchor),
            measureView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            measureView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        introductionView.animateTitles { _ in
            self.measureView.animateTitles { _ in
            }
        }
    }
}

public class TimerView: UIView {
    let titleLabel = UILabel()
    let titleText = "Pour"
    let contentView = TimerContentView()
    
    public override func layoutSubviews() {
        titleLabel.text = titleText
        titleLabel.alpha = 0.0
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.textColor = .darkGray
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        contentView.alpha = 0.0
        contentView.layer.cornerRadius = 10.0
        addSubview(contentView)
        
        setViewConstraints()
    }
    
    func setViewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor, constant: -40.0),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -40.0),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: -20.0)
        ])
    }
    
    public func animateTitles(_ finished: @escaping (Bool) -> Void) {
        UIView.animateKeyframes(withDuration: 4.0, delay: 0.0, options: [.calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 2.0/4.0, animations: {
                self.titleLabel.alpha = 1.0
            })
            UIView.addKeyframe(withRelativeStartTime: 2.0/4.0, relativeDuration: 2.0/4.0, animations: {
                self.contentView.alpha = 1.0
            })
        }, completion: finished)
    }
}

public class TimerContentView: UIView {
    let timerLabel = UILabel()
    let instructionLabel = UILabel()
    var waterOunces: Double = 12.0
    var coffeeGrams: Double = 7.0
    var bloomTime:Double = 30.0
    var time = 180
    var timer = Timer()
    
    public override func layoutSubviews() {
        timerLabel.text = "03:00:00"
        timerLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        timerLabel.textColor = .lightText
        timerLabel.numberOfLines = 0
        timerLabel.lineBreakMode = .byWordWrapping
        timerLabel.textAlignment = .center
        addSubview(timerLabel)
        
        let bloomWaterAmount = waterOunces * 0.1
        let bloomWaterText = String(format: "%.0f", bloomWaterAmount)
        instructionLabel.text = "Pour \(bloomWaterText) ounces while the coffee blooms for \(bloomTime) seconds."
        instructionLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        instructionLabel.textColor = .lightText
        instructionLabel.numberOfLines = 0
        instructionLabel.lineBreakMode = .byWordWrapping
        instructionLabel.textAlignment = .left
        addSubview(instructionLabel)
        
        setViewConstraints()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeText), userInfo: nil, repeats: true)
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
            instructionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0)
        ])
    }
    
    @objc func updateTimeText() {
        time -= 1
        print(time)
        timerLabel.text = timeString(TimeInterval(time))
    }
    
    func timeString(_ time: TimeInterval) -> String {
        let milliseconds = Int(time.truncatingRemainder(dividingBy: 60) / 3)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60) / 3)
        let minutes = Int(time.truncatingRemainder(dividingBy: 180 * 60) / 60)
        return String(format: "%.2d:%.2d:%.2d", minutes, seconds, milliseconds)
    }
}

extension BrewViewController: MeasureDelegate {
    func nextStep(_ waterOunces: Double, _ coffeeGrams: Double) {
        print("Water: \(waterOunces), Coffee: \(coffeeGrams)")
        view.addSubview(timerView)
        timerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timerView.heightAnchor.constraint(equalTo: view.heightAnchor),
            timerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            timerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        measureView.hideView { _ in
            self.timerView.animateTitles { _ in
            }
        }
    }
}

//var audioPlayer: AVAudioPlayer?
//if let path = Bundle.main.path(forResource: "lofi.mp3", ofType:nil) {
//    let url = URL(fileURLWithPath: path)
//    do {
//        audioPlayer = try AVAudioPlayer(contentsOf: url)
//        audioPlayer?.prepareToPlay()
//        audioPlayer?.play()
//    } catch {
//        print("No Luck on the music")
//    }
//}
PlaygroundPage.current.setLiveView(BrewViewController())
