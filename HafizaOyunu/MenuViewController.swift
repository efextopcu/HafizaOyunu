//
//  MenuViewController.swift
//  HafizaOyunu
//
//  Created by Efe Topcu on 1.06.2021.
//

import UIKit

class MenuViewController: UIViewController {
    
    private let dataSource = ["Level 1: 2x5","Level 2: 3x6","Level 3: 4x5"]
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var baslaBtn: UIButton!
    var gamelevel = 0
    var usernameText = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameMenu = segue.destination as! ViewController
        gameMenu.level = gamelevel
        gameMenu.username = usernameText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(0, inComponent: 0, animated: true)
        username.returnKeyType = .done
        username.becomeFirstResponder()
        username.delegate = self
    }
    
    @IBAction func baslaBtnTap(_ sender: Any) {
        if username.hasText == true{
            usernameText = username.text!
            performSegue(withIdentifier: "showGameScreen"
                         , sender: nil)
        }
        else{
            let message = "Kullanıcı adı girin!"
            let title = "Uyarı"
            let alert  = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
extension MenuViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if dataSource[row] == "Level 1: 2x5"{
            gamelevel = 1
        }
        else if dataSource[row] == "Level 2: 3x6"{
            gamelevel = 2
        }
        else{
            gamelevel = 3
        }
    }
}
extension MenuViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
