FactoryBot.define do
  factory :article do
    title_en { "Breaking News" }
    body_en { "Some long breaking content" * 20 }
    title_sv { "Brytande nyheter" }
    body_sv { "Långt brytande innehåll. " *20}
    likes { ["user@mail.com"] }
    association :journalist
    
    after(:create) do |article|
      article.image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'ca_basic_logo_320x40.png')),
      filename: 'attachment.png',
      content_type: 'image/png')
    end
  end
end