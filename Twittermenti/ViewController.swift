//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    let swifter = Swifter(consumerKey: "Q0pY6tM3k6eT1dn1Ol0BA1xpg", consumerSecret: "lBSkpW8sqKb6SAORQqNC3nWKippKIbaD7wbmRAs3PAVH3MAJyA")

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func predictPressed(_ sender: Any) {
    
      
    if  let searchText = textField.text {
          
          swifter.searchTweet(using: searchText ,lang:"en",count: 100,tweetMode: .extended,success: { (results, metadata) in
              
              var tweets = [TweetSentimentClassifierInput]()
              for i in 0..<100 {
                  if let tweet = results[i]["full_text"].string {
                      let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                      tweets.append(tweetForClassification)
                      
                  }
                  do{
                      let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
                      var score = 0
                      for prediction in predictions {
                          
                          let sentiment = prediction.label
                          if sentiment == "Pos" {
                              score = score + 1
                          }
                          else if sentiment == "neg" {
                              score = score - 1
                          }
                        
                    }
                    
                    if score > 20 {
                        self.sentimentLabel.text = "😍"
                    }
                    else if score > 10 {
                        self.sentimentLabel.text = "😊"

                    }
                    else if score > 0 {
                        self.sentimentLabel.text = "🙂"

                    }
                    else if score == 0 {
                        self.sentimentLabel.text = "😐"

                    }
                    else if score > -10 {
                        self.sentimentLabel.text = "😕"

                    }
                    
                    else if score > -20 {
                        self.sentimentLabel.text = "😡"

                    }
                    else {
                        self.sentimentLabel.text = "🤮"

                    }

                  }catch{
                      print("ERROR : ,\(error)")
                  }

                  
              }
              
              
              
              
              
              
              
          }) { (error) in
              print("There was an error with the Twitter API Request, \(error)")
          }

          
      }
    }
    
}

