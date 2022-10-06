class Movie < ActiveRecord::Base
	# A list of all of the ratings that we have
	def self.get_all_ratings()
		return ['G', 'PG', 'PG-13', 'R']
	end

	# Which ratings the user has chosen for a filter
	def self.ratings_to_show(chosen_ratings)
		if chosen_ratings == nil
			return self.get_all_ratings
		end
		return chosen_ratings.keys
	end

	# Find all of the movies with the ratings in RATINGS,
	# and return the list of them
	def self.with_ratings(ratings)
		movies = []
		ratings.each do |rate|
			movies += where("rating = '#{rate}'")
		end
		return movies
	end

	def self.sort_movies_title(ratings)
		if ratings == nil
			return Movie.order(:title)
		end
		movies = []
		ratings.keys.each do |rate|
			movies += where("rating = '#{rate}'").order(:title)
		end
		return movies
	end

	def self.sort_movies_release_date(ratings)
		if ratings == nil
			return Movie.order(:release_date)
		end
		ordered = Movie.order(:release_date)
		movies = []
		ratings.keys.each do |rate|
			movies += where("rating = '#{rate}'").order(:release_date)
		end
		return movies.sort_by {|movie| movie.release_date} 
	end
end
