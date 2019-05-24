require 'roo'

namespace :data do
  desc "load suggestions"
  task 'load:suggestions', [:file_path] => :environment do |task, args|
    count = 0
    ActiveRecord::Base.transaction do
      now = DateTime.now
      xlsx = Roo::Spreadsheet.open(args.file_path)

      index_created_at = 0
      index_real_user_name = 1
      index_area_text = 2
      index_category_text = 3
      index_body = 4

      user = User.find_by(email: '100yearskorea@gmail.com')
      xlsx.sheet(0).each_row_streaming(offset: 1, pad_cells: true) do |row|
        created_at = row[index_created_at].try(:value)
        next if created_at.blank?

        real_user_name = row[index_real_user_name].try(:cell_value)
        area_text = row[index_area_text].try(:cell_value)
        category_text = row[index_category_text].try(:cell_value)
        body = row[index_body].try(:cell_value)

        area = Suggestion::AREA_DETAIL.find { |area| area_text.present? && (area[:name].gsub(/[^0-9A-Za-zㄱ-ㅎ가-힣]/, '') == area_text.gsub(/[^0-9A-Za-zㄱ-ㅎ가-힣]/, '')) }.try(:fetch, :code)
        if area.nil?
          raise "#{area_text} 지역은 인식할 수 없습니다"
        end

        category = (Suggestion::CATEGORY_CODE.find { |code, name| name == category_text } || []).first
        if category.nil?
          raise "#{category_text} 카테고리는 인식할 수 없습니다"
        end

        if body.nil?
          raise "내용이 없습니다"
        end
        title = body.truncate(255)

        Suggestion.create(
          user: user,
          real_user_name: real_user_name,
          area: area,
          category: category,
          title: title,
          body: body,
          created_at: created_at
        )

        print "."
      end

      puts '.'
    end
  end

  desc "워드크라우드 리셋"
  task "load:wordcloud" => :environment do
    require 'twitter-korean-text-ruby'

    processor = TwitterKorean::Processor.new

    word_dict = {}
    Suggestion.all.each do |suggestion|
      source = suggestion.title + ' ' + suggestion.body
      processor.tokenize(source).map do |token|
        next unless token.metadata.pos == :noun
        token.to_s
      end.compact.uniq.each do |word_text|
        word_dict[word_text] = (word_dict[word_text] || 0) + 1
      end
      print '.'
    end

    ActiveRecord::Base.transaction do
      Word.destroy_all
      word_dict.each do |word_text, count|
        Word.create(text: word_text, count: count)
      end
      print '.'
    end

    puts '.'
  end
end

