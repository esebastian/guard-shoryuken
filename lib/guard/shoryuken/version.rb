module Guard
  module ShoryukenVersion
    MAJOR = 0     # api
    MINOR = 1     # features
    PATCH = 0    # bug fixes
    BUILD = nil   # beta, rc1, etc

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
  end
end
