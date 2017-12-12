require 'set'
class Lev
  def initialize(filename)
    file = File.open(filename, "r")
    lines = file.readlines.map(&:strip) #strips the \n character
    #the file has each word in a seperate line
    @wordsSet = Set.new(lines) #so set of all the words
    file.close
  end

  def process(given_word)
    @to_process = [given_word]
    @finished = Set.new() #all the words that are done processing
    while(@to_process.empty? == false)
        word = @to_process.shift #remove first ele
        #if not already done/processed
        if(@finished.member?(word) == false) then
          found = levenshteinDist(word)
          @to_process += found  #combine arrays
          @finished.add(word) #done with that word, on to the next
        end
    end
    @finished.size()
  end

  def levenshteinDist(word)
    accumFound = []
    wordArr = word.split("")
    wordArr.length.times do |i|
      ('A'..'Z').each do |letter|
        if (wordArr[i] != letter) then
          copy = word.dup #still a string
          copy[i] = letter
          if(@wordsSet.member?(copy) && @finished.member?(copy) == false) then
            accumFound.push(copy)
          end
        end
        #check if you can add a letter to find word
        addCopy = word.dup
        addCopy = addCopy.insert(i, letter) #insert to str
        if(@wordsSet.member?(addCopy) && @finished.member?(addCopy) == false) then
          accumFound.push(addCopy)
        end
      end
      #do not need to iterate through letters for check editDistence where the other word does not have a letter
      removeCopy = word.dup
      removeCopy.slice!(i) #remove letter at index
      if(@wordsSet.member?(removeCopy) && @finished.member?(removeCopy) == false) then
        accumFound.push(removeCopy)
      end
    end
    accumFound
  end
end
