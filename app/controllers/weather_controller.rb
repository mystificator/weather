class WeatherController < ApplicationController
  
    def show
      api_key = ENV['OPENWEATHERMAP_API_KEY']
      city_name = params[:city]
      
      response = Faraday.get("https://api.openweathermap.org/data/2.5/weather?q=#{city_name}&appid=#{api_key}&units=metric")
      
      if response.success?
        weather_data = JSON.parse(response.body)
        render json: format_weather_data(weather_data), status: :ok
      else
        render json: { error: 'Failed to fetch weather data' }, status: :internal_server_error
      end
    end
    

    private
    def format_weather_data(weather_data)
      {
        city: weather_data['name'],
        temperature: weather_data['main']['temp'],
        description: weather_data['weather'][0]['description']
      }
    end
  
end