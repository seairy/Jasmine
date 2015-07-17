class Wechat::Menu < Wechat::Base
  class << self
    def create
      menu = {
        "button" =>[{
          "name" => "功能菜单",
          "sub_button" =>[
            {  
              "type" => "view",
              "name" => "小信鸽",
              "url" => "http://luggagep.com/wechat/dashboard"
            }]
          },
          {  
            "name" => "关于我们",
            "sub_button" => [
              {
                "type" => "view",
                "name" => "下载App",
                "url" => "http://luggagep.com/app"
              }
            ]
          }
        ]
      }
      uri = URI("https://api.weixin.qq.com/cgi-bin/menu/create?access_token=#{Wechat::Base.access_token}")
      request = Net::HTTP::Post.new(uri)
      request.body = menu.to_json
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.ssl_version = :SSLv3
        http.request(request)
      end.body
    end

    def delete
      uri = URI("https://api.weixin.qq.com/cgi-bin/menu/delete?access_token=#{Wechat::Base.access_token}")
      request = Net::HTTP::Post.new(uri)
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.ssl_version = :SSLv3
        http.request(request)
      end.body
    end
  end
end