# original version autogenerated by Stepford: https://github.com/garysweaver/stepford

FactoryGirl.define do

  factory :accident do
    sequence(:id)
    date { 2.weeks.ago }
    time { 2.weeks.ago }
    severity 123
    police_response 123
    casualities 123
    lat 1.23
    long 1.23
  end

  factory :attraction do
    sequence(:id)
    type 123
    lat 1.23
    long 1.23
    name 'Test Name'
    description 'Test Description'
    contact_tel 'Test Contact Tel'
    address1 'Test Address1'
    address2 'Test Address2'
    town 'Test Town'
    postcode 'Test Postcode'
  end

  factory :events do
    sequence(:id)
    type 123
    attraction_id 123
    name 'Test Name'
    description 'Test Description'
    start_time { 2.weeks.ago }
    end_time { 2.weeks.ago }
    road_closure_details 'Test Road Closure Details'
  end

  sequence(:lat) {|n| @random_lats ||= (1..90).to_a.shuffle; @random_lats[n] }
  sequence(:long) {|n| @random_longs ||= (1..180).to_a.shuffle; @random_longs[n] }
  factory :route do
    # after(:create) do |user, evaluator|; FactoryGirl.create_list :route, 2; end # commented to avoid circular reference
    # after(:create) do |user, evaluator|; FactoryGirl.create_list :route_point, 5; end
    # after(:create) do |user, evaluator|; FactoryGirl.create_list :route_review, 2; end # commented to avoid circular reference
    # association :original, factory: :route
    user
    sequence(:id)
    name 'Test Name'
    lat 1.23
    long 1.23
    start_maidenhead 'AA00bb11'
    end_maidenhead 'AA00bb11'
    mode 1
    start_time { 2.weeks.ago }
    end_time { 2.weeks.ago }
    total_time 123
  end

  factory :route_point do
    sequence(:id)
    lat { FactoryGirl.generate(:lat) }
    long { FactoryGirl.generate(:long) }
    altitude 1.23
    on_road true
    street_name 'Test Street Name'
    time { 2.weeks.ago }
    kph 12.34
  end

  factory :route_review do
    route
    user
    sequence(:id)
    comment 'Test Comment'
    rating 2
  end

  factory :user do
    # after(:create) do |user, evaluator|; FactoryGirl.create_list :route, 2; end # commented to avoid circular reference
    # after(:create) do |user, evaluator|; FactoryGirl.create_list :route_review, 2; end # commented to avoid circular reference
    sequence(:id)
    sequence(:email) do |n|; "person#{n}@example.com"; end
    password 'blasfasf'
    encrypted_password 'sadjasdasjkdaksldjaslkdjaslkdajslaksd'
    sequence(:reset_password_token)
    reset_password_sent_at { 2.weeks.ago }
    remember_created_at { 2.weeks.ago }
    sign_in_count 0
    current_sign_in_at { 2.weeks.ago }
    last_sign_in_at { 2.weeks.ago }
    current_sign_in_ip 'Test Current Sign In Ip'
    last_sign_in_ip 'Test Last Sign In Ip'
    sequence(:username) do |n|; "testuser#{n}"; end
    profile_pic { fixture_file_upload(Rails.root.join('public', 'images', 'medium', 'default_profile_pic.png'), 'image/png') }
    gender "male"
    year_of_birth 1990
  end

  factory :user_response do
    sequence(:id)
    user_id 123
    usage_per_week 123
    usage_type 123
    usage_reason 123
  end

  factory :weather do
    after(:create) do |user, evaluator|; FactoryGirl.create_list :weather_period, 2; end # commented to avoid circular reference
    sequence(:id)
    date { 2.weeks.ago }
    sunset { 2.weeks.ago }
    sunrise { 2.weeks.ago }
  end

  factory :weather_period do
    sequence(:id)
    start_time { 2.weeks.ago.beginning_of_hour }
    precipitation_type "rain"
    precipitation_intensity 123
    precipitation_probability 123
    wind_speed 123
    wind_bearing 123
    summary "It's wet"
    icon "rain"
    temperature 123
    dew_point 123
    humidity 123
    visibility 123
    cloud_cover 123
    pressure 123
    ozone 470.3
  end

end
