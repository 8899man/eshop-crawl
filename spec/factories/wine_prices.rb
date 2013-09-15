# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wine_price do
    wine nil
    website nil
    url "MyString"
    current_price ""
    tag_price ""
    started_at "2013-09-15 12:39:14"
    finished_at "2013-09-15 12:39:14"
  end
end
