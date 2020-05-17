import UIKit
import PlaygroundSupport
import AVFoundation
import AVKit

class BrewViewController: UIViewController {
    var blurredEffectView = UIVisualEffectView()
    let introductionView = IntroductionView()
    let measureView = MeasureView()
    let timerView = TimerView()
    let heatView = HeatView()
    let finalView = FinalView()
    var waterOunces: Double?
    var coffeeGrams: Double?
    
    override func viewDidLoad() {
        let backgroundImage = #imageLiteral(resourceName: "coffee.jpg")
        backgroundImage.isAccessibilityElement = false
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.frame = view.frame
        view.addSubview(backgroundImageView)
        
        let blurEffect = UIBlurEffect(style: .light)
        blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.frame
        blurredEffectView.alpha = 0.0
        blurredEffectView.isAccessibilityElement = false
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
        UIView.animate(withDuration: 1.0) {
            self.blurredEffectView.alpha = 1.0
        }
        introductionView.animateTitles { _ in
            self.measureView.animateTitles { _ in
                UIAccessibility.post(notification: UIAccessibility.Notification.layoutChanged, argument: nil)
            }
        }
    }
}

extension BrewViewController: MeasureDelegate {
    func nextStep(_ waterOunces: Double, _ coffeeGrams: Double) {
        view.addSubview(heatView)
        heatView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heatView.heightAnchor.constraint(equalTo: view.heightAnchor),
            heatView.widthAnchor.constraint(equalTo: view.widthAnchor),
            heatView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            heatView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        heatView.delegate = self
        measureView.hideView { _ in
            self.measureView.removeFromSuperview()
            self.heatView.animateTitles { _ in
                UIAccessibility.post(notification: UIAccessibility.Notification.layoutChanged, argument: nil)
            }
        }
    }
}

extension BrewViewController: HeatDelegate {
    func nextStep() {
        view.addSubview(timerView)
        timerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timerView.heightAnchor.constraint(equalTo: view.heightAnchor),
            timerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            timerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        timerView.delegate = self
        heatView.hideView { _ in
            self.heatView.removeFromSuperview()
            self.timerView.animateTitles { _ in
                UIAccessibility.post(notification: UIAccessibility.Notification.layoutChanged, argument: nil)
            }
        }
    }
}

extension BrewViewController: TimerDelegate {
    func brewingFinished() {
        view.addSubview(finalView)
        finalView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            finalView.heightAnchor.constraint(equalTo: view.heightAnchor),
            finalView.widthAnchor.constraint(equalTo: view.widthAnchor),
            finalView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            finalView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        timerView.hideView { _ in
            self.timerView.removeFromSuperview()
            self.finalView.animateTitles { _ in
                UIAccessibility.post(notification: UIAccessibility.Notification.layoutChanged, argument: nil)
            }
        }
    }
}

public class FinalView: UIView {
    let titleLabel = UILabel()
    let titleText = "All Done!"
    let contentView = FinalContentView()
    
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
        UIView.animateKeyframes(withDuration: 2.0, delay: 0.0, options: [.calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0/2.0, animations: {
                self.titleLabel.alpha = 1.0
            })
            UIView.addKeyframe(withRelativeStartTime: 1.0/2.0, relativeDuration: 1.0/2.0, animations: {
                self.contentView.alpha = 1.0
            })
        }, completion: finished)
    }
}

public class FinalContentView: UIView {
    let finalMessageLabel = UILabel()
    
    public override func layoutSubviews() {
        finalMessageLabel.text = "Your coffee is ready to roll for a great day of virtual WWDC! "
        finalMessageLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        finalMessageLabel.textColor = .lightText
        finalMessageLabel.numberOfLines = 0
        finalMessageLabel.lineBreakMode = .byWordWrapping
        finalMessageLabel.textAlignment = .center
        addSubview(finalMessageLabel)
        
        setViewConstraints()
    }
    
    func setViewConstraints() {
        finalMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            finalMessageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            finalMessageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            finalMessageLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -10.0),
            finalMessageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0)
        ])
    }
    
    @objc func didTouchUpOnNext() {
        UIAccessibility.post(
        notification: UIAccessibility.Notification.announcement,
        argument: "Next Step.")
    }
}

var audioPlayer: AVAudioPlayer?
if let path = Bundle.main.path(forResource: "lofi.mp3", ofType:nil) {
    let url = URL(fileURLWithPath: path)
    do {
        audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
    } catch {
        print("No Luck on the music")
    }
}
PlaygroundPage.current.setLiveView(BrewViewController())
