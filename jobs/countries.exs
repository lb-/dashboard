use Kitto.Job.DSL

job :countries do
  broadcast! :countries, %{value: 1}
end
