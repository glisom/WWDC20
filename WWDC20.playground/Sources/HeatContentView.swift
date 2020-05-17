import UIKit

protocol HeatContentDelegate {
    func nextStep()
}

public class HeatContentView: UIView {
    let heatInstructionsLabel = UILabel()
    let nextButton = UIButton()
    let nextText = "Next"
    var delegate: HeatContentDelegate?
    
    public override func layoutSubviews() {
        heatInstructionsLabel.text = "Heat your water to 195℉ degrees"
        heatInstructionsLabel.accessibilityLabel = ""
        heatInstructionsLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        heatInstructionsLabel.textColor = .lightText
        heatInstructionsLabel.numberOfLines = 0
        heatInstructionsLabel.lineBreakMode = .byWordWrapping
        heatInstructionsLabel.textAlignment = .center
        addSubview(heatInstructionsLabel)
        
        nextButton.setTitle(nextText, for: .normal)
        nextButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        nextButton.layer.borderColor = UIColor.lightText.cgColor
        nextButton.layer.borderWidth = 2.0
        nextButton.layer.cornerRadius = 10.0
        nextButton.addTarget(self, action: #selector(didTouchUpOnNext), for: .touchUpInside)
        addSubview(nextButton)
        
        setViewConstraints()
    }
    
    func setViewConstraints() {
        heatInstructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heatInstructionsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            heatInstructionsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            heatInstructionsLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -10.0)
        ])
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: heatInstructionsLabel.bottomAnchor, constant: 30.0),
            nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextButton.widthAnchor.constraint(equalTo: widthAnchor, constant: -100.0),
            nextButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0)
        ])
    }
    
    @objc func didTouchUpOnNext() {
        delegate?.nextStep()
        UIAccessibility.post(
        notification: UIAccessibility.Notification.announcement,
        argument: "Next Step.")
    }
}
