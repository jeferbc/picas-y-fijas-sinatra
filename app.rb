require 'sinatra'
require "sinatra/cookies"
require "active_support/all"
require 'byebug'

class Intent

  attr_accessor :picas,:fijas, :number

  def initialize (number)
    @picas = 0
    @fijas = 0
    @number = number.to_i
  end

  def input_number
    @number = @number.to_s.chars.map(&:to_i)
    if (@number.uniq! != nil)        #Detect repeat @numbers
      @number = true
    end
  end

  def compare(master)
    i = 0
    j = 0
    until i == @number.length
      until j == @number.length
        puts "i = #{i} j = #{j} master[i] = #{master[i]} @number[j] = #{@number[j]}"
        if (i == j && master[i] == @number[j])
          puts "entro"
          @fijas += 1
        elsif master[i] == @number[j]
          @picas += 1
          puts "entro @picas"
        end
        j += 1
      end
      i += 1
      j = 0
    end
  end
  end

  def get_number
    (0..9).to_a.shuffle
  end

  def initialize_cookies
    master_number = get_number
    array_number = []
    session[:array_number] = array_number
    session[:master_number] = master_number
    response.set_cookie(:first_time, true)
  end

enable :sessions

  get '/' do
    if cookies[:first_time]
        @first_time = false
        session[:first_time] = @first_time
        @object_number = []
        @object_number  = session[:array_number]
        erb :index
    else
      @first_time = true
      puts @first_time
      initialize_cookies
      erb :index
    end
  end

  get '/intent' do
    @master_number = session[:master_number]
    puts @master_number
    object = Intent.new(params[:number])
    @validation = ''
    object.input_number
    puts object.number
      if object.number == true
        @validation = 'Incorrect Number, the digits must be different'
        @first_time = true
        erb :index
      else
        object.compare(@master_number)
        puts object
        if object.fijas == object.number.length
          cookies.delete(:first_time)
          erb :winner
        else
          @object_number = []
          @object_number  = session[:array_number]
          @object_number << object
          session[:array_number] = @object_number
          @picas = object.picas
          @fijas = object.fijas
          erb :picas_fijas
      end
  end
end
