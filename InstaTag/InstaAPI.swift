//
//  InstaAPI.swift
//  InstaTag
//
//  Created by Эрик Вильданов on 24.09.16.
//  Copyright © 2016 ErikVildanov. All rights reserved.
//

import UIKit

class InstaAPI {
    let kAccessToken = "access_token="
    
    let kBaseURL = "https://instagram.com/"
    let kInstagramAPIBaseURL = "https://api.instagram.com"
    let kAuthenticationURL = "oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token&scope=public_content+basic+follower_list+comments+relationships+likes"  // comments
    let kClientID = "c1a7a03fc3cb48adbb1e77293b95ecce" // enter your client id obtained by registering your application on Instagram
    let kRedirectURI = "https://127.0.0.1" // enter the redirect uri that you mentioned while registering the client on Instagram
    
}
