class MoviesController < ApplicationController

  def show  
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    @ratings = params.has_key?(:ratings) ? params[:ratings] : Hash.new
    @sort_by = params.has_key?(:sort_by) ? params[:sort_by] : false

    puts @all_ratings.inspect
    puts @ratings.inspect
    puts @sort_by.inspect
    puts session.inspect

    if @ratings.empty? && !@sort_by && session[:ratings] && session[:sort_by]
      flash.keep
      @ratings = session[:ratings] 
      redirect_to :action => 'index', :sort_by => session[:sort_by], :ratings => session[:ratings]

    elsif !@ratings.empty? && !@sort_by && session[:sort_by]
      flash.keep
      session[:ratings] = @ratings
      redirect_to :action => 'index', :sort_by => session[:sort_by], :ratings => @ratings

    elsif @ratings.empty? && !@sort_by && session.has_key?(:ratings)
      flash.keep
      session[:sort_by] = @sort_by
      @ratings = session[:ratings]
      redirect_to :action => 'index', :ratings => session[:ratings]

    elsif !@ratings.empty? && @sort_by
      session[:sort_by] = @sort_by
      session[:ratings] = @ratings
      @movies = Movie.find(:all, :order=>@sort_by+' ASC', :conditions => ["rating IN (?)", @ratings.keys])

    elsif !@ratings.empty?
      session[:ratings] = @ratings
      @movies = Movie.find(:all, :conditions => ["rating IN (?)", @ratings.keys])

    elsif @sort_by
      sesson[:sort_by] = @sort_by
      @movies = Movie.find(:all, :order=>@sort_by+' ASC')

    else
      puts 'searching for all'
      @movies = Movie.all
    end    
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
