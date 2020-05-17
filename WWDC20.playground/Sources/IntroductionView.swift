import UIKit

public class IntroductionView: UIView {
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let titleText = "How to Make the Perfect Cup of Coffee"
    let subtitleText = "In Just 3 Minutes"
    
    public override func layoutSubviews() {
        titleLabel.text = titleText
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.textColor = .darkGray
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        
        subtitleLabel.text = subtitleText
        subtitleLabel.alpha = 0.0
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        subtitleLabel.textColor = .darkGray
        subtitleLabel.numberOfLines = 0
        subtitleLabel.lineBreakMode = .byWordWrapping
        subtitleLabel.textAlignment = .center
        addSubview(subtitleLabel)
        
        setViewConstraints()
    }
    
    func setViewConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -40.0)
        ])
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20.0),
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subtitleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -40.0)
        ])
    }
    
    public func animateTitles(_ finished: @escaping (Bool) -> Void) {
        UIView.animateKeyframes(withDuration: 2.0,
                                delay: 2.0,
                                options: [.calculationModeCubic],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0,
                               relativeDuration: 1.0/2.0,
                               animations: {
                self.subtitleLabel.alpha = 1.0
            })
            UIView.addKeyframe(withRelativeStartTime: 1.0/2.0,
                               relativeDuration: 1.0/2.0,
                               animations: {
                self.titleLabel.alpha = 0.0
                self.subtitleLabel.alpha = 0.0
            })
        }, completion: finished)
    }
}
