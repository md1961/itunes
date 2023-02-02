class ApplicationController < ActionController::Base

  protected

    def retrieve_artist_initial_range_name
      params[:initial_range] || session[:artist_initial_range_name]
    end

    def store_artist_initial_range_name(name)
      session[:artist_initial_range_name] = name
    end
end
