
import UIKit
import BottomSheetSlider

@available(iOS 10.0, *)
class ViewController: SliderBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSlider()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpSlider() {
        guard let slider = storyboard?.instantiateViewController(withIdentifier: "demoVC") as? DemoViewController else { return }
        self.setUpSlider(sliderController: slider)
        self.showSlider()
    }
    

}

