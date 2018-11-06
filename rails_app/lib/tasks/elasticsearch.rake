namespace :elasticsearch do
  desc "Importing companies from DB to elasticsearch"
  task import_companies: :environment do
    Company.import(force: true, batch_size: 5000)
  end
end
