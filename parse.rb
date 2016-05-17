# coding: utf-8

require 'nokogiri'

class ParseHtml
  def parse
    doc = open
    doc.css('.entry .entry-content .entry-body').each { |entry|
      # プレイヤー名が空じゃない場合のみ処理をする
      player = entry.css('h2 a')
      player_name = player.text
      next if empty_string? player_name

      player_url = player.attr('href').value

      titles = entry.css('h3')
      texts = entry.css('p.comment-text')

      puts "#{player_name}, #{player_url}, #{titles.map { |t| t.text.strip }.join(',')}, #{texts.map { |t| t.text.strip }.join(',')}"
    }
  end

  def open(filename = 'sample.html')
    File.open(filename) { |f| Nokogiri::HTML(f) }
  end

  def empty_string?(value = '')
    value.nil? || value.strip.empty?
  end
end

if __FILE__ == $0
  ParseHtml.new.parse
end
