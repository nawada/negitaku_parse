# coding: utf-8

require 'nokogiri'

class ParseHtml
  def parse
    doc = open
    players = []
    doc.css('.entry .entry-content .entry-body').each { |entry|
      player = {}
      key = ''
      entry.children.each { |child|
        next unless child.elem?

        text = child.text.strip
        next if empty_string?(text)

        raw_text = child.to_s
        if raw_text.include?('h2')
          player[:'名前'] = text
        elsif raw_text.include?('h3')
          key = text
        elsif raw_text.include?('p') and !empty_string?(key)
          value = text
          player[key.to_sym] ? player[key.to_sym] << value : player[key.to_sym] = value
        end
      }

      players << player if player.size > 0
    }
    players
  end

  def open(filename = 'sample.html')
    File.open(filename) { |f| Nokogiri::HTML(f) }
  end

  def empty_string?(value = '')
    value.nil? || value.strip.empty?
  end
end

if __FILE__ == $0
  players = ParseHtml.new.parse

  players.each { |player|
    player.each {|key, value|
      puts "#{key}: #{value}"
    }
    puts ''
  }
end
