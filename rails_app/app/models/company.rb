class Company < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :name, presence: true
  validates :number, presence: true

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :id, type: "long", index: false
      indexes :name, type: "text" do
        indexes :suggest, type: 'completion', analyzer: 'simple', search_analyzer: 'simple'
      end
    end
  end

  def self.suggest query
    __elasticsearch__.client.search(index: index_name, body: {
      suggest: {
        companies: {
          prefix: query,
          completion: {
            field: "name.suggest",
            fuzzy: {
              fuzziness: 'AUTO'
            }
          }
        }
      },
      _source: ['id', 'name']
    })
  end

  def as_indexed_json(options = {})
    {
      id: id,
      name: suggestion_names
    }
  end

  private

  def suggestion_names
    result = []
    [name, previous_name_1_company_name, previous_name_2_company_name,
    previous_name_3_company_name, previous_name_4_company_name, previous_name_5_company_name,
    previous_name_6_company_name, previous_name_7_company_name, previous_name_8_company_name,
    previous_name_9_company_name, previous_name_10_company_name].compact.each do |names|
      # in case user starts typing with a word from the middle,
      # i.e. "bar" in the example bellow
      # "foo (bar) test" => ["foo bar test", "bar test", "test"]
      words = self.name.gsub(/(\(|\))/, '').split(' ')
      for i in 0..(words.size - 1)
        result << words[i..-1].join(' ')
      end
    end
    result.uniq
  end
end
