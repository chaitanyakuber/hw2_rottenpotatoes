class Movie < ActiveRecord::Base
	def self.ratings
		all_ratings = Array.new
		self.all.each{ |mov|
			all_ratings << mov.rating
		}
		return all_ratings.uniq.sort
	end

	def self.filter_on_ratings(ratings)
    	where(rating: ratings)
	end

end
