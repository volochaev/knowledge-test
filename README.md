# RoR knowledge test (umbrellio)
Description:
Create API for "some" blog.

Endpoints:
1. Post creation
2. Post rating update (foresee any race-conditions)
3. Get `n` most popular posts by average rating
4. Get array of ip addresses with usernames

Dataset: > 200k of posts, > 100 authors, > 50 ips
Desired performance: response in less than 100ms on all endpoints

Use latest versions of Ruby, RoR as possible.

Notes:
- Код был написан за несколько часов, есть странные названия методов и переменных (заниматься рефакторингом не вижу смысла)
- таблица Rating и ее поля обеспечивают легкий переход на другую систему оценки (например, Wilson score interval)
- Старался показать больше знаний по конкретным областям, а не гнался за красивым кодом (отчасти)

## Performance

## Configuration
* Database creation

  `$ rake db:create`

* Database initialization

  To populate data in DB run Rails server and `$ rake db:seed` (Task uses real application endpoint).

* How to run the test suite

  `$ rspec`

* Services (job queues, cache servers, search engines, etc.)

  No additional services required

### Deployment instructions
Not intended to be deployed  ;)
