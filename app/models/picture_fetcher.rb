class PictureFetcher
	def initialize(user_id)
    	@user_id = user_id
  	end

	def self.fetch(user_id)
		Delayed::Job.enqueue(PictureFetcher.new(user_id), 0)
	end

	def perform
		interests = REDIS.smembers("interests:#{@user_id}")
		token = REDIS.hget("user:#{@user_id}","token")
		results = Parallel.map(interests, :in_threads=>interests.size){|i| fetch_and_store_pictures(i, token)}
	end

	def fetch_and_store_pictures(interest_id, token)
		key = "picture_timesort:#{interest_id}"
		if REDIS.llen(key) != 0
			puts "ENTRIES ALREADY PRESENT FOR USER - NOT RE-STORING ANY PICS"
			return
		end
		url = "https://graph.facebook.com/#{interest_id}/photos?access_token=#{token}"
		body = get_page(url)
		list = JSON.parse(body)
		while true
			REDIS.pipelined {
				puts "STORING - #{list['data'].size}"
				list['data'].each do |l|
		        	REDIS.rpush key, l.to_json
		        end
	    	}
	 		url = list['paging']['next'] rescue nil
	 		if url == nil
	 			break
	 		else
	 			body = get_page(url)
	 			list = JSON.parse(body)
	 		end
		end
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