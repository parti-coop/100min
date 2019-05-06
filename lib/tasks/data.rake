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

        area = Suggestion::AREA_DETAIL.find { |area| area[:name] == area_text }.try(:fetch, :code)
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
end
