require 'sinatra'
require "sinatra/cookies"
require "active_support/all"
require 'byebug'

def get_number
  (0..9).to_a.shuffle
end

def input_number(number)
  number = number.split(//)
  if number.detect{ |e| number.count(e) > 1 } == nil        #Detect repeat numbers
    number
  else
    false
  end
end

def toint(number)
    i = 0
    until i == number.length
      number[i] = number[i].to_i
      i += 1
    end
    number
end

def compare(number,master)
  i = 0
  j = 0
  picas = 0
  fijas = 0
  print "#{master}"
  until i == number.length
    until j == number.length
      puts "i = #{i} j = #{j} master[i] = #{master[i]} number[j] = #{number[j]}"
      if (i == j && master[i] == number[j])
        puts "entro"
        fijas += 1

      elsif master[i] == number[j]
        picas += 1
        puts "entro picas"
      end
      j += 1
    end
    i += 1
    j = 0
  end
  return picas, fijas
end


get '/' do
  if cookies[:first_time]
      erb :index
  else
    @master_number = get_number
    response.set_cookie(:master_number, @master_number)
    response.set_cookie(:first_time, true)
    erb :index
  end
end

get '/intent' do

  puts "#{@array}".inspect
  @master_number = cookies[:master_number].split(/&/)
  @master_number = toint(@master_number)
  @number = params[:number]
  print "#{@master_number}"
  @validation = ''
  @number = input_number(@number)
    if !@number
      @validation = 'Incorrect Number, the digits must be different'
      erb :index
    else
      @number = toint(@number)
      @picas, @fijas = compare(@number, @master_number)
      if @fijas == @number.length
        cookies.delete(:master_number)
        cookies.delete(:first_time)
        erb :winner
      else
        erb :picas_fijas
      end
    end
  end
