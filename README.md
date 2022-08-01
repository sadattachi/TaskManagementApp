# Task Management API

### Ruby Version 2.7.4
To install ruby run:
```
rvm install "ruby-2.7.4"
```

### Gem Installation
Install all necessary gems by running:
```
bundle install
```

### Database Setup
For this API to work you need to create postgres user:
```
psql -d postgres -c "CREATE ROLE task_management_app WITH CREATEDB LOGIN PASSWORD 'tmajira';"
```
After creating user run:
```
rails db:setup --trace
```
To initialize database with basic data from `db/seeds.rb` you may want to run:
```
rails db:seed
```

### Unit tests
API has unit tests. To run this tests:
```
rspec
```

### Requests examples

#### Registration
```
Method: POST
URL: http://127.0.0.1:3000/users
Example data:
{
    "user": {
        "email": "testreg@gmail.com",
        "password": "password",
        "is_admin": "false"},

    "worker": {
        "last_name": "test", 
        "first_name": "test", 
        "age": "20", 
        "role": "Developer", 
        "active": "false"}
}
```

#### Sign in
```
Method: POST
URL: http://127.0.0.1:3000/users/sign_in
Example data:
{
    "user": {
        "email": "new@gmail.com",
        "password": "password"}
}
```