//
//  ViewController.swift
//  AsyncAwaitPractice
//
//  Created by yc on 2022/12/10.
//

import UIKit
import SnapKit
import Then

final class ViewController: UIViewController {
    
    private lazy var timerLabel = UILabel().then {
        $0.textAlignment = .center
    }
    private lazy var imageView = UIImageView().then {
        $0.backgroundColor = .placeholderText
    }
    private lazy var button1 = UIButton().then {
        $0.setTitle("Sync", for: .normal)
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 4.0
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(didTapButton1), for: .touchUpInside)
    }
    private lazy var button2 = UIButton().then {
        $0.setTitle("URLSession DataTask", for: .normal)
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 4.0
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(didTapButton2), for: .touchUpInside)
    }
    private lazy var button3 = UIButton().then {
        $0.setTitle("URLSession Async", for: .normal)
        $0.backgroundColor = .green
        $0.layer.cornerRadius = 4.0
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(didTapButton3), for: .touchUpInside)
    }
    
    @objc func didTapButton1() {
        imageView.image = fetch1()
    }
    @objc func didTapButton2() {
        fetch2 { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    @objc func didTapButton3() {
        Task {
            imageView.image = try await fetch3()
        }
    }
    
    var count = 0
    
    @objc func timer() {
        count += 1
        timerLabel.text = "\(count)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timer), userInfo: nil, repeats: true)
        [
            timerLabel,
            imageView,
            button1,
            button2,
            button3
        ].forEach {
            view.addSubview($0)
        }
        
        timerLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        imageView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16.0)
            $0.top.equalTo(timerLabel.snp.bottom).offset(8.0)
        }
        button1.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16.0)
            $0.top.equalTo(imageView.snp.bottom).offset(16.0)
            $0.height.equalTo(48.0)
        }
        button2.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16.0)
            $0.top.equalTo(button1.snp.bottom).offset(8.0)
            $0.height.equalTo(48.0)
        }
        button3.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16.0)
            $0.top.equalTo(button2.snp.bottom).offset(8.0)
            $0.height.equalTo(48.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    func fetch1() -> UIImage? {
        let url = URL(string: "https://picsum.photos/2560/1440/?random")!
        let data = try! Data(contentsOf: url)
        return UIImage(data: data)
    }
    func fetch2(completion: @escaping (UIImage?) -> Void) {
        let url = URL(string: "https://picsum.photos/2560/1440/?random")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                completion(UIImage(data: data))
            }
        }
        .resume()
    }
    func fetch3() async throws -> UIImage? {
        let url = URL(string: "https://picsum.photos/2560/1440/?random")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
    }
}

