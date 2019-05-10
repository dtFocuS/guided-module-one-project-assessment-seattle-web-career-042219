Module One Final Project

========================

#Crypto Investment Game

![menu](lib/img/bestsize.png)



This app is a Ruby driven CLI program that let's you choose 1 of the top 3 crypto-currencies Bitcoin, Ethereum, and Litecoin


Based off of your choice the app will show you the chosen cryptos 2017 trends that are available at [Coin Gecko](https://www.coingecko.com/en/api#explore-api)based on a beginning of the month query into the API.


The trends are meant to help the user decide whether they want to invest in 2018. Did you make the right decision to invest? Let's find out.


All content published by Coin Gecko is the property of Coin Gecko and is protected by copyright, trademark, and other intellectual property laws.


## Installation

Make sure you have the Ruby language installed

Fork the repository from https://github.com/dtFocuS/guided-module-one-project-assessment-seattle-web-career-042219

Clone the repository with git clone https://github.com/dtFocuS/guided-module-one-project-assessment-seattle-web-career-042219

Navigate to the folder with cd guided-module-one-project-assessment-seattle-web-career-042219

Run the initial setup

```
ruby setup.rb
```

Run bundle install

```
bundle install
```

Create the required tables

```
rake db:migrate
```

Seed the data into those tables

```
rake db:seed
```

Run the program

```
ruby bin/run.rb
```



Now were ready to play the game.


## Usage

Once the app has launched you will need to follow the prompts on the screen to complete the game. All you will need is your arrow keys, the keywords yes or no, and the enter key. Pretty simple!!!

## Demo

You can see a video demo of our program at the directory below

demo/mod1_project_demo.mov

## Credits
A project by [Alex Borst](https://github.com/ButlerBorst) and [Danny Tseng](https://github.com/dtFocuS)

Welcome Page and In app image: https://pngtree.com/freepng/businessman-with-bitcoin-and-cellphone_3549862.html

Gems Used:
 * source "https://rubygems.org"

 * gem "sinatra-activerecord"
 * gem "sqlite3"
 * gem "pry"
 * gem "require_all"
 * gem "faker"
 * gem "rest-client"
 * gem "json"
 * gem "rake"
 * gem "tty"
 * gem "date"
 * gem "tco"
 * gem "colorize"
 * gem "htmlentities"
 * gem "terminal-table"
 * gem "artii"
 * gem "word_wrap"


 * group :imagemagick
 * gem 'catpix'
