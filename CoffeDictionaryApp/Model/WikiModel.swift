//
//  WikiModel.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/28.
//

import Foundation


struct SendMessage: Codable{
    let argument: Argument
}
struct Argument: Codable{
    let type: String
    let question: String
}

//"request_id": "reserved field",
//"result": 0,
//"return_type": "com.google.gson.internal.LinkedTreeMap",
//"return_object": {위키백과 QA 결과 JSON}

struct WikiResponse: Codable{
    let result: Int?
    let return_object: WikiObject?
}

//result = 0;
//"return_object" =     {
//    WiKiInfo =         {
//        AnswerInfo =             (
//        );
//        IRInfo =             (
//                            {
//                sent = "";
//                "wiki_title" = "";
//            }
//        );
//    };
//};
struct WikiObject: Codable{
    let IRInfo: String?
    let AnswerInfo: String?
//    let sentAnswerInfo String?
    let rank: Int?
    let answer: String?
    let confidence: String?
}


//IRInfo    검색 정보 Json Object Array
//wiki_title    검색 결과의 위키백과 타이틀
//sent    검색 단락
//AnswerInfo    정답 정보 Json Object Array
//rank    정답 순위
//answer    정답
//confidence    정답의 신뢰도
