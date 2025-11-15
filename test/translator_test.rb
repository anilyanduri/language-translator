require_relative 'test_helper'
class TranslatorTest < Test::Unit::TestCase
  def setup
    @translator = Translator.new
  end

  def test_translate_from_english_to_other
    expect_translation_request("Hello world", from: "en", to: "fr", translated_text: "Bonjour le monde")
    assert_equal("Bonjour le monde", @translator.translate("Hello world", "fr", "en"))
  end

  def test_translate_from_other_to_english
    expect_translation_request("こんにちは世界", from: "ja", to: "en", translated_text: "Hello world")
    assert_equal("Hello world", @translator.translate("こんにちは世界", "en", "ja"))
  end

  def test_translate_to_english_from_unknown_language
    expect_translation_request("¡Hola, mundo!", from: "", to: "en", translated_text: "Hello world")
    assert_equal("Hello world", @translator.to_en("¡Hola, mundo!"))
  end

  def test_unsupported_translate
    assert_raise UnSupportedLanguage do
      @translator.translate("你好世界", 'zh', 'hz')
    end
  end

  def test_api_failure_returns_nil
    expect_failed_translation_request("Hello world", from: "en", to: "de")
    assert_nil(@translator.translate("Hello world", "de", "en"))
  end

  private

  def expect_translation_request(text, from:, to:, translated_text:)
    response = stub(:code => '200', :body => build_google_response(text, translated_text))
    Net::HTTP.expects(:get_response).with { |uri| uri_matches?(uri, text, from, to) }.returns(response)
  end

  def expect_failed_translation_request(text, from:, to:)
    response = stub(:code => '500', :body => 'Internal Server Error')
    Net::HTTP.expects(:get_response).with { |uri| uri_matches?(uri, text, from, to) }.returns(response)
  end

  def build_google_response(original_text, translated_text)
    [[[translated_text, original_text, nil, nil, 1]]].to_json
  end

  def uri_matches?(uri, text, from, to)
    params = URI.decode_www_form(uri.query).to_h
    source_language = from.empty? ? 'auto' : from

    uri.host == Translator::Site_Url &&
      uri.path == Translator::Request_Uri &&
      params['client'] == 'gtx' &&
      params['dt'] == 't' &&
      params['q'] == text &&
      params['sl'] == source_language &&
      params['tl'] == to
  end
end
