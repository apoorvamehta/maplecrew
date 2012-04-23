class FriendFetcher
	def initialize(user_id)
    	@user_id = user_id
  	end

	def self.fetch(user_id)
		Delayed::Job.enqueue(FriendFetcher.new(user_id), 0)
	end

	def perform
		get_and_store_fb_friends(@user_id)
	end

	def get_fb_friends(user_id)
		token = REDIS.hget("user:#{user_id}", "token")
		url = "https://graph.facebook.com/me/friends?access_token=#{token}"
		list = JSON.parse(get_page(url))['data']
		rv = []
		list[0..120].each_slice(50) do |group|
			post_data = []
			post_data << Curl::PostField.content('access_token', token)
			post_data << Curl::PostField.content('batch', group.compact.map{|g| {"method" => "GET", "relative_url" => g['id']}}.to_json)
			c = Curl::Easy.new('https://graph.facebook.com')
			c.multipart_form_post = true
			c.http_post(post_data)
			parsed = JSON.parse(c.body_str)
			rv << parsed.map{|p| p['body'] }
		end
		return rv.flatten.map{|a| JSON.parse(a)}
	end

	def store_fb_friends(user_id, fb_friends)
		# fb_friends.each do |f|
		# 	store_person("fb_user", f)
		# end
		male_friends = fb_friends.reject{|a| a['gender'] != 'male'}
		female_friends = fb_friends.reject{|a| a['gender'] != 'female'}

		REDIS.pipelined {
			male_friends.each do |mf|
	        	REDIS.sadd "male_fbfriends:#{user_id}", mf.to_json
	        end
	    }

	    REDIS.pipelined {
			female_friends.each do |ff|
	        	REDIS.sadd "female_fbfriends:#{user_id}", ff.to_json
	        end
	    }
	end

	def store_person(prefix, map)
		key = "#{prefix}:#{map['id']}"
		REDIS.hmset(key, *map.flatten)
	end
	def get_and_store_fb_friends(user_id)
		fb_friends = get_fb_friends(user_id)
		store_fb_friends(user_id, fb_friends)
		REDIS.hset("user:#{user_id}", "fb_fetch_date", Time.now)
	end

	def get_page(url)
	    begin
		    if (url == nil)
		       return nil
		    end
			curl = Curl::Easy.new
			startTime = Time.now
			curl.timeout = 50
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