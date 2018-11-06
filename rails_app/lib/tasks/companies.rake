require 'csv'

namespace :companies do
  desc "Importing companies to DB and elasticsearch"
  task :import, [:csv_src] => :environment do |t, args|
    CSV.foreach(args[:csv_src]) do |row|
      puts "Processing company - #{row[0]}"
      Company.find_or_create_by(number: row[1]) do |company|
        company.name = row[0]
        company.previous_name_1_company_name = row[2]
        company.previous_name_2_company_name = row[3]
        company.previous_name_3_company_name = row[4]
        company.previous_name_4_company_name = row[5]
        company.previous_name_5_company_name = row[6]
        company.previous_name_6_company_name = row[7]
        company.previous_name_7_company_name = row[8]
        company.previous_name_8_company_name = row[9]
        company.previous_name_9_company_name = row[10]
        company.previous_name_10_company_name = row[11]
      end
    end
  end
end
