module UnitsHelper
  def translation(word,lang)
    word = word.translations.detect {|t| t.lang == lang}
    word.try(:content) || ""
  end
end
