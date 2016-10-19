require 'sinatra'

class Intent
  attr_accessor :picas,:fijas, :number

  def initialize (number)
    @picas = 0
    @fijas = 0
    @number = number.chars.map(&:to_i)
  end

  def validation(level)
    if(@number.length != level)           #Detect amount of digits
      "level"
    elsif(@number.uniq! != nil)           #Detect repeat @numbers
      "number"
    end
  end

  def compare(master)
    @number.length.times do |i|
      @number.length.times do |j|
        if (i == j && master[i] == @number[j])
          @fijas += 1
        elsif master[i] == @number[j]
          @picas += 1
        end
      end
    end
  end
  def self.get_number
    (0..9).to_a.shuffle
  end
end

enable :sessions

  get '/' do
    if (session[:first_time] != nil)
      @validation_flag = session{:validation}
      @first_time = true
      @object_number = []
      @object_number  = session[:array_number]
      puts "validation #{@validation_flag} first_time #{@first_time}"
      erb :index
    else
      session[:array_number] = []
      session[:master_number] = Intent.get_number
      puts session[:master_number].inspect
      @first_time = false
      session[:first_time] = @first_time
      session[:level_flag] = @first_time
      erb :index
    end
  end

  get '/intent' do
    @master_number = session[:master_number]
    object = Intent.new(params[:number])
    if (session[:level_flag] == false)
      session[:level_flag] = true
      session[:level] = params[:level].to_i
    end
    @validation = ''
    error = object.validation(session[:level])
    if error == "number"
      @validation = 'Incorrect Number, the digits must be different'
      session[:validation] = false
      erb :index
    elsif error == "level"
      @validation = "Incorrect Number, the number must have #{session[:level]} digits"
      session[:validation] = false
      erb :index
    else
      session[:validation] = true
      object.compare(@master_number)
      if object.fijas == object.number.length
        @number = object.number
        session.clear
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
