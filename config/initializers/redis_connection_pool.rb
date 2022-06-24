REDIS = ConnectionPool.new(size: 10) { Redis.new }
