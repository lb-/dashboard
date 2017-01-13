use Kitto.Job.DSL

job :logo do
  broadcast! :logo, %{image: "/assets/images/lb-logo.png"}
end
