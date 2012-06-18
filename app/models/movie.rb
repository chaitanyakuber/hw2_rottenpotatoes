class Movie < ActiveRecord::Base
	ALL_RATINGS = ["G", "PG", "PG-13", "R"]

	def self.ratings
		return ALL_RATINGS
	end

	def self.filter_on_ratings(ratings)
    	where(rating: ratings)
	end

end
