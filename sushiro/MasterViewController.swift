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

class MasterViewController: UIViewController, UITableViewDelegate {
    private var tableView = UITableView()
    private var sections = Section.make()
    var ct = 0
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let screenWidth: CGFloat = UIScreen.main.bounds.width   //画面の幅
        let screenHeight: CGFloat = UIScreen.main.bounds.height//画面の高さ
        tableView = UITableView(frame: CGRect(x:0, y: 0, width: screenWidth, height: screenHeight), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
}

//UITableViewDataSource関連
extension MasterViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sections[indexPath.section].items[indexPath.row]
        ct += 1
        cell.tag = ct
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section].items[indexPath.row] {
            case "アカウント":
                if (indexPath.section == 0){
                    appDelegate.viewType = "アカウント"
                }
            case "二次元コード":
                if (indexPath.section == 0){
                    appDelegate.viewType = "二次元コード"
                }
            case "サウンド":
                if (indexPath.section == 0){
                    appDelegate.viewType = "サウンド"
                }
            case "年代別来店割合":
                if (indexPath.section == 2){
                    appDelegate.viewType = "年代別来店割合"
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
        ViewSetting().set(view: self, transition: Test())
    }
}
