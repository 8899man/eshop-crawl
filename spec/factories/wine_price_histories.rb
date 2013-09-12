# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wine_price_history do
    wine nil
    website nil
    url "MyString"
    current_price ""
    tag_price ""
  end
end
