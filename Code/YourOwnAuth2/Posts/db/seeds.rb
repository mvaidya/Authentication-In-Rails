# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


system_user = User.create({
     name: 'Admin',
     email: 'Admin@posts.com',
     password: 'password',
     password_confirmation: 'password'
    })

posts = Post.create([
    {
        user_id: system_user.id,
        title: 'Ruby on Rails',
        description: 'Ruby on Rails is an open-source web framework that is optimized for programmer happiness and sustainable productivity. It lets you write beautiful code by favoring convention over configuration'
    },
    {
        user_id: system_user.id,
        title: 'Ruby on Rails Tutorial',
        description: 'Welcome to the Ruby on Rails Tutorial. The goal of this book is to be the best answer to the question, "If I want to learn web development with Ruby on Rails, where should I start?" By the time you finish the Ruby on Rails Tutorial, you will have all the skills you need to develop and deploy your own custom web applications with Rails. You will also be ready to benefit from the many more advanced books, blogs, and screencasts that are part of the thriving Rails educational ecosystem. Finally, since the Ruby on Rails Tutorial uses Rails 3, the knowledge you gain here represents the state of the art in web development. (The most up-to-date version of the Ruby on Rails Tutorial can be found on the book\'s website at http://railstutorial.org/; if you are reading this book offline, be sure to check the online version of the Rails Tutorial book at http://railstutorial.org/book for the latest updates.)'
    },
    {
        user_id: system_user.id,
        title: 'Rails Casts',
        description: 'Every week Ryan Bates will host a new RailsCasts episode featuring tips and tricks with Ruby on Rails. These screen-casts are short and focus on one technique so you can quickly move on to applying it to your own project. The topics target the intermediate Rails developer, but beginners and experts will get something out of it as well.'
    }
])
