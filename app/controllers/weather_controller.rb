class WeatherController < ApplicationController
  
    def show
      api_key = ENV['OPENWEATHERMAP_API_KEY']
      city_name = params[:city]
  
      weather_data = Faraday.get("https://api.openweathermap.org/data/2.5/weather?q=#{city_name}&appid=#{api_key}&units=metric")
      weather_data = JSON.parse(weather_data.body)
      if weather_data['cod'] = 200
        render json: weather_data['main'].merge({ description: weather_data['weather'][0]['description'] }).merge({name: weather_data['name']})
      else
        render json: { error: 'City not found' }, status: 404
      end
    end
  
  end
  