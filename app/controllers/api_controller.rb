class ApiController < ApplicationController


  def login
    code = params[:code]
    puts "State:#{params[:state]}"
    puts "Code:#{params[:code]}"
    token = get_access_token(code)
    user_id = find_or_create_user(token)
    render :json => user_id.to_json
  end

  def board
    index = params['index'].to_i
    limit = 25
    user_id = "122608475"
    interests = REDIS.smembers("interests:#{user_id}")
    # interests = [1229271]

    rv = []
    interests.each do |i|
      list = REDIS.lrange("picture_timesort:#{i}", limit * index, (limit * index) + 25)
      (0..list.size-1).each do |l|
        element = list[l]
        h = JSON.parse(element)
        h['user_id'] = i
        h['user_picture_index'] = (limit * index) + l
        rv << h
      end
    end
    rv.sort_by{|a| a['created_time']}.reverse!
    render :json => rv.to_json
  end

  def female_friends
    user_id = "122608475"
    if REDIS.hget("user:#{user_id}","fb_fetch_date").blank?
      render :json => "not ready"
    else
      render :json => REDIS.smembers("female_fbfriends:#{user_id}")
    end
  end

  def add_interests
    user_id = "122608475"
    interest_ids = JSON.parse(params[:ids]) rescue []
    REDIS.pipelined {
      interest_ids.each do |i|
        REDIS.sadd("interests:#{user_id}", i)
      end
    }
    PictureFetcher.fetch(user_id)
  end

  private
  def get_access_token(code)
    url = "https://graph.facebook.com/oauth/access_token?client_id=226052724163460&redirect_uri=http://localhost:3000/api/login&client_secret=5c3cd526462bd795857b4e380ae7b8c2&code=#{code}"
    p = get_page(url)
    if p.include? "error"
      puts "ERROR WHILE GETTING TOKEN - #{p}"
      return nil
    else
      return p.split('&').first.split('=').last
    end
  end

  def store_person(prefix, map)
    key = "#{prefix}:#{map['id']}"
    REDIS.hmset(key, *map.flatten)
  end

  def find_or_create_user(token)
    basic_info = get_basic_info("me", token)
    fb_id = basic_info['id']
    if  REDIS.hget("user:#{fb_id}","fb_fetch_date").blank?
      basic_info['token'] = token
      store_person("user", basic_info)
      FriendFetcher.fetch(fb_id)
    else
      REDIS.hset("user:#{fb_id}","token", token)
    end
    return fb_id
  end

  def get_basic_info(id, token)
    url = "https://graph.facebook.com/#{id}?access_token=#{token}"
    basic_info =  get_page(url)
    count = 0
    while count < 3
      if basic_info != "false"
        basic_info = JSON.parse(basic_info)
        picture_info = {'photo_url' => "https://graph.facebook.com/#{id}/picture?access_token=#{token}"}
        return basic_info.merge(picture_info)
      end
      count += 1
    end
  end

  def get_page(url)
      begin
        if (url == nil)
           return nil
        end
      curl = Curl::Easy.new
      startTime = Time.now
      curl.timeout = 30
      curl.url = url
      curl.perform
      endTime = Time.now
      return curl.body_str
     rescue => e
       puts "Error while getting page #{url} - Error #{e}"
     rescue Timeout::Error => e
       puts "Timeout while getting page #{url} - Error #{e}"
     end
     return nil
  end
end