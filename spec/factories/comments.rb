FactoryBot.define do
  factory :comment do
    body { "This is the body of the comment" }
    article_id { 1 }
    user_id { 1 }
    email { "commenter@mail.com" }
    role { "subscriber" }
    association :user
    association :article
  end
end
