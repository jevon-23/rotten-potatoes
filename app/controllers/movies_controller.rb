class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index

      print "params: #{params}"
      if params[:ratings] == nil && params[:sort_ratings] == nil 
	      # If we are coming back ot index from another page,
	      # grab cookies
      	       chosen_ratings = session[:chosen_ratings] 
      	       is_sort = session[:is_sort] 
      	       is_sort_ratings = session[:is_sort_ratings] 
      else
      	       # Get the values being submitted from the form
      	       chosen_ratings = params[:ratings]
      	       is_sort = params[:sort]
      	       is_sort_ratings = params[:sort_ratings]
      end

      # Begin to set up variables to be sent to the view
      @all_ratings = Movie.get_all_ratings()
      if is_sort == 'title'
	      @ratings_to_show = Movie.ratings_to_show(is_sort_ratings)
	      @movies = Movie.sort_movies_title(is_sort_ratings)
      elsif is_sort == 'release'
	      @ratings_to_show = Movie.ratings_to_show(is_sort_ratings)
	      @movies = Movie.sort_movies_release_date(is_sort_ratings)
      else
      	      @ratings_to_show = Movie.ratings_to_show(chosen_ratings)
      	      @movies = Movie.with_ratings(@ratings_to_show)
      end

      # Set the cookies
      session[:chosen_ratings] = chosen_ratings
      session[:is_sort] = is_sort
      session[:is_sort_ratings] = is_sort_ratings
      # session[:movies]  = @movies
    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end
