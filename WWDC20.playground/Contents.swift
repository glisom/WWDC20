
import UIKit
import PlaygroundSupport
import AVFoundation
import AVKit

class BrewViewController: UIViewController {
    let introductionView = IntroductionView()
    let measureView = MeasureView()
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
        
        view.addSubview(measureView)
        
        measureView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            measureView.heightAnchor.constraint(equalTo: view.heightAnchor),
            measureView.widthAnchor.constraint(equalTo: view.widthAnchor),
            measureView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            measureView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        introductionView.animateTitles { _ in
            self.measureView.animateTitles { (_) in
                
            }
        }
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
