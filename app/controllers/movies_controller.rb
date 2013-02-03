class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
     ratings = params[:ratings]!=nil ? params[:ratings] : session[:ratings]
     filters = params[:filter]!=nil ? params[:filter] : session[:filter]
     #sort = params[:sort]!=nil ? params[:sort] : session[:sort]

     #ratings =  params[:ratings] 
     #filters =  params[:filter] 
     sort = params[:sort] 


     @all_ratings = Movie.getAvailableRatings(ratings)
    if sort=="title"
     if filters!=nil
      @movies =Movie.where(:rating => filters.select {|k,v| v=='true'}.keys ).sort_by &:title
      @all_ratings = Movie.getAvailableRatings(filters.select {|k,v| v=='true'})
     else
      @movies=Movie.all.sort_by &:title
     end
    elsif sort=="created"
     if filters!=nil
      @movies =Movie.where(:rating => filters.select {|k,v| v=='true'}.keys).order("release_date ASC")
      @all_ratings = Movie.getAvailableRatings(filters.select {|k,v| v=='true'})
     else
      @movies = Movie.find :all, :order => "release_date ASC"    
     end    
    else
     @movies = ratings==nil ? Movie.all : Movie.where(:rating => ratings.keys) 
    end
    session[:ratings] = ratings == nil ? session[:ratings] : ratings
    session[:sort] = params[:sort] == nil ? session[:sort] : params[:sort]
    session[:filter] = params[:filter] == nil ? session[:filter] : params[:filter]
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
