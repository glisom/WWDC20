import UIKit

public protocol TimerDelegate {
    func brewingFinished()
}

public class TimerView: UIView {
    let titleLabel = UILabel()
    let titleText = "Pour"
    let skipText = "Skip"
    let skipButton = UIButton()
    let contentView = TimerContentView()
    public var delegate: TimerDelegate?
    
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
        contentView.delegate = self
        addSubview(contentView)
        
        skipButton.setTitle(skipText, for: .normal)
        skipButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        skipButton.setTitleColor(.darkGray, for: .normal)
        skipButton.addTarget(self, action: #selector(brewingFinished), for: .touchUpInside)
        addSubview(skipButton)
        
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
        
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10.0),
            skipButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
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
        }, completion: { success in
            self.skipButton.isHidden = false
            finished(success)
        })
    }
    
    public func hideView(_ finished: @escaping (Bool) -> Void) {
        UIView.animateKeyframes(withDuration: 1.0, delay: 0.0, options: [.calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                self.alpha = 0.0
            })
        }, completion: finished)
    }
}

extension TimerView: TimerContentDelegate {
    @objc func brewingFinished() {
        delegate?.brewingFinished()
    }
}
