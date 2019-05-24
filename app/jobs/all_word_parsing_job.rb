require 'twitter-korean-text-ruby'

class AllWordParsingJob
  include Sidekiq::Worker
  sidekiq_options unique: :while_executing

  def perform
    processor = TwitterKorean::Processor.new

    word_dict = {}

    Suggestion.all.each do |suggestion|
      source = suggestion.title + ' ' + ActionView::Base.full_sanitizer.sanitize(suggestion.body)
      processor.tokenize(source).map do |token|
        next unless token.metadata.pos == :noun
        token.to_s
      end.compact.uniq.each do |word_text|
        word_dict[word_text] = (word_dict[word_text] || 0) + 1
      end
    end

    ActiveRecord::Base.transaction do
      Word.destroy_all
      word_dict.each do |word_text, count|
        Word.create(text: word_text, count: count)
      end
    end
  end
end

