import UIKit


struct Section {
  var title: String
  var items: [String]
}


extension Section {
    static func make() -> [Section] {
        return [
            Section(title: "タブレットapp ", items: ["アカウント","二次元コード","サウンド"]),
            Section(title: "会計app", items: ["アカウント", "二次元コード", "その他"]),
            Section(title: "仕入・在庫app", items: ["年代別来店割合", "年代別平均皿数", "設定3", "設定4"]),
            Section(title: "データベース", items: ["realm", "在庫", "分析"])
        ]
    }
}

class MasterViewController: UIViewController {
    private var tableView = UITableView()
    private var sections = Section.make()
    var ct = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.frame = view.bounds
        let screenWidth: CGFloat = UIScreen.main.bounds.width   //画面の幅
        let screenHeight: CGFloat = UIScreen.main.bounds.height//画面の高さ
        tableView = UITableView(frame: CGRect(x:0, y: 0, width: screenWidth, height: screenHeight), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
}
extension MasterViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sections[indexPath.section].items[indexPath.row]
        ct = ct+1
        cell.tag = ct
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}
extension MasterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let view = viewSetting()
        switch sections[indexPath.section].items[indexPath.row] {
            case "アカウント":
                if (indexPath.section==0){
                    appDelegate.viewType = "アカウント"
                }
            case "二次元コード":
                if (indexPath.section==0){
                    appDelegate.viewType = "二次元コード"
                }
            case "サウンド":
                if (indexPath.section==0){
                    appDelegate.viewType = "サウンド"
                }
            case "年代別来店割合":
                if (indexPath.section==2){
                    let alert = UIAlertController(title: "パスワードを入力して下さい", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                        (action:UIAlertAction!) -> Void in
                       // OKを押した時入力されていたテキストを表示
                        if let textFields = alert.textFields {
                            // アラートに含まれるすべてのテキストフィールドを調べる
                            for textField in textFields {
                                if textField.text! == "1234"{
                                       appDelegate.viewType = "年代別来店割合"
                                       self.present(view.viewSet(view: Test(), anime: .flipHorizontal), animated: false, completion: nil)
                                }else if textField.text! != "1234"{
                                    let ngalert = UIAlertController(title: "パスワードが違います", message: "", preferredStyle: .alert)
                                    ngalert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
                                    // アラート表示
                                    self.present(ngalert, animated: true, completion: {
                                        // アラートを閉じる
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                            ngalert.dismiss(animated: true, completion: nil)
                                        })
                                    })
                                }
                            }
                        }
                   })
                   alert.addAction(okAction)
                   
                   // キャンセルボタンの設定
                   let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                   alert.addAction(cancelAction)
                   
                   // テキストフィールドを追加
                   alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
                       textField.isSecureTextEntry = true
                   })
                   
                   // 複数追加したいならその数だけ書く
                   // alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
                   //     textField.placeholder = "テキスト"
                   // })
                   
                   alert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
                   
                   // アラートを画面に表示
                   self.present(alert, animated: true, completion: nil)
                }
            case "年代別平均皿数":
                if (indexPath.section==2){
                    appDelegate.viewType = "年代別平均皿数"
                }
            case "realm":
                if (indexPath.section==3){
                    appDelegate.viewType = "realm"
                }
            default:
                break
            }
    let SViewController: UIViewController = Test()
    //Viewの移動する.
    SViewController.modalPresentationStyle = .fullScreen
    self.present(SViewController, animated: false, completion: nil)
    /* //AppDelegateクラスでローカル通知を受け取った際に、画面遷移させたいといった場合などはこの方法(しかしここではチラつく)
    appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
    // rootViewControllerに入れる
    appDelegate.window?.rootViewController = Test()
    // 表示
    if appDelegate.window?.rootViewController == Test(){
    appDelegate.window?.makeKeyAndVisible()
    }*/
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
