class BuildsController < ApplicationController
  include BuildsHelper
  
  def index
    @builds = Build.order('whatsnew_time DESC')
  end

  def check
    check_build(params[:tag])

    redirect_to root_path
  end

  def show
    @build = Build.find(params[:id])

    require 'xmlrpc/client'
    require 'openssl'

    server = XMLRPC::Client.new2("#{ Settings.bugzilla_url }/xmlrpc.cgi")
    server.instance_variable_get(:@http).instance_variable_set(:@verify_mode, OpenSSL::SSL::VERIFY_NONE)
    user = server.proxy('User')
    user.login({ 'login' => Settings.bugzilla.login, 'password' => Settings.bugzilla.password })

    bug = server.proxy 'Bug'

    last_commits = {}
    bug.history(ids: @build.bug_list.split(','))['bugs'].each do |bug_history|
      date = time = nil
      (0..(bug_history['history'].length - 1)).reverse_each.each do |i|
        if reporev_changed?(bug_history['history'][i])
          date ||= bug_history['history'][i]['when'].to_date
          time ||= bug_history['history'][i]['when'].to_time
        end
      end
      
      if !date.nil?
        last_commits[ bug_history['id'] ] = DateTime.new(date.year, date.month, date.day, time.hour, time.min, time.sec)
      end
    end


    @bugs = []
    bug.get(ids: @build.bug_list.split(','))['bugs'].each do |bug|
      assignments = []
      Settings.testers.each do |tester|
        assignment = []
        assignment  << 'creator' if bug['creator'].include? tester
        assignment << 'CC' if bug['cc'].include? tester
        assignment << 'qa contact' if bug['qa_contact'].include? tester

        if !assignment.empty?
          assignments << { tester: tester, assignment: assignment.join(', ') }
        end
      end

      if last_commits[bug['id']].nil?
        included = true
      else
        @build.whatsnew_time > last_commits[bug['id']] ? included = true : included = false
      end

      @bugs << { id: bug['id'], summary: bug['summary'], status: bug['status'], assignments: assignments, included: included }
    end
  end


protected

  def reporev_changed?(change)
    res = false
    change['changes'].each do |change|
      res = true if change.has_value?('cf_reporev') ||change.has_value?('whiteboard')
    end
    res
  end

end