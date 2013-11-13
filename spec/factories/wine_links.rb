# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wine_link do
    url "MyString"
    user nil
    warn_price ""
  end
end
