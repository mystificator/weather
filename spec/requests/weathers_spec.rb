require 'rails_helper'

RSpec.describe "Weathers", type: :request do
  describe "GET /weather/:city" do
    context "when valid city" do
      let(:valid_city) { 'Indore' }
      let(:valid_weather_data) do
        {
          'name' => 'Indore',
          'main' => { 'temp' => 10, 'humidity' => 80 },
          'weather' => [{ 'description' => 'Cloudy' }]
        }
      end
      
      before do
        # stubs are set up to mock the behavior of external dependencies
        allow(Faraday).to receive(:get).and_return(double(success?: true, body: valid_weather_data.to_json))
        get "/weather/#{valid_city}"
      end
      
      it "should return valid weather data" do
        expect(JSON.parse(response.body)).to include('city', 'temperature', 'description')
      end

      it "should return an ok status code" do
        expect(response).to have_http_status(:ok)
      end
    end
    
    context "when invalid city" do
      let(:invalid_city) { 'ahdwvhawvd' }
      
      before do
        allow(Faraday).to receive(:get).and_return(double(success?: false))
        get "/weather/#{invalid_city}"
      end
      
      it "should return an internal_server_error status" do
        expect(response).to have_http_status(:internal_server_error)
      end

      it "should return an error message" do
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Failed to fetch weather data' })
      end
    end
    
    # context "when API key is missing" do
    #   before do
    #     allow(ENV).to receive(:[]).with('OPENWEATHERMAP_API_KEY').and_return(nil)
    #     get "/weather/Indore"
    #   end
      
    #   it "should return an internal_server_error status" do
    #     expect(response).to have_http_status(:internal_server_error)
    #   end
  
    #   it "should return an error message" do
    #     expect(JSON.parse(response.body)).to eq({ 'error' => 'Failed to fetch weather data' })
    #   end
    # end
  end
end