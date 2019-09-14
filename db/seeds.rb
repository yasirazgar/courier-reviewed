# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
password = 'PassworD@55'
admin1 = User.create(username: 'yasir', email: 'yasir@carriage.com', admin: true, password: password)
admin2 = User.create(username: 'azgar', email: 'azgar@carriage.com', admin: true, password: password)

courier1 = User.create(username: 'yash', email: 'yash@carriage.com', password: password)
courier2 = User.create(username: 'kamlesh', email: 'kamlesh@carriage.com', password: password)
courier3 = User.create(username: 'kabi', email: 'kabi@carriage.com', password: password)
courier4 = User.create(username: 'jhonny', email: 'jhonny@carriage.com', password: password)
courier5 = User.create(username: 'billie', email: 'billie@carriage.com', password: password)
courier6 = User.create(username: 'shafi', email: 'shafi@carriage.com', password: password)

restaurant1 = Restaurant.create(name: 'Carriage', creator: admin1)
restaurant2 = Restaurant.create(name: 'AAsife', creator: admin2)
restaurant3 = Restaurant.create(name: 'KFC', creator: admin1)

description = <<-DESC
This is a lengthy description can be review or just explaining something that was interesting or something that a
user would be like to know, more intreseting description, more length description, few  more length description,
few  more intreseting description, that's all folks.
DESC
post1 = Post.create(title: 'Very hygienic', description: (description << '1 description'), user: courier1, restaurant: restaurant1)
post2 = Post.create(title: 'Quick response', description: (description << '2 description'), user: courier2, restaurant: restaurant2)
post3 = Post.create(title: 'More staffs', description: (description << '3 description'), user: courier3, restaurant: restaurant3)
post4 = Post.create(title: 'Not hygienic', description: (description << '4 description'), user: courier4, restaurant: restaurant1)
post5 = Post.create(title: 'Staffs are less responsive', description: (description << '5 description'), user: courier5, restaurant: restaurant2)
post6 = Post.create(title: 'Food is less hot', description: (description << '6 description'), user: courier6, restaurant: restaurant3)
post7 = Post.create(title: 'Less space', description: (description << '7 description'), user: courier1, restaurant: restaurant1)
post8 = Post.create(title: 'Spacious', description: (description << '8 description'), user: courier2, restaurant: restaurant2)
post9 = Post.create(title: 'Parking issues', description: (description << '9 description'), user: courier3, restaurant: restaurant3)
post0 = Post.create(title: 'Good ambience', description: (description << '10 description'), user: admin1, restaurant: restaurant1)


comment11 = Comment.create(body: 'I agree', user: courier1, post: post1)
Reply.create(body: 'I too agree', user: courier2, comment: comment11)
Reply.create(body: '+1', user: courier1, comment: comment11)
Reply.create(body: ':)', user: courier3, comment: comment11)
comment12 = Comment.create(body: 'Less responsive when I visited', user: courier2, post: post1)
Reply.create(body: 'Responsive', user: courier2, comment: comment12)
Reply.create(body: 'Less', user: courier4, comment: comment12)
Reply.create(body: 'For me too', user: courier5, comment: comment12)

comment21 = Comment.create(body: 'p1 c1 body', user: courier3, post: post2)
Reply.create(body: 'reply 121', user: courier5, comment: comment21)
Reply.create(body: 'reply 121', user: courier6, comment: comment21)
Reply.create(body: 'reply 121', user: courier3, comment: comment21)
comment22 = Comment.create(body: 'p1 c2 body', user: courier4, post: post2)
Reply.create(body: 'reply 322', user: courier2, comment: comment22)
Reply.create(body: 'reply 322', user: courier4, comment: comment22)
Reply.create(body: 'reply 322', user: courier1, comment: comment22)

comment31 = Comment.create(body: 'p1 c1 body', user: courier5, post: post3)
Reply.create(body: 'reply 331', user: courier5, comment: comment31)
Reply.create(body: 'reply 331', user: courier1, comment: comment31)
Reply.create(body: 'reply 331', user: courier3, comment: comment31)
comment32 = Comment.create(body: 'p1 c2 body', user: courier6, post: post3)
Reply.create(body: 'reply 312', user: courier5, comment: comment32)
Reply.create(body: 'reply 312', user: courier1, comment: comment32)
Reply.create(body: 'reply 312', user: courier3, comment: comment32)

