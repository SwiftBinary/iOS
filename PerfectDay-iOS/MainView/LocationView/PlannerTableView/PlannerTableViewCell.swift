//
//  PlannerTableViewCell.swift
//  PerfectDay-iOS
//
//  Created by NewRun on 2020/07/02.
//  Copyright © 2020 문종식, 강고운. All rights reserved.
//


import UIKit

class PlannerTableViewCell: UITableViewCell {
    
    static let identifier = "PlannerCell"
    
    let uvItem : UIView = {
        let uvItem = UIView()
        uvItem.translatesAutoresizingMaskIntoConstraints = false
        uvItem.tintColor = .clear
        return uvItem
    }()
    let locationImage: UIImageView = {
        let locationImage = UIImageView(image: UIImage(named: "TempImage"))
        locationImage.translatesAutoresizingMaskIntoConstraints = false
        locationImage.clipsToBounds = true
        locationImage.layer.cornerRadius = 5
        locationImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return locationImage
    }()
    var prefData: String = ""
    var prefSn: String = ""
    var storeSn: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    let storeType: UILabel = {
        let storeType = UILabel()
        //        storeType.fontSize = 13
        storeType.font = UIFont.boldSystemFont(ofSize: 13.0)
        storeType.textColor = .systemBlue
        return storeType
    }()
    let storeNm: UILabel = {
        let storeNm = UILabel()
        storeNm.translatesAutoresizingMaskIntoConstraints = false
        storeNm.font = UIFont.boldSystemFont(ofSize: 17.0)
        return storeNm
    }()
    let reprMenuPrice: UILabel = {
        let reprMenuPrice = UILabel()
        reprMenuPrice.translatesAutoresizingMaskIntoConstraints = false
        //        reprMenuPrice.fontSize = 13
        reprMenuPrice.font = UIFont.boldSystemFont(ofSize: 13.0)
        reprMenuPrice.textColor = .darkGray
        return reprMenuPrice
    }()
    let storeAddr: UILabel = {
        let storeAddr = UILabel()
        storeAddr.translatesAutoresizingMaskIntoConstraints = false
        storeAddr.textColor = .darkGray
        //        storeAddr.fontSize = 13
        storeAddr.font = UIFont.boldSystemFont(ofSize: 13.0)
        return storeAddr
    }()
    let sequenceBtn: UIButton = {
        let sequenceBtn = UIButton(type: .custom)
        sequenceBtn.translatesAutoresizingMaskIntoConstraints = false
        sequenceBtn.setTitle("0", for: .normal)
        sequenceBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
        sequenceBtn.setTitleColor(.white, for: .normal)
        sequenceBtn.contentHorizontalAlignment = .center
        sequenceBtn.contentVerticalAlignment = .center
        sequenceBtn.isUserInteractionEnabled = false
        sequenceBtn.layer.cornerRadius = 10.5
        sequenceBtn.backgroundColor = #colorLiteral(red: 1, green: 0.2955724597, blue: 0.5731969476, alpha: 1)
        return sequenceBtn
    }()
    let deleteBtn: UIButton = {
        let deleteBtn = UIButton(type: .custom)
        deleteBtn.setImage(UIImage(named: "DeletePlannerItem"), for: .normal)
        return deleteBtn
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addContentView()
    }
    
    private func addContentView() {
        //차수 뒤 회색 선을 위한 뷰
        let uvBack = UIView()
        uvBack.translatesAutoresizingMaskIntoConstraints = false
        let uvline = UIView()
        uvline.translatesAutoresizingMaskIntoConstraints = false
        uvline.backgroundColor = .lightGray
        uvBack.addSubview(uvline)
        
        uvBack.widthAnchor.constraint(equalToConstant: safeAreaLayoutGuide.layoutFrame.width - 40).isActive = true
        uvBack.heightAnchor.constraint(equalTo: uvBack.widthAnchor, multiplier: 0.3).isActive = true
        
        uvline.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0, constant: 2).isActive = true
        uvline.heightAnchor.constraint(equalTo: uvBack.heightAnchor, multiplier: 1).isActive = true
        uvline.leftAnchor.constraint(equalTo: uvBack.leftAnchor, constant: 25).isActive = true
        uvline.topAnchor.constraint(equalTo: uvBack.topAnchor, constant: 0).isActive = true
        uvline.bottomAnchor.constraint(equalTo: uvBack.bottomAnchor, constant: 0).isActive = true
        
