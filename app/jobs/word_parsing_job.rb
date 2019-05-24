require 'twitter-korean-text-ruby'

class WordParsingJob
  include Sidekiq::Worker
  sidekiq_options unique: :while_executing

  def perform(id)
    suggestion = Suggestion.find_by(id: id)
    return unless suggestion.present?

    processor = TwitterKorean::Processor.new

    word_dict = {}

    source = suggestion.title + ' ' + ActionView::Base.full_sanitizer.sanitize(suggestion.body || '')
    processor.tokenize(source).map do |token|
      next unless token.metadata.pos == :noun
      token.to_s
    end.compact.uniq.each do |word_text|
      word_dict[word_text] = (word_dict[word_text] || 0) + 1
    end

    ActiveRecord::Base.transaction do
      word_dict.each do |word_text, count|
        word = Word.find_or_initialize_by(text: word_text)
        word.count += count
        word.save
      end
    end
  end
end
