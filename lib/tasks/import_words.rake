namespace :arek_tools do 
  desc "Import words from mysql japan_latin2 database"  
  task :import_words, [:unit] => :environment do |t,args| 
    require 'rubygems'
    require 'sequel'
    require 'logger'
    
    unit = args[:unit]
    
    JDB=Sequel.connect('mysql://arek:ryzztruskawkami@localhost/japan_latin2')
    JDB.loggers << Logger.new($stdout)
    
    m_unit = Unit.first(:name => "MNN37#{unit}") || Unit.new(:name => "MNN37#{unit}") 
    
    words = JDB[:words].where(:unit => unit)
    words.count
    words.each do |w|
      unless w[:kanji_katakana].empty?
        new_content = w[:kanji_katakana]
      else
        new_content = w[:hiragana]
      end
  
      if !Word.first(:content => new_content)
        translation = Translation.new :content => w[:english], :lang => 'english'
        word = Word.new :lang => 'japanese', :unit => m_unit, :content => new_content, :translations => [translation]
        puts "Importing :#{new_content}:"
        word.save
      else
        puts "Word #{new_content} already in database... trying next"
      end
    end
  end  
end
