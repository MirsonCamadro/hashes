require 'uri'
require 'net/http'
require 'openssl'
require 'json'


def get_data(address)
    url = URI(address)

    http = Net::HTTP.new(url.host, url.port)

    request = Net::HTTP::Get.new(url)
    http.use_ssl = true 
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    response = http.request(request)

    unless (response.code.to_i / 100) == 2
        return nil
    else
        return JSON.parse(response.read_body)
    end
end 

request = get_data("https://pokeapi.co/api/v2/pokemon/bulbasaur")

def web(data)
    sprite_images = data["sprites"]
    
    output = "<html>\n<head>\n</head>\n<body>\n"
    sprite_images.each do |k,v|
        if v != nil
            output += "<h2> #{k}</h2>" 
            output += "<img src=#{v} />"
        end
    end
    output += "</body>\n </html>"

    File.write("index.html", output)
end

web(request)