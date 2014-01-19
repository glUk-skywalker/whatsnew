module BuildsHelper

  def check_build(tag)
    whatsnew_time = nil
    Net::HTTP.start(Settings.base_url) do |http|
      response = http.request_head("/paupdate/#{ tag }/whatsnew.txt")
      whatsnew_time = DateTime.parse(response['Last-Modified'])
    end

    require 'open-uri'

    new_build_number = open("#{ Settings.updates_url }/#{ tag }/buildno.txt").read

    if !Build.any? || Build.find_by(number: new_build_number).nil?
      build_bugs = open("#{ Settings.updates_url }/#{ tag }/whatsnew.txt").read.split("Bugs Resolved:")[1].scan(/#\d+/).map{ |e| e[1..-1] }.join(",")
      Build.create(number: new_build_number, tag: tag, bug_list: build_bugs, whatsnew_time: whatsnew_time)
    end
  end

end