# Dockerfile

# Use the official Ruby image
FROM ruby:3.1.4 as base

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs npm sqlite3 libsqlite3-dev
# Install dependencies for SQLite3 and Node.js
RUN apt-get update -qq && apt-get install -y \
  nodejs \
  npm \
  sqlite3 \
  redis-tools \
  libsqlite3-dev \
  && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /keeper-notes

# Add Gemfile and Gemfile.lock to the working directory
COPY Gemfile* ./

# Install custom Bundler version
RUN gem install bundler -v 2.5.9

# Install the Ruby gems
RUN bundle install

# Add the rest of the application code
COPY . .

# Precompile assets
RUN bundle exec rake assets:precompile

# Expose the port the app runs on
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
