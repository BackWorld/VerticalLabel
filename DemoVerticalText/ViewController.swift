//
//  ViewController.swift
//  DemoVerticalText
//
//  Created by zhuxuhong on 2022/4/6.
//

import UIKit


extension Character {
    var isWhiteSpaceOrNewLine: Bool {
        if isWhitespace == true || isNewline == true {
            return true
        }
        return false
    }
}


class ViewController: UIViewController {

    @IBOutlet weak var label: VerticalLabel!
    
    @IBAction func xAlignChanged(_ sender: UISegmentedControl) {
        label.horizontal = sender.selectedSegmentIndex
    }
    
    @IBAction func yAlignChanged(_ sender: UISegmentedControl) {
        label.vertical = sender.selectedSegmentIndex
    }
    
    @IBAction func directionChanged(_ sender: UISegmentedControl) {
        label.direction = sender.selectedSegmentIndex
    }
    @IBAction func lineAlignmentChanged(_ sender: UISegmentedControl) {
        label.lineAlign = sender.selectedSegmentIndex
    }
    @IBAction func breakingModeChanged(_ sender: UISegmentedControl) {
        label.breakingMode = sender.selectedSegmentIndex
    }
    @IBAction func fontChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            label.font = .fangZhengShuSong(24)
        }
        else {
            label.font = .huaWenLiShu(24)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.font = .fangZhengShuSong(24)
//        label.text = String(repeating: "桃红樱粉玉兰香，\n清明过后各自藏。\n来年若要赏春光，\n长安二月君堪访。", count: 1)
//        label.text = String(repeating: "Hello World! \n", count: 5)
//        label.text = "东风夜放花千树，\n更吹落，星如雨。\n宝马雕车香满路，\n凤箫声动，玉壶光转，\n一夜鱼龙舞。\n\n\n\n\n蛾儿雪柳黄金缕，\n笑语盈盈暗香去。\n众里寻他千百度，\n蓦然回首，\n那人却在，灯火阑珊处。这是超出的文本这是超出的文本这是超出的文本这是超出的文本"
//        label.text = "春有百花秋有月，\n夏有凉风冬有雪。\n若无闲事挂心头，\n便是人间好时节。"

        let attrText = NSMutableAttributedString(string: "春有百花秋有月，", attributes: [
            .foregroundColor: UIColor.green,
            .font: UIFont.huaWenLiShu(30)
        ])
        attrText.append(.init(string: "\n夏有凉风冬有雪。", attributes: [
            .foregroundColor: UIColor.red,
            .font: UIFont.fangZhengShuSong(30)
        ]))
        attrText.append(.init(string: "\n若无闲事挂心头，", attributes: [
            .foregroundColor: UIColor.blue,
            .font: UIFont.fangZhengShuSong(40)
        ]))
        attrText.append(.init(string: "\n便是人间好时节。", attributes: [
            .foregroundColor: UIColor.black,
            .font: UIFont.huaWenLiShu(40)
        ]))
        
        label.attributedText = attrText
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        label.setNeedsUpdate()
    }

}

extension UIFont {
    static func fangZhengShuSong(_ size: CGFloat) -> UIFont {
        return .init(name: "FZShuSong-Z01S", size: size)!
    }
    static func huaWenLiShu(_ size: CGFloat) -> UIFont {
        return .init(name: "STLiti", size: size)!
    }
}

extension UIColor {
    var random: UIColor {
        var value: CGFloat {
            let v = CGFloat(arc4random_uniform(255)) / 255
            return v
        }
        return .init(red: value, green: value, blue: value, alpha: 1)
    }
}
