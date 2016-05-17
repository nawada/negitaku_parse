# coding: utf-8

require 'nokogiri'

class ParseHtml
  def parse
    doc = open
    doc.css('.entry .entry-content .entry-body').each { |entry|
      player = {}
      key = ''
      entry.children.each { |child|
        next unless child.elem?
        next if empty_string?(child.text)

        raw_text = child.to_s
        if raw_text.include?('h2')
          player[:name] = child.text.strip
        elsif raw_text.include?('h3')
          key = child.text.strip
        elsif raw_text.include?('p')
          value = child.text.strip
          player[key.to_sym] ? player[key.to_sym] << value : player[key.to_sym] = value
        end
      }

      p player
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
