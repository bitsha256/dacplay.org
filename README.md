BitShares Play
===============================

[http://playshare.io](http://playshare.io)

The repo is for building of playshare.io.  It's not designed to be used by third party.  It's only a part of our internal development process.

Dependency
-----------

Install npm node package manager

    curl -L https://npmjs.org/install.sh | sh

Install nodejs, coffee-script and other dependencies

    npm install

Ruby 1.9.3 or above (you can use rvm to install ruby)

    \curl -sSL https://get.rvm.io | bash -s stable --ruby=2.1.1

Dependent gems can be installed through bundle

    bundle install

Modify Files
---------------

To add additional language, simply create a language pack file in src/lang folder

    touch src/lang/zh-CN.yml

Each page will have one template file, edit them in folder

    src/template

Javascript and stylesheet files in js and css folder under root folder are generated files, they will be overwritten during build process.  To modify them, please edit files in

    src/js/*.js
    src/css/*.css

Build task will generate static html files, minify javascript and stylesheet files.  To invoke build task, run

    ./build.rb

