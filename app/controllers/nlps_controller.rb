require 'rest-client'
require 'json'

class NlpsController < ApplicationController
  def index
  end

  def analyze 
    posts = '{"text" : "' + params[:text] + '"}'
    nlp_result = posts_process(posts)
    unless nlp_result["error_code"]
      word_hash = word_frequency(nlp_result)
      respond_to do |f|
        f.json { render :json => {word_count: word_hash}.to_json}
      end
    else
      respond_to do |f|
        f.json { render :json => {word_count: [[nlp_result["error_code"], nlp_result["error_msg"]]]}.to_json}
      end
    end
  end 

  private
    def posts_process(posts)
      url = "https://aip.baidubce.com/rpc/2.0/nlp/v1/lexer?access_token=24.46ff820f7ffaac61010d56cde74afbb3.2592000.1515484768.282335-10508969"
      posts.encode! "GBK", "UTF-8"
      res = RestClient.post url, posts, :content_type => "application/json", :accept => :json
      res.encode! "UTF-8", "GBK"
      puts res
      res = JSON.parse(res.body) 
    end

    def word_frequency data 
      word_hash = Hash.new 
      eliminate_arr = ["d", "u", "w"]
      data["items"].each do |word|
        if eliminate_arr.include?(word["pos"])
          next
        end
        if word_hash[word["item"]].nil?
          word_hash[word["item"]] = 1
        else
          word_hash[word["item"]] += 1
        end
      end
      word_hash = word_hash.sort {|k, v| v[1]<=>k[1]}
    end
end
