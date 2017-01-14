use Kitto.Job.DSL

job :flights, every: :second do
  flights_with_hours = [%{label: "Singapore", value: "8 hrs"}, %{label: "Ho Chi Minh City", value: "2 hrs"}, %{label: "Total [2]", value: "10 hrs"}]
  flights_with_distance = [%{label: "Singapore", value: "6149 KMs"}, %{label: "Ho Chi Minh City", value: "1091 KMs"}, %{label: "Total [2]", value: "7240 KMs"}]
  random = fn -> :rand.uniform * 100 |> Float.round end
  list = [flights_with_hours, flights_with_distance] |> Enum.random
  broadcast! :flights, %{items: list}
end
