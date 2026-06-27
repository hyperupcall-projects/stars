class Repository:
    def __init__(self, name, description, language, url, stargazer_count, is_private, topics):
        self.name = name
        self.description = description
        self.language = language
        self.url = url
        self.stargazer_count = stargazer_count
        self.is_private = is_private
        self.topics = topics
