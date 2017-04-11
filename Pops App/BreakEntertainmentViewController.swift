
import UIKit

class BreakEntertainmentViewController: UIViewController, BreakTimeViewModelDelegate {

    weak var delegate: InstantiateViewControllerDelegate!

    var breakView = UIView()
    var backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(breakView)
        breakView.center = self.view.center
        
        setUpBackButton()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setUpBackButton(){
        backButton.setTitle("!", for: .normal)
        backButton.backgroundColor = .black
        backButton.addTarget(self, action: #selector(dismissCoachBreakView), for: .touchUpInside)
        
        breakView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leadingAnchor.constraint(equalTo: breakView.leadingAnchor, constant: 25.0).isActive = true
        backButton.topAnchor.constraint(equalTo: breakView.topAnchor, constant: 25.0).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 21.0).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 21.0).isActive = true
    }
    
    func moveToProductivity() {
        self.present(ProductiveTimeViewController(), animated: true, completion: nil)
    }
    
    func moveToSessionEnded() {
        self.present(SessionEndedViewController(), animated: true, completion: nil)
    }
    
    func dismissCoachBreakView() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
