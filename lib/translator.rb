require 'net/http'
require 'json'

class UnSupportedLanguage < RuntimeError
  attr :msg
  def initialize(message='')
    @msg = "Language pair not supported yet."
  end
end

class Translator

  Site_Url = 'ajax.googleapis.com'
  Request_Uri = "/ajax/services/language/translate"
  SUPPORTED_LANG_CODES = ['sr','lt','lv','iw','cy','ga','id','de','zh-TW','es','sl','ko','it','eu','az','af','sk','pt-PT','no','gl','bg','ar','tr','fa','mk','el','da','yi','ur','uk','ro','ja','zh','sw','mt','ms','is','ka','en','hr','ca','th','ru','hy','vi','tl','sv','hu','hi','fi','sq','pl','fr','et','nl','cs','zh-CN','be']

  # method to translate from one language to another
  def translate( text, to, from='en' )
    
    begin
      raise UnSupportedLanguage unless SUPPORTED_LANG_CODES.include?(to)
      raise UnSupportedLanguage unless SUPPORTED_LANG_CODES.include?(from) unless from.empty? # letting to translate from unknown language
      
      http = Net::HTTP.new(Site_Url, 80)

      request = Net::HTTP::Post.new(Request_Uri)
      
      request.set_form_data({'v'=>1.0, 'langpair'=>"#{from}|#{to}", 'q'=>"#{text}"})

      response = http.request(request)
      
      json_response_body = JSON.parse( response.body )
        
      if json_response_body['responseStatus'] == 200
        json_response_body['responseData']['translatedText']
      else
        puts json_response_body['responseDetails']
        raise StandardError, response['responseDetails']
      end
    rescue UnSupportedLanguage
      raise UnSupportedLanguage.new
    rescue => err_msg
      puts "#{err_msg}"
    end
    
  end

  # added in 0.1.2 to support from unknown to english
  def to_en(text)
    translate( text, "en", "" )
  end

end
