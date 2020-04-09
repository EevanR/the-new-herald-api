# The New Herald API

The New Herald is a second iteration of a previous project 'The Reactive Herald', made to function as a online news room. Users can browse short snippets of articles for free or can pay for a subscription to see full articles. Journalists can log on to create their articles and attach an image, which is stored on amazon web services. An article is not publically displayed until it is published by a publisher. Articles are grouped by category and the application's displayed language can be switched between swedish and english if the visitor/user desires.

## Deployed Site

## Dependencies
- Ruby 2.5.1
- Rails 6.0.2
- will_paginate 3.1.0
- devise_token_auth
- pundit
- stripe-rails
- globalize

## To run locally
#### Clone repository
```
$ git clone https://github.com/EevanR/the-new-herald-api.git
$ cd the-new-herald-api
```

#### Install dependencies
Install Rspec and dependencies
```
$ bundle
```

## Run testing frameworks
In console:
Run Rspec 
```
$ rspec
```

## Actions available to the user

Head to the deployed address listed above, or your local host with frontend running, and have a look around.

Log in as various roles on deployed site to check functionality;

#### To review and publish articles
visit: https://the-reactive-herald-ca.netlify.com/admin  

Publisher:  
email: pub@mail.com  
pass: password

#### To view full articles as subscriber
Subscriber:  
email: sub@mail.com  
pass: password

#### To write and submit articles as journalist
Journalist:  
email: journo@mail.com  
pass: password

Or register your own account.

## Updates/Improvement plans
- Make serverless through AWS Lamda
- Add featured column to articles db

## License
Created under the <a href="https://en.wikipedia.org/wiki/MIT_License">MIT License</a>.