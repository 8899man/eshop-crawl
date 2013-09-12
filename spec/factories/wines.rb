# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wine do
    name "MyString"
    introduction "MyString"
    description "MyString"
    min_price ""
    current_price ""
    min_starting_price ""
    max_starting_price ""
  end
end
