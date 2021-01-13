require 'restclient'
require 'open-uri'
require 'open_uri_redirections'
require 'nokogiri'
require 'json'
require 'yaml'
require 'fileutils'
require 'base64'
require 'find'

class OcrsController < ApplicationController
  layout "application_control"
  #before_filter :authenticate_user!
  #load_and_authorize_resource

  PUBLIC_FOLDER = File.join(Rails.root, "public")
  OCR_FOLDER = PUBLIC_FOLDER + "/ocrs/"

  def index
    @ocr = Ocr.new
  end
   
  def analyze 
    @ocr = Ocr.new(ocr_params)
    type = ocr_params[:ocr_type].to_i
    imgs = @ocr.enclosures

    result = ""
    filename = "" 
    if type == Setting.ocrs.general
      imgs.each do |img|
        result += prc_general_basic(URI.decode(img.file_url))
        sleep(rand(3))
      end
      filename = Time.now.to_i.to_s + "%04d" % [rand(10000)] + ".txt"
    elsif type == Setting.ocrs.form
      imgs.each do |img|
        result = prc_form(URI.decode(img.file_url))
        filename = Time.now.to_i.to_s + "%04d" % [rand(10000)] + ".xls"
        send_data open(result).read, :filename => filename, :type => "application/force-download", :x_sendfile=>true unless result.blank?
        sleep(rand(3))
      end
      return
    elsif type == Setting.ocrs.webimage
      imgs.each do |img|
        result += prc_webimage(URI.decode(img.file_url))
        sleep(rand(3))
      end
      filename = Time.now.to_i.to_s + "%04d" % [rand(10000)] + ".txt"
    elsif type == Setting.ocrs.number
      imgs.each do |img|
        result += prc_number(URI.decode(img.file_url))
        sleep(rand(3))
      end
      filename = Time.now.to_i.to_s + "%04d" % [rand(10000)] + ".txt"
    elsif type == Setting.ocrs.formula
    elsif type == Setting.ocrs.stamp
    elsif type == Setting.ocrs.finance
    end

    FileUtils.mkdir(OCR_FOLDER) unless File.directory?(OCR_FOLDER)
    File.open(OCR_FOLDER + filename, 'a+') do |f|
      f.syswrite result
    end
    send_file File.join(Rails.root, "public", "ocrs", filename), :filename => filename, :type => "application/force-download", :x_sendfile=>true
  end 

  def prc_general_basic(file_url)
    result = ''
    body = general_basic(file_url)
    unless body['error_code'].nil?
      result += "error--------" + body['error_msg'] + "\r\n"
    else
      body["words_result"].each do |word|
        result += word["words"] + "\r\n"
      end
    end
    result
  end

  def prc_webimage(file_url)
    result = ''
    body = webimage(file_url)
    unless body['error_code'].nil?
      result += "error--------" + body['error_msg'] + "\r\n"
    else
      body["words_result"].each do |word|
        result += word["words"] + "\r\n"
      end
    end
    result
  end

  def prc_handwritten(file_url)
    result = ''
    body = handwritten(file_url)
    unless body['error_code'].nil?
      result += "error--------" + body['error_msg'] + "\r\n"
    else
      body["words_result"].each do |word|
        result += word["words"] + "\r\n"
      end
    end
    result
  end

  def prc_form(file_url)
    result = ''
    body = form(file_url)
    unless body['error_code'].nil?
      result += "error--------" + body['error_msg'] + "\r\n"
    else
      result = body["result"]["result_data"]
    end
    result
  end

  def prc_number(file_url)
    result = ''
    body = number(file_url)
    unless body['error_code'].nil?
      result += "error--------" + body['error_msg'] + "\r\n"
    else
      body["words_result"].each do |word|
        result += word["words"] + "\r\n"
      end
    end
    result
  end

  def prc_finance(file_url)
    result = ''
    body = finance(file_url)
    unless body['error_code'].nil?
      result += "error--------" + body['error_msg'] + "\r\n"
    else
      body["words_result"].each do |word|
        result += word["words"] + "\r\n"
      end
    end
    result
  end

  private
    def ocr_params
      params.require(:ocr).permit(:ocr_type, enclosures_attributes: enclosure_params)
    end
  
    def enclosure_params
      [:id, :file, :_destroy]
    end
  
    def general_basic(file)
      url = "https://aip.baidubce.com/rest/2.0/ocr/v1/general_basic"
      body = baidu_request(url, file)
      body
    end 

    def webimage(file)
      url = "https://aip.baidubce.com/rest/2.0/ocr/v1/webimage"
      body = baidu_request(url, file)
      body
    end 

    def form(file)
      url = "https://aip.baidubce.com/rest/2.0/solution/v1/form_ocr/request"
      body = baidu_form_request(url, file)
      body
    end 

    def handwritten(file)
      url = "https://aip.baidubce.com/rest/2.0/ocr/v1/handwriting"
      body = baidu_request(url, file)
      body
    end 

    def number(file)
      url = "https://aip.baidubce.com/rest/2.0/ocr/v1/numbers"
      body = baidu_request(url, file)
      body
    end 

    #-------unuse
    def finance(file)
      url = "https://aip.baidubce.com/rest/2.0/solution/v1/iocr/recognise/finance"
      body = baidu_request(url, file)
      body
    end 

    def formula(file)
      url = ""
      body = baidu_request(url, file)
      body
    end 

    def stamp(file)
      url = "https://aip.baidubce.com/rest/2.0/ocr/v1/seal"
      body = baidu_request(url, file)
      body
    end 
    #-------unuse

    def baidu_request(url, file)
      access_token = "24.036f01465c12cbcf3e18db99ba93981e.2592000.1584250576.282335-11449805"
      content_type = "application/x-www-form-urlencoded"
      img = open(file).read
      image = Base64.encode64(img)
      image.gsub!(/\s/, '')

      body = nil
      RestClient.post(url, {access_token: access_token, image: image}, {content_type: content_type}) do |response|
        body = JSON.parse(response.body)
      end

      body
    end
    

    def baidu_form_request(url, file)
      access_token = "24.036f01465c12cbcf3e18db99ba93981e.2592000.1584250576.282335-11449805"
      content_type = "application/x-www-form-urlencoded"
      img = open(file).read
      image = Base64.encode64(img)
      image.gsub!(/\s/, '')

      body = nil
      RestClient.post(url, {access_token: access_token, image: image, is_sync: 'true', request_type: 'excel'}, {content_type: content_type}) do |response|
        body = JSON.parse(response.body)
      end

      body
    end
end
