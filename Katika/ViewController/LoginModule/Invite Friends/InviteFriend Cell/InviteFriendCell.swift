//
//  InviteFriendCell.swift
//  Katika
//
//  Created by icoderz_04 on 16/10/18.
//  Copyright © 2018 icoderz123. All rights reserved.
//

import UIKit

class InviteFriendCell: UITableViewCell {

    //Declaration Resend View
    @IBOutlet weak var viewResend: UIView!
    @IBOutlet weak var lblResendName: UILabel!
    @IBOutlet weak var lblResendEmail: UILabel!
    @IBOutlet weak var btnResendClicked: UIButton!
    
    //Declaration Send View
    @IBOutlet weak var viewSend: UIView!
    @IBOutlet weak var lblSendName: UILabel!
    @IBOutlet weak var btnSendClicked: UIButton!
    @IBOutlet weak var lblSendEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        //SET FONT
        lblResendName.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 14)/Constant.screenWidthDeveloper))
        lblSendName.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 14)/Constant.screenWidthDeveloper))
        lblResendEmail.font = UIFont(name: Constant.kFontSemiBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
        lblSendEmail.font = UIFont(name: Constant.kFontSemiBold, size: CGFloat((Constant.windowWidth * 13)/Constant.screenWidthDeveloper))
        
        
        btnSendClicked.titleLabel?.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 14)/Constant.screenWidthDeveloper))
        btnResendClicked.titleLabel?.font = UIFont(name: Constant.kFontBold, size: CGFloat((Constant.windowWidth * 14)/Constant.screenWidthDeveloper))


        //SET RESEND BUTTON
        btnSendClicked.layer.masksToBounds = true
        btnSendClicked.layer.cornerRadius = 10
        
        //SET SEND BUTTON
        btnResendClicked.layer.masksToBounds = true
        btnResendClicked.layer.cornerRadius = 10
        btnResendClicked.layer.borderWidth=1.0
        btnResendClicked.layer.borderColor=UIColor.red.cgColor
        
    }
    
}
