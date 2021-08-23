//
//  ViewController.swift
//  Swift Practice # 64 Progress Rate
//
//  Created by Dogpa's MBAir M1 on 2021/8/22.
//

import UIKit

class ViewController: UIViewController {
    

    
    
    
    @IBOutlet weak var expectFinishReadingTextField: UITextField!   //輸入結束日期的TextField
    
    @IBOutlet weak var averagePagesOfDayLabel: UILabel!             //顯示剩餘天數的平均頁數
        
    @IBOutlet weak var progressRateView: UIView!                    //顯示百分比進度的View
    
    @IBOutlet weak var progressRateLabel: UILabel!                  //百分比進度圓環內的Labal
    
    
    func hideKeyboardWhenTappedAround() { //收鍵盤的function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        }
        @objc func dismissKeyboard() {
        view.endEditing(true)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()                         //執行收鍵盤
        progressRateView.backgroundColor = .clear                   //百分比進度顯示圓環的背景顏色為clear
        progressRateLabel.backgroundColor = .clear                  //百分比進度的Label背景顏色顯示為clear
    }
    

    
    
    func showProgressRate (nowReading:Int){ //nowReading為需要傳入的參數
        
        //定義圓每一度給oneDegree
        let oneDegree = CGFloat.pi / 180
        //將進度條寬度定義給 lineWidth 型別CGFloat
        let lineWidth: CGFloat = 15

        //定義半徑長度為已經建立好的progressRateView的長度的一半，再減掉百分比線條的寬度(lineWidth)
        let radius: CGFloat = ((progressRateView.bounds.width)/2) - lineWidth
        
        //列印半徑確定尺寸長度
        print("半徑\(radius)")

        //定義圓環進度條起點在270度的位置
        let startDegree: CGFloat = 270

        //將UIBezierPath功能（使用ovalIn）指派給circlePath
        //xy軸設定在lineWidth:15是因為如果設為00將超出在progressRateView的範圍
        let circlePath = UIBezierPath(ovalIn:  CGRect(x: lineWidth, y: lineWidth , width: radius*2, height: radius*2))

        //將CAShapeLayer()功能定義給circleLayer
        let circleLayer = CAShapeLayer()

        //將透過ovalIn產生好的圓的路徑宣告給circleLayer.path圖層，使circleLayer.path產生ovalIn設定值的圖案
        circleLayer.path = circlePath.cgPath

        //透過.strokeColor將線條顏色定義成為我們指定的RGB顏色
        circleLayer.strokeColor = UIColor.gray.cgColor

        //透過.lineWidth將線條的寬度定義為已經定義好的lineWidth
        circleLayer.lineWidth = lineWidth

        //透過.fillColor將circleLayer的圖層定義為clear無色？沒有顏色？
        circleLayer.fillColor = UIColor.clear.cgColor

        //將預設的百分比進度指派給percentage
        let percentage: CGFloat = CGFloat(nowReading)
        

        //指派百分比進度的進度條給percentagePath
        //圓心起始點需與「circlePath產生的圓」一樣
        //所以可以知道circlePath圓心為原本的起始位置(lineWidth)+半徑(radius)
        //radius半徑radius則套用circlePath一樣的數值
        //startAngle起始位置一樣使用270度(已經設定好的(startDegree透過oneDegree乘開)
        //endAngle結束位置則透過 percentage百分比除100得到比例之後再透過一整個圓360度對應一樣的比例來顯示
        let percentagePath = UIBezierPath(arcCenter: CGPoint(x: lineWidth+radius, y: lineWidth+radius), radius: radius, startAngle: oneDegree*startDegree, endAngle: oneDegree*(startDegree + 360*percentage/CGFloat(595)), clockwise: true)

        //建立百分比進度條的圖層 透過CAShapeLayer()定義給perctntageLayer
        let perctntageLayer = CAShapeLayer()

        //透過.path確認要使用CAShapeLayer()內的.path
        //將製作好的percentagePath圖透過.cghpath
        //轉換成為CAShapeLayer()可以理解的cgpath類別
        //至此perctntageLayer.path便能知道圖形顯示的內容
        perctntageLayer.path = percentagePath.cgPath

        //透過.strokeColor決定百分比圖層的顏色
        perctntageLayer.strokeColor  = UIColor(red: 0, green: 1, blue: 1, alpha: 1  ).cgColor

        //透過.lineWidth指定perctntageLayer圖層百分比的線條粗細
        perctntageLayer.lineWidth = lineWidth

        //透過.fillColor決定百分比圖層的顏色
        perctntageLayer.fillColor = UIColor.clear.cgColor

        //透過perctntageLayer.lineCap將百分比線條的頭修成圓形
        perctntageLayer.lineCap = .round

        //透過.layer.addSublayer新增圓環的圖
        //(circleLayer)的圖層一定要比(perctntageLayer)先新增到view裡面
        //不然百分比進度條會被圓環蓋住
        progressRateView.layer.addSublayer(circleLayer)

        //透過.layer.addSublayer新增百分比的圖
        progressRateView.layer.addSublayer(perctntageLayer)
        
        //percentageOfReading為目前進度百分比
        let percentageOfReading = (Float(percentage)/Float(595))*100
        
        //定義一個string （stringOfProgressRateLabel）顯示的規格％.3f以及字詞percentageOfReading的數字
        let stringOfProgressRateLabel = String(format: "%.3f", percentageOfReading)
        
        //顯示的Label為 "進度 \(stringOfProgressRateLabel) %"
        progressRateLabel.text = "進度 \(stringOfProgressRateLabel) %"
        
    }
    
    
    
    
    
    
    
    
    @IBAction func readPagesForNow(_ sender: UITextField) {
        
        if expectFinishReadingTextField.text?.count == 8 {                     //先確認輸入日期規格是否有8個數字在執行下列程式
            
            //指派 expectDate 取得 預期完成日期上的日期字串 沒有辦法取得則回傳八碼空字串
            let expectDate : String = "\(expectFinishReadingTextField.text ?? "00000000")"
            //指派dateFormatter取得 DateFormatter()功能
            let dateFormatter = DateFormatter()
            //日期顯示規格為  "YYYYMMdd"
            dateFormatter.dateFormat = "YYYYMMdd"
            //讓剛剛透過expectFinishReadingTextField的字串日期成為dateFormatter.date可以使用的日期格式
            let expectFinishDayDate = dateFormatter.date(from: expectDate)
            //指派todate取得今天的日期
            let todate = Date()
            //指派toDateBetweenFinishDate取得Calendar.current.dateComponents的功能，取得輸入日期與今天的時間差
            let toDateBetweenFinishDate = Calendar.current.dateComponents([.day], from: todate, to: expectFinishDayDate!)
            //指派remaindDays取得剛剛取得的toDateBetweenFinishDate的天數差距 沒有辦法取得日期則回傳0
            let remaindDays = Int(toDateBetweenFinishDate.day ?? 0)
            //列印remaindDays測試
            print("剩餘天數\(remaindDays)")
            
            //if let來防止閃退，嘗試取得頁數的TextField的值並轉為Int
            if let pagesForNowReading = Int(sender.text ?? "") {
                
                //測試列印目前取得的數字
                //print(pagesForNowReading)
                
                //總頁數減去看完的頁數，再透過剛剛取得的剩餘天數去除剩餘的頁數
                let avgPagesOfDays:Float = Float(595 - pagesForNowReading) / Float(remaindDays)
                //將剛剛取得的avgPagesOfDays顯示在平均頁數的Label
                averagePagesOfDayLabel.text = String(format: "%.4f", avgPagesOfDays)
                //執行showProgressRate，傳入目前的看完頁數的去執行Function。
                showProgressRate(nowReading: pagesForNowReading)
                
            }
        }
    }
    
    
    
    
    
    
    
}

