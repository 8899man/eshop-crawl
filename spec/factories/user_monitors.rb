# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_monitor do
    user nil
    wine_monitor nil
    warn_price ""
  end
end