comment41 = Comment.create(body: 'p1 c1 body', user: courier1, post: post4)
Reply.create(body: 'comment41 reply 1', user: courier4, comment: comment41)
Reply.create(body: 'comment41 reply 2', user: courier1, comment: comment41)
Reply.create(body: 'comment41 reply 3', user: courier6, comment: comment41)
comment42 = Comment.create(body: 'p1 c2 body', user: courier2, post: post4)
Reply.create(body: 'comment42 reply 1', user: courier5, comment: comment42)
Reply.create(body: 'comment42 reply 2', user: courier2, comment: comment42)
Reply.create(body: 'comment42 reply 3', user: courier4, comment: comment42)

comment51 = Comment.create(body: 'p1 c1 body', user: courier3, post: post5)
Reply.create(body: 'comment51 reply 1', user: courier1, comment: comment51)
Reply.create(body: 'comment51 reply 2', user: courier2, comment: comment51)
Reply.create(body: 'comment51 reply 3', user: courier3, comment: comment51)
comment52 = Comment.create(body: 'p1 c2 body', user: courier4, post: post5)
Reply.create(body: 'comment52 reply 1', user: courier4, comment: comment52)
Reply.create(body: 'comment52 reply 2', user: courier5, comment: comment52)
Reply.create(body: 'comment52 reply 3', user: courier3, comment: comment52)

comment61 = Comment.create(body: 'p1 c1 body', user: courier5, post: post6)
Reply.create(body: 'comment61 reply', user: courier5, comment: comment61)
Reply.create(body: 'comment61 reply', user: courier1, comment: comment61)
Reply.create(body: 'comment61 reply', user: courier3, comment: comment61)
comment62 = Comment.create(body: 'p1 c2 body', user: courier6, post: post6)
Reply.create(body: 'reply for comment62', user: courier4, comment: comment62)
Reply.create(body: 'reply for comment62', user: courier1, comment: comment62)
Reply.create(body: 'reply for comment62', user: courier6, comment: comment62)

comment71 = Comment.create(body: 'p1 c1 body', user: admin1, post: post7)
Reply.create(body: 'reply comment42', user: admin1, comment: comment71)
Reply.create(body: 'reply comment42', user: admin2, comment: comment71)
Reply.create(body: 'reply comment42', user: courier6, comment: comment71)
comment72 = Comment.create(body: 'p1 c2 body', user: courier1, post: post7)
Reply.create(body: 'comment42 reply', user: courier2, comment: comment72)
Reply.create(body: 'comment42 reply', user: courier1, comment: comment72)
Reply.create(body: 'comment42 reply', user: courier3, comment: comment72)

comment81 = Comment.create(body: 'p1 c1 body', user: admin2, post: post8)
Reply.create(body: 'comment42 reply 1', user: courier4, comment: comment81)
Reply.create(body: 'comment42 reply 2', user: courier5, comment: comment81)
Reply.create(body: 'comment42 reply 3', user: admin1, comment: comment81)
comment82 = Comment.create(body: 'p1 c2 body', user: courier2, post: post8)
Reply.create(body: 'reply 1', user: courier4, comment: comment82)
Reply.create(body: 'reply 2', user: courier2, comment: comment82)
Reply.create(body: 'reply 3', user: courier6, comment: comment82)

comment91 = Comment.create(body: 'p1 c1 body', user: courier2, post: post9)
Reply.create(body: 'reply 1', user: courier2, comment: comment91)
Reply.create(body: 'reply 2', user: courier1, comment: comment91)
Reply.create(body: 'reply 3', user: courier3, comment: comment91)
comment92 = Comment.create(body: 'p1 c2 body', user: courier3, post: post9)
Reply.create(body: 'reply 1', user: courier4, comment: comment92)
Reply.create(body: 'reply 2', user: courier2, comment: comment92)
Reply.create(body: 'reply 3', user: courier3, comment: comment92)

comment01 = Comment.create(body: 'p1 c1 body', user: courier4, post: post0)
Reply.create(body: 'reply 1', user: courier5, comment: comment01)
Reply.create(body: 'reply 2', user: courier6, comment: comment01)
Reply.create(body: 'reply 3', user: courier3, comment: comment01)
comment02 = Comment.create(body: 'p1 c2 body', user: courier5, post: post0)
Reply.create(body: 'reply 1', user: courier5, comment: comment02)
Reply.create(body: 'reply 2', user: courier1, comment: comment02)
Reply.create(body: 'reply 3', user: courier6, comment: comment02)



