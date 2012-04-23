ENV["REDISTOGO_URL"] = "redis://waratuman:fde667467492f0d05d779f1ac09c79dc@tetra.redistogo.com:9000/"

if !ENV["REDISTOGO_URL"].blank?
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :db => 0)

  
  if Rails.env.production?
   REDIS.select 1 # production db on the redis instance
  else
   REDIS.select 0 # default to the staging db
  end
end
