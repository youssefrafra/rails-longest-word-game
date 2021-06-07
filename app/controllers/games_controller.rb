class GamesController < ApplicationController
    def new
        alphabet = [*("A".."Z")]
        @letters = Array.new(rand(8..12)).map { |el| el = alphabet.sample }
    end

    def score
        @answer = params[:answer]
        @grid = eval(params[:grid])
        url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
        uri = URI.parse(url)
        @result = JSON.parse(Net::HTTP.get(uri))
        @valid = validate(@answer,@grid)
        checkAndShow
        # raise
    end

    def redirect
        session[:score] = ''
        redirect_to new_path
    end 
    private
    
    def checkAndShow()
        if(@result["found"])
            if(!@valid)
                @message= "Sorry but <strong>#{@answer}</strong> can't be built out of #{@grid.join(", ")}"
                session[:score] = session[:score] ? session[:score].to_i : 0
            else
                @message= "Congratulation! <strong>#{@answer}</strong> is a valid english word"
                session[:score] = session[:score] ? session[:score].to_i + @result["length"] : @result["length"]
            end
        else
            @message = @result["error"]
        end      
    end

    def validate(word, grid)
        word.upcase.each_char do |letter|
            return false unless word.upcase.scan(letter).length <= grid.join("").scan(letter).length
        end
        return true
    end
end
