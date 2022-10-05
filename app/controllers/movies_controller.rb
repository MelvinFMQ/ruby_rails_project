class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @all_ratings = ['G','R','PG-13','PG']
      prev_ratings = []
      unless params['ratings'].nil?
        for element in params['ratings'] do
          prev_ratings.append(element)
        end
      end
      @ratings_to_show = prev_ratings

      #0 means ASC, #1 DSC, #2 no sort 
      prev_sort_title = ''
      prev_sort_release_date = ''

      unless params['sort_title'].nil?
        prev_sort_title = params['sort_title']
      end

      unless params['sort_release_date'].nil?
        prev_sort_release_date = params['sort_release_date']
      end
      
      #no sort
      if prev_sort_title == '' and prev_sort_release_date == '' then
        @sort_title = 'asc'
        @movies = Movie.with_ratings(@ratings_to_show)
        @sort_release_date = 'asc'
      elsif prev_sort_title == '' then 
        @movies = Movie.with_ratings(@ratings_to_show).order('release_date': prev_sort_release_date)
        @sort_title = 'asc'
        if (prev_sort_release_date == 'asc') then
          @sort_release_date = 'desc'
        else
          @sort_release_date = 'asc'
        end
        @release_date_class = "bg-warning"
      elsif prev_sort_release_date = '' then
        @movies = Movie.with_ratings(@ratings_to_show).order('title': prev_sort_title)
        if (prev_sort_title == 'asc') then
          @sort_title = 'desc'
        else
          @sort_title = 'asc'
        end
        @title_class = "bg-warning hilite"
        @sort_release_date = 'asc'
      end
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