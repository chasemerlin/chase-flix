# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

comedy = Category.create(name: "Comedy")
drama = Category.create(name: "Drama")

family_guy = Video.create(title: 'Family Guy', description: 'Family Guy is an American adult animated sitcom created by Seth MacFarlane for the Fox Broadcasting Company.', small_cover_url: '/tmp/family_guy.jpg', large_cover_url: '/tmp/monk_large.jpg')
futurama = Video.create(title: 'Futurama', description: 'Futurama is an animated science fiction sitcom created by Matt Groening and developed by Groening and David X. Cohen for the Fox Broadcasting Company', small_cover_url: '/tmp/futurama.jpg', large_cover_url: '/tmp/monk_large.jpg')
monk = Video.create(title: 'Monk', description: 'Monk is an American comedy-drama detective mystery television series created by Andy Breckman and starring Tony Shalhoub as the eponymous character, Adrian Monk.', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg')
south_park = Video.create(title: 'South Park', description: 'South Park is an American adult animated sitcom created by Trey Parker and Matt Stone for the Comedy Central television network.', small_cover_url: '/tmp/south_park.jpg', large_cover_url: '/tmp/monk_large.jpg')

family_guy_two = Video.create(title: 'Family Guy', description: 'Family Guy is an American adult animated sitcom created by Seth MacFarlane for the Fox Broadcasting Company.', small_cover_url: '/tmp/family_guy.jpg', large_cover_url: '/tmp/monk_large.jpg')
futurama_two = Video.create(title: 'Futurama', description: 'Futurama is an animated science fiction sitcom created by Matt Groening and developed by Groening and David X. Cohen for the Fox Broadcasting Company', small_cover_url: '/tmp/futurama.jpg', large_cover_url: '/tmp/monk_large.jpg')
monk_two = Video.create(title: 'Monk', description: 'Monk is an American comedy-drama detective mystery television series created by Andy Breckman and starring Tony Shalhoub as the eponymous character, Adrian Monk.', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg')
south_park_two = Video.create(title: 'South Park', description: 'South Park is an American adult animated sitcom created by Trey Parker and Matt Stone for the Comedy Central television network.', small_cover_url: '/tmp/south_park.jpg', large_cover_url: '/tmp/monk_large.jpg')

family_guy_three = Video.create(title: 'Family Guy', description: 'Family Guy is an American adult animated sitcom created by Seth MacFarlane for the Fox Broadcasting Company.', small_cover_url: '/tmp/family_guy.jpg', large_cover_url: '/tmp/monk_large.jpg')

VideoCategory.create(category_id: comedy.id, video_id: family_guy.id)
VideoCategory.create(category_id: comedy.id, video_id: futurama.id)
VideoCategory.create(category_id: comedy.id, video_id: south_park.id)
VideoCategory.create(category_id: drama.id, video_id: monk.id)

VideoCategory.create(category_id: comedy.id, video_id: family_guy_two.id)
VideoCategory.create(category_id: comedy.id, video_id: futurama_two.id)
VideoCategory.create(category_id: comedy.id, video_id: south_park_two.id)
VideoCategory.create(category_id: drama.id, video_id: monk_two.id)

VideoCategory.create(category_id: comedy.id, video_id: family_guy_three.id)
