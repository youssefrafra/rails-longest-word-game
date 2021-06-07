class GamesController < ApplicationController
    def new
        alphabet = [*("A".."Z")]
        @letters = Array.new(rand(8..12)).map { |el| el = alphabet.sample }
    end

    def score
        # binding.pry
        @answer = params[:answer]
        @grid = eval(params[:grid])
        url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
        uri = URI.parse(url)
        @result = JSON.parse(Net::HTTP.get(uri))
        @valid = (@grid & @answer.upcase.split("")).length === @answer.split("").length
        if(@result["found"])
            if(!@valid)
                @message= "Sorry but <strong>#{@answer}</strong> can't be built out of #{@grid.join(", ")}"
            else
                @message= "Congratulation! <strong>#{@answer}</strong> is a valid english word"
                # cookies[:score] ? cookies[:score] = cookies[:score].to_i + @result["length"] : cookies[:score] = @result["length"]
                cookies[:score] = cookies[:score] ? cookies[:score].to_i + @result["length"] : @result["length"]
            end
        else
            @message = @result["error"]
        end
        # raise
    end
end
