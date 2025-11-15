require 'net/http'
require 'json'
require 'uri'

class UnSupportedLanguage < RuntimeError
  attr :msg
  def initialize(message='')
    @msg = "Language pair not supported yet."
  end
end

class Translator

  Site_Url = 'translate.googleapis.com'
  Request_Uri = "/translate_a/single"
  SUPPORTED_LANG_CODES = ['sr','lt','lv','iw','cy','ga','id','de','zh-TW','es','sl','ko','it','eu','az','af','sk','pt-PT','no','gl','bg','ar','tr','fa','mk','el','da','yi','ur','uk','ro','ja','zh','sw','mt','ms','is','ka','en','hr','ca','th','ru','hy','vi','tl','sv','hu','hi','fi','sq','pl','fr','et','nl','cs','zh-CN','be']

  # method to translate from one language to another
  def translate(text, to, from='en')
    begin
      raise UnSupportedLanguage unless SUPPORTED_LANG_CODES.include?(to)
      raise UnSupportedLanguage unless SUPPORTED_LANG_CODES.include?(from) unless from.empty? # letting to translate from unknown language

      response = Net::HTTP.get_response(request_uri(text, to, from))
      raise StandardError, "Translation API responded with #{response.code}" unless response.code.to_i == 200

      parse_translation_response(response.body)
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

  private

  def request_uri(text, to, from)
    query_params = {
      'client' => 'gtx',
      'dt' => 't',
      'sl' => from.to_s.empty? ? 'auto' : from,
      'tl' => to,
      'q' => text
    }

    URI::HTTPS.build(
      host: Site_Url,
      path: Request_Uri,
      query: URI.encode_www_form(query_params)
    )
  end

  def parse_translation_response(body)
    json_response_body = JSON.parse(body)
    translations = json_response_body[0]
    raise StandardError, "Translation API returned unexpected payload" unless translations.is_a?(Array)

    translated_text = translations.map { |segment| segment[0] }.join
    translated_text.empty? ? nil : translated_text
  rescue JSON::ParserError => e
    raise StandardError, "Translation API returned invalid JSON: #{e.message}"
  end

end
