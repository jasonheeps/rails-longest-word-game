require 'open-uri'

class GamesController < ApplicationController
  API_URL = 'https://wagon-dictionary.herokuapp.com/'

  def new
    @letters = 10.times.map { Array('A'..'Z').sample }
    @time_start = Time.now
  end

  def score
    word = params[:word]
    letters = params[:letters].split

    @time_end = Time.now
    duration = @time_end - Time.new(params[:time_start])

    @score = 0

    select_message(word, letters, duration)

    @score = calculate_score(word, duration) if valid?(word, letters)
  end

  def select_message(word, letters, duration)
    is_grid_word = grid_word?(word, letters)
    is_english_word = english_word?(word)
    if is_grid_word && is_english_word
      @score = calculate_score(word, duration)
      @message = 'Congratulations!'
    elsif !is_grid_word
      @message = "#{word} can't be built with #{params[:letters]}"
    else
      @message = "#{word} is not an English word"
    end
  end

  def calculate_score(word, duration)
    (word.length * duration * 100).round
  end

  def valid?(word, letters)
    # call grid_word? and english_word?
  end

  def grid_word?(word, letters)
    word.upcase.each_char do |char|
      return false unless letters.include?(char)

      letters.delete_at(letters.index(char))
    end
    true
  end

  def english_word?(word)
    url = "#{API_URL}#{word}"
    api_entry = open(url).read # this is serialized / an ugly string
    entry = JSON.parse(api_entry) # this is deserialized / a hash
    entry['found']
  end
end
