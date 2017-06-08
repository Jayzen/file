使用prawn这个gem的时候，因为暂时找不到网络上使用的字体，因此需要将字体下载到本地文件夹中，示例代码如下
```ruby
#clients_controller.rb

def download_pdf
  client = Client.find(params[:id])
  send_data generate_pdf(client), filename: "#{client.name}.pdf", type: "application/pdf"
end

private

  def generate_pdf(client)
    Prawn::Document.new do
      #建立字体
      font_families["msyh"] = {
        #放置字体的位置
        :normal => { :file => "/Users/jayzen/Desktop/Fangsong.ttf" }
      }
      #使用已经创建好的字体进行显示
      font("msyh") do
        text client.name, align: :center
        text "Address: #{client.address}"
        text "Email: #{client.email}"
      end
    end.render
  end
```
