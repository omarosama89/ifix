# README

This app is a road side assistant which enables customers to request an assistance from providers
registered in the system

## Workflow

- Provider register to the system choosing the services they can provide
- Customer register to the system
- Customer request a provider based on the service he needs and the location
- Provider respond to request and drive to customer
- Provider fixes the issue

## Work done

- Provider can register/login
- Customer can register/login
- Customer lists the providers available in area with the desired services
- Customer creates request
- Provider process request

## How to run the app

- Install `ruby` version `2.6.5`
- Install `bundler` version `2.4.0`
- Install postgres database version `14.8`
- Run `bundle install`
- Run `rake db:create` then `rake db:migrate`
- Run `rake db:seed` to create an admin user
- Run `rails s`

Congrats, the app is running

## Documentation

### V1 (outdated)
In this version, we used our own authentication process, all APIs endpoints are documented using swagger,
you can see the full documentation by visiting this path `/api-docs`

### V2
In this version we used `devise` gem for authentication, all APIs endpoint were documented using `postman`,
you can see the full documentation stored in `postman_collection.json`

## Test

### V1 (outdated)

The app is fully covered with test cases (unit test and controller test), this is in `spec` directory

Running `rspec` should run all the tests but most of them are going to fail because they're outdated

### V2

Unfortunately, this is not covered by tests

