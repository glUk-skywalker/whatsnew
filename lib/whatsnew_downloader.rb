require 'net/http'

class WhatsnewDownloader

  attr_reader :builds

  def self.get_for(tag)
    whatsnew_time, content = nil

    Net::HTTP.start("www.polyanalyst.com") { |http|
      whatsnew_time = http.head("/paupdate/#{ tag }/whatsnew.txt")['last-modified']
      whatsnew_time = Time.parse whatsnew_time
      content = http.get("/paupdate/#{ tag }/whatsnew.txt").body
    }

    new(whatsnew_time, tag, content)
  end

  def initialize(whatsnew_time, branch, content)
    @whatsnew_time = whatsnew_time
    @branch = branch
    @content = content
  end

  def parsed
    date_mask = /\nDate:   \d{1,2}\/\d{1,2}\/\d{1,2}/
    builds_info = []

    indexes = @content.enum_for(:scan, date_mask).map{ Regexp.last_match.begin(0) }

    indexes.each_with_index{ |start_pos, i|
      end_pos = indexes[i + 1] || @content.length - 1

      b = @content[start_pos..end_pos]

      begin
        builds_info << {
          number: b.sub(' Rev. ', '').b[/Build:  6.[0.5].\d+/].split('.').last,
          bug_list: b.scan(/\n#\d+/).join(',').gsub("\n#", ''),
          task_list: b.scan(/\nT\d+/).join(',').gsub("\n", ''),
          whatsnew_time: normalize_date(b[date_mask].split('   ').last),
          tag: @branch
        }
      rescue ArgumentError
      end
    }

    builds_info.first[:whatsnew_time] = @whatsnew_time
    builds_info
  end

  private

  def normalize_date(date_str)
    Time.strptime(date_str.insert(-3, '20'), '%m/%d/%Y')
  end

end
