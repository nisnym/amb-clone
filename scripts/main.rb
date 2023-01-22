puts "Hello, World!"

require 'pdf-reader'
require 'net/http'
require 'json'
require 'csv'


pdf_file = './book1.pdf'
url = URI("https://api.openai.com/v1/engines/text-davinci-003/completions")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true


# reader = PDF::Reader.new(pdf_file)

# File.open("p2.txt", 'w') do |file|
#     reader.pages.each do |page|
#         paragraphs = page.text.split(/\n/)
#         paragraphs.each do |paragraph|
#         paragraph = paragraph.split(/(?<=[.?!])\s+(?=[a-z])/)        
#             paragraph.each do |line|
#                 file.puts(line)
#             end
#         end
#     end
# end




sentences = []
current_sentence = ""

File.foreach("p.txt") do |line|
  if line.strip.end_with?(".")
    current_sentence += line
    sentences << current_sentence
    current_sentence = ""
  else
    current_sentence += line
  end
end


puts sentences[0]
puts sentences.length

responses = []

sentences.each do |sentence|
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/json'
    request["Authorization"] = "Bearer #{api_key}"
    request.body = JSON.dump({
        "prompt" => sentence + "generate faq from the given text. Book name The Minimalist Entrepreneur by Sahil Lavingia",
        "max_tokens" => 100
    })
    response = http.request(request)
    responses << JSON.parse(response.read_body)['choices'][0]['text']  
end

puts responses



CSV.open("responses.csv", "w") do |csv|
    csv << ["sentence", "response"]
    sentences.zip(responses).each do |sentence, response|
      csv << [sentence, response]
    end
  end








