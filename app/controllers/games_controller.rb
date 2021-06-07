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
    end
    
    private
    
    def checkAndShow()
        if(@result["found"])
            if(!@valid)
                @message= "Sorry but <strong>#{@answer}</strong> can't be built out of #{@grid.join(", ")}"
            else
                @message= "Congratulation! <strong>#{@answer}</strong> is a valid english word"
                cookies[:score] = cookies[:score] ? cookies[:score].to_i + @result["length"] : @result["length"]
            end
        else
            @message = @result["error"]
        end      
    end

    def validate(word, grid)
        word.upcase.each_char do |letter|
            return false unless word.upcase.scan(letter) === grid.join("").scan(letter)
        end
        return true
    end
end
