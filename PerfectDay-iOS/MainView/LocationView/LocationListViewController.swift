//
//  LocationListViewController.swift
//  PerfectDay-iOS
//
//  Created by 문종식 on 2020/03/05.
//  Copyright © 2020 문종식. All rights reserved.
//

import UIKit
import MaterialDesignWidgets

class LocationListViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var uvKategorie: UIView!
    @IBOutlet var svKategorie: UIStackView!
    @IBOutlet var svLocation: UIStackView!
    @IBOutlet var scvFilter: UIScrollView!
    @IBOutlet var svFilterBtn: UIStackView!
    @IBOutlet var scrollMain: UIScrollView!
    @IBOutlet var uvLocationList: UIView!
    
    
    @IBOutlet var initFilterBtn: UIButton!
    @IBOutlet var preferFilterBtn: UIButton!
    @IBOutlet var distanceFilterBtn: UIButton!
    @IBOutlet var priceFilterBtn: UIButton!
    @IBOutlet var timeFilterBtn: UIButton!
    
    
    @IBOutlet var uvFilterPopupBack: UIView!
    @IBOutlet var uvFilterView: UIView!
    @IBOutlet var uvFilter: UIView!
    
    
    let testNum = 15
    let lightGray = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    let themeColor = #colorLiteral(red: 0.9882352941, green: 0.3647058824, blue: 0.5725490196, alpha: 1)
    let backColor = #colorLiteral(red: 0.9937904477, green: 0.9502945542, blue: 0.9648948312, alpha: 1)
    
    var tempBtn : UIButton?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setKategorie()
        setLocationList()
        setFilterBtnList()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setNavigationBar(){
        self.navigationItem.title = "완벽한 하루"
        let backItem = UIBarButtonItem()
        backItem.title = " "
        self.navigationItem.backBarButtonItem = backItem
    }
    
    func setKategorie(){
        let btnAll = MaterialVerticalButton(icon: UIImage(named: "KategorieAll")!, title: "전체보기", foregroundColor: .black, useOriginalImg: true, bgColor: .white)
        let btnEat = MaterialVerticalButton(icon: UIImage(named: "KategorieEat")!, title: "먹기", foregroundColor: .black, useOriginalImg: true, bgColor: .white)
        let btnDrink = MaterialVerticalButton(icon: UIImage(named: "KategorieDrink")!, title: "마시기", foregroundColor: .black, useOriginalImg: true, bgColor: .white)
        let btnPlay = MaterialVerticalButton(icon: UIImage(named: "KategoriePlay")!, title: "놀기", foregroundColor: .black, useOriginalImg: true, bgColor: .white)
        let btnWatch = MaterialVerticalButton(icon: UIImage(named: "KategorieWatch")!, title: "보기", foregroundColor: .black, useOriginalImg: true, bgColor: .white)
        let btnWalk = MaterialVerticalButton(icon: UIImage(named: "KategorieWalk")!, title: "걷기", foregroundColor: .black, useOriginalImg: true, bgColor: .white)
        
        let btnArray = [btnAll,btnEat,btnDrink,btnPlay,btnWatch,btnWalk]
        
        uvKategorie.layer.shadowColor = UIColor.lightGray.cgColor
        uvKategorie.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        uvKategorie.layer.shadowRadius = 2.0
        uvKategorie.layer.shadowOpacity = 0.5
        
        for btn in btnArray {
            btn.label.font = btn.label.font.withSize(13)
            svKategorie.addArrangedSubview(btn)
        }
    }
    
    //Filter Btn
    func setFilterBtnList(){
        for btn in svFilterBtn.arrangedSubviews {
            btn.layer.cornerRadius = svFilterBtn.frame.height/2
            btn.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            btn.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            btn.layer.shadowColor = UIColor.lightGray.cgColor
            btn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            btn.layer.shadowRadius = 2.0
            btn.layer.shadowOpacity = 0.5
        }
        scrollViewDidScroll(scvFilter)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = false
    }
    
    @IBAction func changeForm(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            print("List")
        } else {
            print("Block")
        }
    }
    
    
    //filter PopUp
    @IBAction func FilterPopup(_ sender: UIButton?) {
        
        setFilterView()
        
        if sender == tempBtn {
            
            if self.uvFilterPopupBack.isHidden == false {
                self.uvFilterPopupBack.isHidden = true
            } else {
                self.uvFilterPopupBack.isHidden = false
            }
        } else {
            self.uvFilterPopupBack.isHidden = false
            self.uvFilter.removeSubviews()
            if sender == initFilterBtn {
                self.initFilterBtn.isHidden = true
                //
                //초기화 코드 추가 예정
                //
            }
            else if sender == preferFilterBtn {
                preferFilter()
            }
            else {
                sliderFilters(sender)
            }
        }
        
        tempBtn = sender
    }
    
    func setFilterView(){
        self.uvFilterView.translatesAutoresizingMaskIntoConstraints = false
        //        self.uvFilterView.layer.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        self.uvFilterView.layer.cornerRadius = 15
        //        self.uvFilter.backgroundColor = .cyan
        self.uvFilter.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func preferFilter(){
        let lbPrefer = UIButton(type: .custom)
        lbPrefer.setTitle("선호순", for: .normal)
        lbPrefer.setTitleColor(.darkGray, for: .normal)
        lbPrefer.setImage(UIImage(named: "FilterCheck"), for: .normal)
        lbPrefer.semanticContentAttribute = .forceRightToLeft
        lbPrefer.titleLabel?.fontSize = 15
        lbPrefer.isUserInteractionEnabled = false
        let lbCloser = UIButton(type: .custom)
        lbCloser.setTitle("가까운순", for: .normal)
        lbCloser.setTitleColor(.darkGray, for: .normal)
        lbCloser.setImage(UIImage(named: "FilterCheck"), for: .normal)
        lbCloser.semanticContentAttribute = .forceRightToLeft
        lbCloser.titleLabel?.fontSize = 15
        lbCloser.isUserInteractionEnabled = false
        let lbHigherPrice = UIButton(type: .custom)
        lbHigherPrice.setTitle("높은 가격순", for: .normal)
        lbHigherPrice.setTitleColor(.darkGray, for: .normal)
        lbHigherPrice.setImage(UIImage(named: "FilterCheck"), for: .normal)
        lbHigherPrice.semanticContentAttribute = .forceRightToLeft
        lbHigherPrice.titleLabel?.fontSize = 15
        lbHigherPrice.isUserInteractionEnabled = false
        let lbLowerPrice = UIButton(type: .custom)
        lbLowerPrice.setTitle("낮은 가격순", for: .normal)
        lbLowerPrice.setTitleColor(.darkGray, for: .normal)
        lbLowerPrice.setImage(UIImage(named: "FilterCheck"), for: .normal)
        lbLowerPrice.semanticContentAttribute = .forceRightToLeft
        lbLowerPrice.titleLabel?.fontSize = 15
        lbLowerPrice.isUserInteractionEnabled = false
        let lbLongStayTime = UIButton(type: .custom)
        lbLongStayTime.setTitle("머무는 시간 ↑", for: .normal)
        lbLongStayTime.setTitleColor(.darkGray, for: .normal)
        lbLongStayTime.setImage(UIImage(named: "FilterCheck"), for: .normal)
        lbLongStayTime.semanticContentAttribute = .forceRightToLeft
        lbLongStayTime.titleLabel?.fontSize = 15
        lbLongStayTime.isUserInteractionEnabled = false
        let lbShortStayTime = UIButton(type: .custom)
        lbShortStayTime.setTitle("머무는 시간 ↓", for: .normal)
        lbShortStayTime.setTitleColor(.darkGray, for: .normal)
        lbShortStayTime.setImage(UIImage(named: "FilterCheck"), for: .normal)
        lbShortStayTime.semanticContentAttribute = .forceRightToLeft
        lbShortStayTime.titleLabel?.fontSize = 15
        //        lbShortStayTime.imageRect(forContentRect: CGRect(x: 0, y: 0, width: 35, height: 35))
        lbShortStayTime.isUserInteractionEnabled = false
        lbShortStayTime.adjustsImageSizeForAccessibilityContentSizeCategory = true
        
        let svFilter = UIStackView(arrangedSubviews: [lbPrefer,lbCloser,lbHigherPrice,lbLowerPrice,lbLongStayTime,lbShortStayTime])
        svFilter.translatesAutoresizingMaskIntoConstraints = false
        svFilter.axis = .vertical
        svFilter.distribution = .equalSpacing
        svFilter.widthAnchor.constraint(equalToConstant: uvFilterView.frame.width - 40).isActive = true
        svFilter.heightAnchor.constraint(equalTo: svFilter.widthAnchor, multiplier: 0.63).isActive = true
        
        uvFilter.addSubview(svFilter)
        uvFilter.addConstraint(NSLayoutConstraint(item: svFilter, attribute: .centerX, relatedBy: .equal, toItem: uvFilter, attribute: .centerX, multiplier: 1, constant: 0))
        uvFilter.addConstraint(NSLayoutConstraint(item: svFilter, attribute: .centerY, relatedBy: .equal, toItem: uvFilter, attribute: .centerY, multiplier: 1, constant: 0))
        uvFilter.widthAnchor.constraint(equalTo: svFilter.widthAnchor, multiplier: 1).isActive = true
        uvFilter.heightAnchor.constraint(equalToConstant: 35 * 6).isActive = true
        
    }
    
    func sliderFilters(_ sender: UIButton?){
        
        let lbTitle = UILabel()
        lbTitle.font = UIFont.boldSystemFont(ofSize: 17.0)
        let lbRange = UILabel()
        lbRange.font = UIFont.boldSystemFont(ofSize: 19.0)
        lbRange.textColor = themeColor
        let svLabel = UIStackView(arrangedSubviews: [lbTitle, lbRange])
        svLabel.axis = .vertical
        svLabel.distribution = .fillProportionally
        svLabel.spacing = 15
        svLabel.widthAnchor.constraint(equalToConstant: uvFilterView.frame.width - 40).isActive = true
        //        svLabel.heightAnchor.constraint(equalTo: svLabel.widthAnchor, multiplier: 0.1).isActive = true
        //
        let slider = UISlider()
        slider.widthAnchor.constraint(equalToConstant: uvFilterView.frame.width - 40).isActive = true
        slider.minimumTrackTintColor = themeColor
        //
        let minInt = UILabel()
        let quarterInt = UILabel()
        let threequarterInt = UILabel()
        let maxInt = UILabel()
        minInt.fontSize = 13
        quarterInt.fontSize = 13
        threequarterInt.fontSize = 13
        maxInt.fontSize = 13
        quarterInt.textAlignment = .center
        threequarterInt.textAlignment = .center
        maxInt.textAlignment = .right
        let svRange = UIStackView(arrangedSubviews: [minInt,quarterInt,threequarterInt,maxInt])
        svRange.axis = .horizontal
        svRange.distribution = .fillEqually
        
        let btnSetFilter = UIButton(type: .custom)
        
        btnSetFilter.setTitle("완료", for: .normal)
        btnSetFilter.setTitleColor(.white, for: .normal)
        btnSetFilter.backgroundColor = themeColor
        btnSetFilter.contentHorizontalAlignment = .center
        btnSetFilter.translatesAutoresizingMaskIntoConstraints = false
        btnSetFilter.layer.cornerRadius = 5
        btnSetFilter.widthAnchor.constraint(equalToConstant: uvFilterView.frame.width - 40).isActive = true
        btnSetFilter.heightAnchor.constraint(equalTo: btnSetFilter.widthAnchor, multiplier: 40/295, constant: 1).isActive = true
        
        
        if sender == distanceFilterBtn {
            lbTitle.text = "거리"
            lbRange.text = String(Double(slider.value)/10) + "km"
            slider.minimumValue = 0
            slider.maximumValue = 30
            minInt.text = "0m"
            quarterInt.text = "1km"
            threequarterInt.text = "2km"
            maxInt.text = "3km+"
        }
        else if sender == priceFilterBtn {
            lbTitle.text = "대표메뉴 가격"
            lbRange.text = String(Double(slider.value)/10) + "만원"
            slider.minimumValue = 0
            slider.maximumValue = 70
            minInt.text = "0원"
            quarterInt.text = "2만원"
            threequarterInt.text = "4만원"
            maxInt.text = "7만원+"
        }
        else if sender == timeFilterBtn {
            lbTitle.text = "예상 소요시간"
            lbRange.text = String(Double(slider.value)/6) + "시간"
            slider.minimumValue = 0
            slider.maximumValue = 18
            minInt.text = "0시간"
            quarterInt.text = "1시간"
            threequarterInt.text = "2시간"
            maxInt.text = "3시간+"
        }
        
        let svFilter = UIStackView(arrangedSubviews: [svLabel,slider,svRange,btnSetFilter])
        svFilter.translatesAutoresizingMaskIntoConstraints = false
        svFilter.axis = .vertical
        svFilter.distribution = .equalSpacing
        svFilter.widthAnchor.constraint(equalToConstant: uvFilterView.frame.width - 40).isActive = true
        svFilter.heightAnchor.constraint(equalTo: svFilter.widthAnchor, multiplier: 170/295).isActive = true
        
        uvFilter.addSubview(svFilter)
        uvFilter.addConstraint(NSLayoutConstraint(item: svFilter, attribute: .centerX, relatedBy: .equal, toItem: uvFilter, attribute: .centerX, multiplier: 1, constant: 0))
        uvFilter.addConstraint(NSLayoutConstraint(item: svFilter, attribute: .centerY, relatedBy: .equal, toItem: uvFilter, attribute: .centerY, multiplier: 1, constant: 0))
        uvFilter.widthAnchor.constraint(equalTo: svFilter.widthAnchor, multiplier: 1).isActive = true
        uvFilter.heightAnchor.constraint(equalTo: svFilter.heightAnchor, multiplier: 1).isActive = true
        
    }
    
    
    
    
    func setLocationList(){
        setLocationListBackView()
        setStackView()
        for i in 0...15 {
            makeItem(i)
        }
    }
    
    func setStackView(){
        svLocation.axis = .vertical
        svLocation.spacing = 10
        //        svLocation.topAnchor.constraint(equalTo: svLocation.topAnchor, constant: 10).isActive = true
    }
    func setLocationListBackView(){
        uvLocationList.translatesAutoresizingMaskIntoConstraints = false
        uvLocationList.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        uvLocationList.layer.cornerRadius = 15
        uvLocationList.layer.shadowColor = UIColor.lightGray.cgColor
        uvLocationList.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        uvLocationList.layer.shadowRadius = 2.0
        uvLocationList.layer.shadowOpacity = 0.5
    }
    
    func makeItem(_ num: Int) {
        
        let uvLocation = UIView()
        uvLocation.translatesAutoresizingMaskIntoConstraints = false
        uvLocation.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        uvLocation.layer.cornerRadius = 5
        uvLocation.layer.borderWidth = 0.5
        uvLocation.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        
        
        let storeType = UILabel()
        storeType.text = "장소유형"
        storeType.fontSize = 13
        storeType.textColor = .systemBlue
        let storeNm = UILabel()
        storeNm.text = "장소명" + String(num)
        storeNm.font = UIFont.boldSystemFont(ofSize: 19.0)
        let svUpperLeft = UIStackView(arrangedSubviews: [storeType,storeNm])
        svUpperLeft.distribution = .fillEqually
        svUpperLeft.axis = .vertical
        svUpperLeft.spacing = 2
        let plannerBtn = UIButton()
        plannerBtn.setImage(UIImage(named: "AddPlannerBtn"), for: .normal)
        plannerBtn.contentHorizontalAlignment = .right
        let svTop = UIStackView(arrangedSubviews: [svUpperLeft,plannerBtn])
        svTop.axis = .horizontal
        svTop.distribution = .fillProportionally
        svTop.widthAnchor.constraint(equalToConstant: (view.frame.width * 0.56) - 15 ).isActive = true
        svTop.heightAnchor.constraint(equalToConstant: (view.frame.width * 0.12) - 7 ).isActive = true
        
        let reprMenuPrice = UILabel()
        reprMenuPrice.text = "대표메뉴 " + String(num * 1000) + "원"
        reprMenuPrice.fontSize = 14
        let areaDetailNm = UIButton(type: .custom)
        areaDetailNm.setTitle("서울 광진구 자양동", for: .normal)
        areaDetailNm.setTitleColor(.darkGray, for: .normal)
        areaDetailNm.setImage(UIImage(named: "AddressIcon"), for: .normal)
        areaDetailNm.titleLabel?.fontSize = 14
        areaDetailNm.isUserInteractionEnabled = false
        areaDetailNm.contentHorizontalAlignment = .left
        
        //해시태그 추후 추가 예정
        let svHashTag = UIStackView()
        setHashTagList(svHashTag)
        let scvHashTag = UIScrollView()
        scvHashTag.addSubview(svHashTag)
        //        scvHashTag.backgroundColor = .systemPink
        scvHashTag.addConstraint(NSLayoutConstraint(item: svHashTag, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: scvHashTag, attribute: .left, multiplier: 1, constant: 0))
        scvHashTag.addConstraint(NSLayoutConstraint(item: svHashTag, attribute: .centerY, relatedBy: .greaterThanOrEqual, toItem: scvHashTag, attribute: .centerY, multiplier: 1, constant: 0))
        svHashTag.widthAnchor.constraint(equalTo: scvHashTag.widthAnchor, multiplier: 1).isActive = true
        svHashTag.heightAnchor.constraint(equalTo: scvHashTag.heightAnchor, multiplier: 1).isActive = true
        scvHashTag.bounces = false
        
        
        let storeFavorCount = UILabel()
        storeFavorCount.text = "999+"
        storeFavorCount.textColor = .darkGray
        storeFavorCount.baselineAdjustment = .alignCenters
        storeFavorCount.fontSize = 14
        storeFavorCount.widthAnchor.constraint(equalTo: storeFavorCount.heightAnchor, multiplier: 2).isActive = true
        let favorImg = UIImageView(image: UIImage(named: "EmptyHeart"))
        favorImg.contentMode = .scaleAspectFill
        let storeScore = UILabel()
        storeScore.text = "4.5"
        storeScore.baselineAdjustment = .alignCenters
        storeScore.textColor = .darkGray
        storeFavorCount.widthAnchor.constraint(equalTo: storeFavorCount.heightAnchor, multiplier: 2).isActive = true
        storeScore.fontSize = 14
        let scoreImage = UIImageView(image: UIImage(named: "GPAIcon"))
        let Distance = UILabel()
        Distance.text = "00M"
        Distance.textColor = .darkGray
        Distance.font = UIFont.boldSystemFont(ofSize: 18.0)
        Distance.textAlignment = .right
        let svBottomInfo = UIStackView(arrangedSubviews: [favorImg,storeFavorCount,scoreImage,storeScore,Distance])
        svBottomInfo.spacing = 5
        svBottomInfo.axis = .horizontal
        svBottomInfo.distribution = .fillProportionally
        let svBottom = UIStackView(arrangedSubviews: [reprMenuPrice,areaDetailNm,scvHashTag,svBottomInfo])
        svBottom.widthAnchor.constraint(equalToConstant: (view.frame.width * 0.56) - 15 ).isActive = true
        svBottom.heightAnchor.constraint(equalToConstant: (view.frame.width * 0.22) - 7 ).isActive = true
        svBottom.axis = .vertical
        svBottom.distribution = .fillEqually
        svBottom.spacing = 2
        
        let storeImage = UIImageView(image: UIImage(named: "TempImage"))
        storeImage.widthAnchor.constraint(equalToConstant: (view.frame.width) * 0.34 ).isActive = true
        storeImage.heightAnchor.constraint(equalTo: storeImage.widthAnchor, multiplier: 1, constant: 0).isActive = true
        storeImage.clipsToBounds = true
        storeImage.layer.cornerRadius = 5
        storeImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let svInfo = UIStackView(arrangedSubviews: [svTop,svBottom])
        svInfo.translatesAutoresizingMaskIntoConstraints = false
        svInfo.axis = .vertical
        let uvInfo = UIView()
        uvInfo.addSubview(svInfo)
        uvInfo.translatesAutoresizingMaskIntoConstraints = false
        uvInfo.addConstraint(NSLayoutConstraint(item: svInfo, attribute: .centerX, relatedBy: .equal, toItem: uvInfo, attribute:.centerX, multiplier: 1, constant: 0))
        uvInfo.addConstraint(NSLayoutConstraint(item: svInfo, attribute: .centerY, relatedBy: .equal, toItem: uvInfo, attribute: .centerY, multiplier: 1, constant: 0))
        svInfo.heightAnchor.constraint(equalTo: uvInfo.heightAnchor, multiplier: 0.9).isActive = true
        svInfo.widthAnchor.constraint(equalTo: uvInfo.widthAnchor, multiplier: 0.9).isActive = true
        
        let svItem = UIStackView(arrangedSubviews: [storeImage,uvInfo])
        svItem.translatesAutoresizingMaskIntoConstraints = false
        svItem.axis = .horizontal
        svItem.distribution = .fill
        
        uvLocation.addSubview(svItem)
        uvLocation.addConstraint(NSLayoutConstraint(item: svItem, attribute: .centerX, relatedBy: .equal, toItem: uvLocation, attribute: .centerX, multiplier: 1, constant: 0))
        uvLocation.addConstraint(NSLayoutConstraint(item: svItem, attribute: .centerY, relatedBy: .equal, toItem: uvLocation, attribute: .centerY, multiplier: 1, constant: 0))
        svItem.widthAnchor.constraint(equalTo: uvLocation.widthAnchor, multiplier: 1).isActive = true
        svItem.heightAnchor.constraint(equalTo: uvLocation.heightAnchor, multiplier: 1).isActive = true
        
        self.svLocation.addArrangedSubview(uvLocation)
        
        uvLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gotoLocationInfo)))
    }
    
    @objc func gotoLocationInfo(){
        //        print("debug")
        let goToVC = self.storyboard?.instantiateViewController(withIdentifier: "locationInfoView")
        self.navigationController?.pushViewController(goToVC!, animated: true)
    }
    
    //HashTag
    func setHashTagList(_ svHashTag : UIStackView) {
        svHashTag.axis = .horizontal
        svHashTag.spacing = 5
        
        for i in 0...5 {
            makeHashTag(i, svHashTag)
        }
    }
    
    func makeHashTag(_ num: Int,_ svHashTag: UIStackView){
        let HashTagBtn = UIButton(type: .custom)
        HashTagBtn.isUserInteractionEnabled = false
        HashTagBtn.setTitle("#HashTag" + String(num), for: .normal)
        HashTagBtn.setTitleColor(.darkGray, for: .normal)
        HashTagBtn.backgroundColor = .lightGray
        HashTagBtn.titleLabel?.fontSize = 11
        HashTagBtn.contentHorizontalAlignment = .fill
        HashTagBtn.layer.cornerRadius = 10
        HashTagBtn.layer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        svHashTag.addArrangedSubview(HashTagBtn)
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
