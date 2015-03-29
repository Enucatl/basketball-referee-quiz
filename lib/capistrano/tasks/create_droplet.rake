require "rest-client"

desc "create a droplet on rake through the API"

  task :create_droplet do
    token = Rails.application.secrets["development"]["digitalocean_token"]
    p "token", token
    url = "https://api.digitalocean.com/v2/droplets"
    body = {
      name: "basketballrefchallenge.com",
      region: "ams3",
      size: "512mb",
      image: "ubuntu-14-04-x64",
      ssh_keys: [307676, 322283],
      user_data: File.read("config/user_data.yml"),
    }
    headers = {
      Authorization: "Bearer #{token}"
    }
    creation_response = JSON.parse(RestClient.post(url, body, headers))
    response = {}
    p "Creating droplet..."
    loop do
      sleep 5
      response = JSON.parse(RestClient.get("#{url}/#{creation_response["droplet"]["id"]}", headers))
      break if response["droplet"]["status"] == "active"
    end
    p "droplet created with ip #{response["droplet"]["networks"]["v4"][0]["ip_address"]}"
  end


