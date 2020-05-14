import UIKit

public class MeasureContentView: UIView {
    let waterSlider = UISlider()
    let coffeeAmountLabel = UILabel()
    let waterAmountLabel = UILabel()
    let nextButton = UIButton()
    let nextText = "Next"
    var waterOunces: Double = 12
    var coffeeGrams: Double = 21
    
    public override func layoutSubviews() {
        waterAmountLabel.text = "\(waterOunces) Ounces of Water"
        waterAmountLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        waterAmountLabel.textColor = .lightText
        waterAmountLabel.numberOfLines = 0
        waterAmountLabel.lineBreakMode = .byWordWrapping
        waterAmountLabel.textAlignment = .center
        addSubview(waterAmountLabel)
        
        coffeeAmountLabel.text = "\(coffeeGrams) Grams of Coffee"
        coffeeAmountLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        coffeeAmountLabel.textColor = .lightText
        coffeeAmountLabel.numberOfLines = 0
        coffeeAmountLabel.lineBreakMode = .byWordWrapping
        coffeeAmountLabel.textAlignment = .center
        addSubview(coffeeAmountLabel)
        
        waterSlider.value = Float(waterOunces)
        waterSlider.minimumValue = Float(6)
        waterSlider.maximumValue = Float(24)
        waterSlider.addTarget(self, action: #selector(sliderDidChange), for: .valueChanged)
        addSubview(waterSlider)
        
        nextButton.setTitle(nextText, for: .normal)
        nextButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        nextButton.layer.borderColor = UIColor.lightText.cgColor
        nextButton.layer.borderWidth = 2.0
        nextButton.layer.cornerRadius = 10.0
        addSubview(nextButton)
        
        setViewConstraints()
    }
    
    func setViewConstraints() {
        waterAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            waterAmountLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            waterAmountLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            waterAmountLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -10.0)
        ])
        
        waterSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            waterSlider.topAnchor.constraint(equalTo: waterAmountLabel.bottomAnchor, constant: 10.0),
            waterSlider.centerXAnchor.constraint(equalTo: centerXAnchor),
            waterSlider.widthAnchor.constraint(equalTo: widthAnchor, constant: -30.0)
        ])
        
        coffeeAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            coffeeAmountLabel.topAnchor.constraint(equalTo: waterSlider.bottomAnchor, constant: 10.0),
            coffeeAmountLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            coffeeAmountLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -10.0),
        ])
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: coffeeAmountLabel.bottomAnchor, constant: 30.0),
            nextButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextButton.widthAnchor.constraint(equalTo: widthAnchor, constant: -100.0),
            nextButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0)
        ])
    }
    
    @objc func sliderDidChange() {
        waterOunces = Double(waterSlider.value)
        coffeeGrams = waterOunces * (7/4)
        let waterText = String(format: "%.1f", waterOunces)
        let coffeeText = String(format: "%.1f", coffeeGrams)
        waterAmountLabel.text = "\(waterText) Ounces of Water"
        coffeeAmountLabel.text = "\(coffeeText) Grams of Coffee"
        
    }
}
