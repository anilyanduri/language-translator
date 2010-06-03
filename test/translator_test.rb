require File.dirname(__FILE__) + '/test_helper'
class TranslatorTest < Test::Unit::TestCase
  
   def test_translate_from_english_to_other
    tr = Translator.new()
    assert_equal("नमस्ते दुनिया", tr.translate("Hello world", "hi", "en"))
    assert_equal("Bonjour tout le monde", tr.translate("Hello world", "fr", "en"))
    assert_equal("Hallo Welt", tr.translate("Hello world", "de", "en"))
    assert_equal("Ciao a tutti", tr.translate("Hello world", "it", "en"))
    assert_equal("こんにちは、世界", tr.translate("Hello world", "ja", "en"))
    assert_equal("Dia duit domhan", tr.translate("Hello world", "ga", "en"))
    assert_equal("Olá mundo", tr.translate("Hello world", "pt-PT", "en"))
    assert_equal("Привет мир", tr.translate("Hello world", "ru", "en"))
    assert_equal("¡Hola, mundo", tr.translate("Hello world", "es", "en"))
    assert_equal("مرحبا العالم", tr.translate("Hello world", "ar", "en"))
  end
  
  def test_translate_from_other_to_english
    tr = Translator.new()
    assert_equal("Hello World", tr.translate("नमस्ते दुनिया", "en","hi"))
    assert_equal("Hello world", tr.translate("世界您好", "en", "zh-CN"))
    assert_equal("Hello world", tr.translate("Dia duit domhan", "en", "ga"))
    assert_equal("Hello world", tr.translate("こんにちは、世界", "en", "ja"))
    assert_equal("Hello world", tr.translate("안녕하세요 세상", "en", "ko"))
    assert_equal("Hello world", tr.translate("Olá mundo", "en", "pt-PT"))
    assert_equal("Hello world", tr.translate("Привет мир", "en", "ru"))
    assert_equal("Hello world", tr.translate("¡Hola, mundo", "en", "es"))
    assert_equal("Hello world", tr.translate("مرحبا العالم", "en", "ar"))
  end

  def test_unsupported_translate
    assert_raise UnSupportedLanguage do
      tr = Translator.new()
      tr.translate("你好世界", 'zh', 'hz')
    end
  end
  
end

