use Kitto.Job.DSL
import Poison.Decode

#for testing - load project into iex via `iex -S mix`

defmodule City.JSONFetch do

  def fetch(nomad_list_city_slug) do
    # json = ~s({"ok":true,"updated":{"epoch":1484374475,"time":"2017-01-14T06:14:35+00:00","cache":false},"type":"cities","result":[{"info":{"city":{"name":"Ho Chi Minh City","url":"\/ho-chi-minh-city-vietnam","slug":"ho-chi-minh-city-vietnam"},"country":{"name":"Vietnam","url":"\/country\/vietnam","slug":"vietnam"},"region":{"name":"Asia","url":"\/region\/asia","slug":"asia"},"internet":{"speed":{"download":10}},"weather":{"type":"Mostly Cloudy","humidity":{"label":"Comfortable","value":0.58},"temperature":{"celsius":32,"fahrenheit":89}},"location":{"latitude":10.8230989,"longitude":106.6296638},"monthsToVisit":[]},"people":{"checkins":"8"},"scores":{"nomadScore":0.76,"nomad_score":0.76,"life_score":0.7,"free_wifi_available":0.6,"peace_score":0.6,"fragile_states_index":70.7,"freedom_score":0.2,"press_freedom_index":74.27,"nightlife":0.76,"leisure":0.8,"places_to_work":0.8,"aircon":0.58,"safety":0.58,"friendly_to_foreigners":0.6,"racism":0.4,"lgbt_friendly":0.4,"female_friendly":0.6},"media":{"image":{"250":"\/assets\/img\/cities\/ho-chi-minh-city-vietnam-250px.jpg","500":"\/assets\/img\/cities\/ho-chi-minh-city-vietnam-500px.jpg","1000":"\/assets\/img\/cities\/ho-chi-minh-city-vietnam-1000px.jpg","1500":"\/assets\/img\/cities\/ho-chi-minh-city-vietnam-1500px.jpg"}},"cost":{"local":{"USD":479,"VND":10805655},"nomad":{"USD":721,"VND":16251503},"expat":{"USD":844,"VND":19023195},"longTerm":{"USD":844,"VND":19023195},"shortTerm":{"USD":721,"VND":16251503},"hotel":{"VND":475000,"USD":21},"airbnb_median":{"USD":47,"VND":47},"airbnb_vs_apartment_price_ratio":3.2178968916191,"non_alcoholic_drink_in_cafe":{"VND":8333.33,"USD":0.37},"beer_in_cafe":{"VND":25000,"USD":1.11},"coffee_in_cafe":{"VND":16666.67,"USD":0.74},"coworking":{"monthly":{"VND":2000000,"USD":88.69}},"exchange_rate":{"USD":4.4345734125807e-5}},"tags":["nomads","street food","food","nightlife","places of worship","temples"]}],"endpoint_examples":["\/api\/v2\/list\/places","\/api\/v2\/list\/cities","\/api\/v2\/list\/cities\/amsterdam-netherlands","\/api\/v2\/list\/countries","\/api\/v2\/list\/countries\/netherlands","\/api\/v2\/list\/regions","\/api\/v2\/list\/regions\/europe","\/api\/v2\/list\/cities\/amsterdam-netherlands\/places\/work","\/api\/v2\/list\/cities\/amsterdam-netherlands\/places\/sleep"]})
    nomad_list_city_url(nomad_list_city_slug)
    |> HTTPoison.get
    |> handle_json
    |> City.ExtractMap.extract_from_body
  end
  #https://hackernoon.com/elixir-console-application-with-json-parsing-lets-print-to-console-b701abf1cb14#.vr0hnkluz

  defp nomad_list_city_url(nomad_list_city_slug) do
    "https://nomadlist.com/api/v2/list/cities/#{nomad_list_city_slug}"
  end

  def handle_json({:ok, %{status_code: 200, body: body}}) do
    {:ok, Poison.Parser.parse!(body)}
  end

  def handle_json({_, %{status_code: _, body: _}}) do
    IO.puts "Something went wrong, please check your internet connection"
  end

end

defmodule City.ExtractMap do
  defp extract_weather_description(info) do
     type = get_in(info, ["weather"]) |> get_in(["type"])
     temperature = get_in(info, ["weather"]) |> get_in(["temperature"]) |> get_in(["celsius"])
     "#{type}, #{temperature} degrees"
  end

  defp extract_country_name(info) do
    get_in(info, ["country"])
    |> get_in(["name"])
  end

  defp extract_city_name(info) do
    get_in(info, ["city"])
    |> get_in(["name"])
  end

  def extract_from_body(map) do
    {:ok, body} = map
    info = get_in(body, ["result"])
    |> List.first
    |> get_in(["info"])

    %{
      name: extract_city_name(info),
      country: extract_country_name(info),
      weather: extract_weather_description(info)
    }
    # [:name extract_city_name(info)]
  end

end

job :city, every: {30, :minutes} do
  # import Poison.Parser
  # https://en.wikipedia.org/wiki/Ho_Chi_Minh_City
  # https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro=&explaintext=&titles=Ho_Chi_Minh_City
  # https://nomadlist.com/api/v2/list/cities/ho-chi-minh-city-vietnam
  # https://nomadlist.com/modal/city/ho-chi-minh-city-vietnam
  # https://nomadlist.com/legal

  # If you use one of our APIs or data, you're required to link back to us at every page or in every app screen you use the data on.

  city = City.JSONFetch.fetch("ho-chi-minh-city-vietnam")
  city |> IO.inspect
  broadcast! :city, %{title: "#{city.name}, #{city.country}", text: city.weather, moreinfo: "Data from nomadlist.com API"}
end