        uvItem.addSubview(uvBack)
        
        
        let imgAddress = UIImageView(image: UIImage(named: "AddressIcon"))
        imgAddress.contentMode = .scaleAspectFit
        imgAddress.widthAnchor.constraint(equalToConstant: imgAddress.frame.height * 1 ).isActive = true
        let svAddress = UIStackView(arrangedSubviews: [imgAddress,storeAddr])
        svAddress.axis = .horizontal
        svAddress.distribution = .fillProportionally
        svAddress.spacing = 3
        svAddress.widthAnchor.constraint(equalToConstant: (contentView.frame.width * 0.4) - 17 ).isActive = true
        
        let svInfo = UIStackView(arrangedSubviews: [storeType,storeNm,reprMenuPrice,svAddress])
        svInfo.translatesAutoresizingMaskIntoConstraints = false
        svInfo.axis = .vertical
        svInfo.distribution = .fillProportionally
        let uvInfo = UIView()
        uvInfo.addSubview(svInfo)
        uvInfo.translatesAutoresizingMaskIntoConstraints = false
        uvInfo.widthAnchor.constraint(equalToConstant: 100).isActive = true
        uvInfo.heightAnchor.constraint(equalToConstant: 100 * 0.15 - 14).isActive = true
        uvInfo.addConstraint(NSLayoutConstraint(item: svInfo, attribute: .centerX, relatedBy: .equal, toItem: uvInfo, attribute: .centerX, multiplier: 1, constant: 0))
        uvInfo.addConstraint(NSLayoutConstraint(item: svInfo, attribute: .centerY, relatedBy: .equal, toItem: uvInfo, attribute: .centerY, multiplier: 1, constant: 0))
        svInfo.widthAnchor.constraint(equalTo: uvInfo.widthAnchor, multiplier: 1).isActive = true
        svInfo.heightAnchor.constraint(equalTo: uvInfo.heightAnchor, multiplier: 1).isActive = true
        let svMain = UIStackView(arrangedSubviews: [locationImage,uvInfo])
        locationImage.widthAnchor.constraint(equalToConstant: contentView.frame.width * 0.25 - 10).isActive = true
        locationImage.heightAnchor.constraint(equalToConstant: 100 * 0.15 - 14).isActive = true
        svMain.translatesAutoresizingMaskIntoConstraints = false
        svMain.axis = .horizontal
        svMain.distribution = .fillProportionally
        svMain.spacing = 10
        svMain.widthAnchor.constraint(equalToConstant: contentView.frame.width * 0.75 - 14).isActive = true
        svMain.heightAnchor.constraint(equalToConstant: 100 * 0.15 - 14).isActive = true
        
        let uvMain = UIView()
        uvMain.addSubview(svMain)
        uvMain.backgroundColor = .clear
        uvMain.translatesAutoresizingMaskIntoConstraints = false
        uvMain.layer.borderWidth = 1
        uvMain.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        uvMain.layer.cornerRadius = 5
        uvMain.widthAnchor.constraint(equalToConstant: contentView.frame.width * 0.75).isActive = true
        uvMain.heightAnchor.constraint(equalToConstant: 100 * 0.15).isActive = true
        uvMain.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerX, relatedBy: .equal, toItem: uvMain, attribute: .centerX, multiplier: 1, constant: 0))
        uvMain.addConstraint(NSLayoutConstraint(item: svMain, attribute: .centerY, relatedBy: .equal, toItem: uvMain, attribute: .centerY, multiplier: 1, constant: 0))
        svMain.heightAnchor.constraint(equalTo: uvMain.heightAnchor, multiplier: 1, constant: -14).isActive = true
        svMain.widthAnchor.constraint(equalTo: uvMain.widthAnchor, multiplier: 1, constant:  -14).isActive = true
        
        let uvLocation = UIView()
        uvLocation.backgroundColor = .clear
        uvLocation.addSubview(uvMain)
        uvLocation.translatesAutoresizingMaskIntoConstraints = false
        uvLocation.widthAnchor.constraint(equalToConstant: contentView.frame.width * 0.75).isActive = true
        uvLocation.heightAnchor.constraint(equalToConstant: 100).isActive = true
        uvLocation.addConstraint(NSLayoutConstraint(item: uvMain, attribute: .centerX, relatedBy: .equal, toItem: uvLocation, attribute: .centerX, multiplier: 1, constant: 0))
        uvLocation.addConstraint(NSLayoutConstraint(item: uvMain, attribute: .centerY, relatedBy: .equal, toItem: uvLocation, attribute: .centerY, multiplier: 1, constant: 0))
        uvMain.heightAnchor.constraint(equalTo: uvLocation.heightAnchor, multiplier: 1, constant: -14).isActive = true
        uvMain.widthAnchor.constraint(equalTo: uvLocation.widthAnchor, multiplier: 1, constant:  0).isActive = true
        let changeSeqBtn = UIButton(type: .custom)
