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
  SUPPORTED_LANG_CODES = [
    'af', 'sq', 'am', 'ar', 'hy', 'az', 'eu', 'be', 'bn', 'bs', 'bg', 'ca',
    'ceb', 'ny', 'zh-CN', 'zh-TW', 'co', 'hr', 'cs', 'da', 'nl', 'en', 'eo',
    'et', 'fil', 'fi', 'fr', 'fy', 'gl', 'ka', 'de', 'el', 'gu', 'ht', 'ha',
    'haw', 'iw', 'he', 'hi', 'hmn', 'hu', 'is', 'ig', 'id', 'ga', 'it', 'ja',
    'jw', 'kn', 'kk', 'km', 'rw', 'ko', 'ku', 'ky', 'lo', 'la', 'lv', 'lt',
    'lb', 'mk', 'mg', 'ms', 'ml', 'mt', 'mi', 'mr', 'mn', 'my', 'ne', 'no',
    'or', 'ps', 'fa', 'pl', 'pt', 'pt-PT', 'pa', 'ro', 'ru', 'sm', 'gd',
    'sr', 'st', 'sn', 'sd', 'si', 'sk', 'sl', 'so', 'es', 'su', 'sw', 'sv',
    'tg', 'ta', 'tt', 'te', 'th', 'tr', 'tk', 'uk', 'ur', 'ug', 'uz', 'vi',
    'cy', 'xh', 'yi', 'yo', 'zu'
  ]

  # Public: Translate text using Google's HTTPS endpoint.
  #
  # text - String containing the source text.
  # to   - Language code for the target language (see SUPPORTED_LANG_CODES).
  # from - Optional source language code. Provide an empty string to let Google auto-detect.
  #
  # Returns the translated String or nil if Google returns an empty result.
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

  # Public: Convenience helper to translate from an unknown language to English.
  #
  # Equivalent to translate(text, "en", "") which triggers auto language detection.
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
