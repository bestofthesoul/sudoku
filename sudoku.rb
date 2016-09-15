require 'byebug'

class Sudoku
# x = row_index
#y = col_index
  def initialize(board_string)
    @board = board_string.split("") #split them and make them into string

    @board = @board.map! {|x| x == "0" ? ["1","2","3","4","5","6","7","8","9"]:x} #replacing the "0"(empty) into ["1", ,"9"]
    @board = Array.new(9){@board.shift(9)} #a BIG sudoku board with 9 rows, each row with 9 elements
  end

  def form_hash
    @hash_table = Hash.new {|k,v| k[v]=[]}
    for x in (0...9)
      for y in (0...9)
        if @board[x][y].class == String #those box which already inserted with a figure
          key = "#{x/3}#{y/3}" #by dividing with 3==>9 groups of elements sharing same index NEW X and NEW Y--thats our 9 grids
          @hash_table[key] << @board[x][y] # these known numbers put into this hash
        end
      end
    end
    @hash_table
  end


  def solve!
    unsolved= true

    while unsolved #when its still unsolved...
      form_hash

      @board.each_with_index do |row, x| # these two lines are scanning each value in 1 row then every row
        row.each_with_index do |value, y|
          if value.class == Array && value.length !=1
            value = row_scan(value,x,y)
            value = col_scan(value, x, y)
            value = grid_scan(value, x, y)

            @board[x][y] = value
          end
        end
      end


      #when possibility becomes one only
      unsolved=false #in case it didnt enter row 50 condition, then unsolved remain false, can return board already

      @board.each_with_index do |row, x|
        row.each_with_index do |value, y|
          if value.class == Array && value.length == 1
            @board[x][y] = value[0].to_s
            unsolved = true # so that it will loop to search next value.class==array(continue the while loop)
          end
        end
      end


    end
  return @board
 end


  def row_scan(value,x,y)
    for y in (0...9) # repeat for every element in one row
      if @board[x][y].class == String
        value.delete(@board[x][y])
      end
    end
    return value
  end

  def col_scan(value,x,y)
    for x in (0...9)# repeat for every element in one column
      if @board[x][y].class == String
        value.delete(@board[x][y])
      end
    end
    return value
  end

  def grid_scan(value, x, y)
    @hash_table["#{x/3}#{y/3}"].each do |num|
      value.delete(num)
    end
    return value
  end

  def printers #PRINT NICE NICE
    puts "-"*25
    @board.each_with_index do |row,index| # repeats for every row
      puts "#{row[0]} #{row[1]} #{row[2]} | #{row[3]} #{row[4]} #{row[5]} | #{row[6]} #{row[7]} #{row[8]}" # list everything on 1 row
      if index == 2 || index == 5
        puts "-"*25
      end
    end
  end


end

board_string1 = File.readlines('sample.unsolved.txt').sample

game = Sudoku.new(board_string1)

game.solve!
game.printers