//        changeSeqBtn.setImage(UIImage(named: "ChangeSequence"), for: .normal)
        changeSeqBtn.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0, constant: 10).isActive = true
        let svRight = UIStackView(arrangedSubviews: [uvLocation,changeSeqBtn])
        svRight.translatesAutoresizingMaskIntoConstraints = false
        svRight.axis = .horizontal
        svRight.distribution = .fill
        svRight.spacing = 15
        

        deleteBtn.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0, constant: 20).isActive = true
//        deleteBtn.addTarget(self, action: #selector(deleteLocation(_:)), for: .touchUpInside)
        
        
        let uvSequence = UIView()
        uvSequence.translatesAutoresizingMaskIntoConstraints = false
        uvSequence.addSubview(sequenceBtn)
        uvSequence.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0, constant: 50).isActive = true
        uvSequence.addConstraint(NSLayoutConstraint(item: sequenceBtn, attribute: .centerX, relatedBy: .equal, toItem: uvSequence, attribute: .centerX, multiplier: 1, constant: 0))
        uvSequence.addConstraint(NSLayoutConstraint(item: sequenceBtn, attribute: .centerY, relatedBy: .equal, toItem: uvSequence, attribute: .centerY, multiplier: 1, constant: 0))
        sequenceBtn.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0, constant: 21).isActive = true
        sequenceBtn.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0, constant: 21).isActive = true
//        let svLeft = UIStackView(arrangedSubviews: [deleteBtn,uvSequence])
//        svLeft.translatesAutoresizingMaskIntoConstraints = false
//        svLeft.axis = .horizontal
//        svLeft.distribution = .fill
//
        
        
        let svItem = UIStackView(arrangedSubviews: [uvSequence,svRight])
        svItem.translatesAutoresizingMaskIntoConstraints = false
        svItem.axis = .horizontal
        svItem.distribution = .fill
        
        uvItem.addSubview(svItem)
        uvItem.heightAnchor.constraint(equalToConstant: 100).isActive = true
        uvItem.addConstraint(NSLayoutConstraint(item: svItem, attribute: .centerX, relatedBy: .equal, toItem: uvItem, attribute: .centerX, multiplier: 1, constant: 0))
        uvItem.addConstraint(NSLayoutConstraint(item: svItem, attribute: .centerY, relatedBy: .equal, toItem: uvItem, attribute: .centerY, multiplier: 1, constant: 0))
        svItem.heightAnchor.constraint(equalTo: uvItem.heightAnchor, multiplier: 1, constant:  0).isActive = true
        svItem.widthAnchor.constraint(equalTo: uvItem.widthAnchor, multiplier: 1, constant:  0).isActive = true
        
        uvItem.addConstraint(NSLayoutConstraint(item: uvBack, attribute: .centerX, relatedBy: .equal, toItem: uvItem, attribute: .centerX, multiplier: 1, constant: 0))
        uvItem.addConstraint(NSLayoutConstraint(item: uvBack, attribute: .centerY, relatedBy: .equal, toItem: uvItem, attribute: .centerY, multiplier: 1, constant: 0))
        uvBack.heightAnchor.constraint(equalTo: uvItem.heightAnchor, multiplier: 1, constant:  0).isActive = true
        uvBack.widthAnchor.constraint(equalTo: uvItem.widthAnchor, multiplier: 1, constant:  0).isActive = true
        
        contentView.addSubview(uvItem)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

